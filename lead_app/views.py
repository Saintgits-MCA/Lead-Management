from datetime import datetime, timedelta
from decimal import Decimal
from io import BytesIO
import json
import uuid
from rest_framework.exceptions import AuthenticationFailed
from django.db import transaction
import os
from django.db.models import Sum
from django.contrib import messages # type: ignore
from django.shortcuts import redirect, render,get_object_or_404 # type: ignore
from django.http import JsonResponse # type: ignore
import random
from django.core.mail import send_mail # type: ignore
from django.conf import settings # type: ignore
from .models import *  # Import your Client model
from django.utils import timezone # type: ignore
from django.utils.timezone import now
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes, force_str
from rest_framework.decorators import api_view, permission_classes# type: ignore
from rest_framework.response import Response# type: ignore
from rest_framework import status# type: ignore
from rest_framework.permissions import BasePermission, IsAuthenticated
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.shortcuts import get_object_or_404
from django.db.models import Q
from decimal import Decimal
import json
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.contrib.auth.decorators import login_required
from django.core.cache import cache
from django.core.files.storage import FileSystemStorage
from django.template.loader import render_to_string

def client_admin_login(request):
    if request.method == "POST":
        username = request.POST.get("username")  # This will be the phone number
        password = request.POST.get("password")

        # Basic validation
        if not username or not password:
            messages.error(request, "Enter both phone number and password correctly.")
            return render(request, "login.html")  # or your login template name

        try:
            # Fetch client where username (phone_number) matches
            client = client_data.objects.get(username=username)

            # Compare plain text password directly
            if client.password == password and client.status=="Active":
                # Login successful - store client info in session
                request.session['client_logged_in'] = True
                request.session['client_id'] = client.id
                request.session['client_name'] = client.client_name or client.username
                request.session['client_phone'] = client.username  # phone

                messages.success(request, f"Welcome back, {client.client_name or username}!")
                return redirect("dashboard")  # redirect to client's dashboard

            else:
                messages.error(request, "Invalid password or you are suspended. Please try again or Contact Company Admin.")

        except client_data.DoesNotExist:
            messages.error(request, "No account found with this phone number.")

        # If login fails, fall through to render login page with error
        return render(request, "login.html")

    # GET request - show login form
    return render(request, "login.html")

def logout(request):
    if request.session.get('client_logged_in'):
        del request.session['client_logged_in']
        del request.session['client_id']
        del request.session['client_name']
        del request.session['client_phone']
    
    messages.success(request, "You have been logged out successfully.")
    return redirect('login')

def client_admin_dashboard(request):
    if not request.session.get('client_logged_in') or not request.session.get('client_id') :
        messages.warning(request, "Please log in to access your dashboard.")
        return redirect('login')

    client_id = request.session.get('client_id')
    client = client_data.objects.get(id=client_id)
    
    employees = employee.objects.filter(client=client_id, status=1)
    employee_count = employees.count()
    employees =employee.objects.filter(client=client_id, status=1).order_by('-id')[:3]
    last_week = timezone.now() - timedelta(days=30)
    lead = leads_table.objects.filter(client=client_id, created_at__gte=last_week).order_by('-created_at')[:7]
    converted_count = leads_table.objects.filter(client=client_id, status='Converted').count()
    lead = leads_table.objects.filter(client=client_id).exclude(status='Deleted')
    lead_count=lead.count()
    quoted_count=quotation.objects.filter(client=client_id).count()
    total_quoted_amount = quotation.objects.filter(
        client_id=client_id
    ).aggregate(total=Sum('total'))['total'] or 0

    current_date = timezone.now().date()
    
    leads_with_pending = []
    for lead in lead:
        pending_days = None
        if lead.next_followup_date:
            pending_days = (lead.next_followup_date - current_date).days
            leads_with_pending.append({'lead': lead, 'pending_days': pending_days})

    today = timezone.now().date()
    week_from_today = today + timedelta(days=31)

    # ← UPDATED: Include both expired AND expiring within 7 days
    upcoming_docs = document.objects.filter(
        client_id=client_id,
        expiry_date__lte=week_from_today,   # Expires on or before 7 days from now
        expiry_date__gte=today              # But not before today (i.e., not already expired too long ago if needed)
    ).exclude(
        expiry_date__lt=today               # Optional: remove this line if you want expired + upcoming
    ).order_by('expiry_date')[:10]

    # ← ALTERNATIVE: Include BOTH expired AND upcoming (recommended)
    docs_needing_attention = document.objects.filter(
        client_id=client_id,
        expiry_date__lte=week_from_today    # Expires within next 7 days OR already expired
    ).order_by('expiry_date')[:10]  # Show soonest first

    reminder_list = []
    for doc in docs_needing_attention:
        days_diff = (doc.expiry_date - today).days

        if days_diff < 0:  # Already expired
            days_text = f"{abs(days_diff)} day{'s' if abs(days_diff) != 1 else ''} ago"
            status = "Expired"
        elif days_diff == 0:
            days_text = "today"
            status = "Expires"
        elif days_diff == 1:
            days_text = "tomorrow"
            status = "Expires"
        else:
            days_text = f"in {days_diff} days"
            status = "Expires"

        reminder_list.append({
            'title': f"{status}: {doc.document_id}",
            'date': doc.expiry_date.strftime("%d-%m-%y"),
            'person': doc.type or "Document",
            'note': f"{doc.title} — {days_text}"
        })

    # ← If no expired docs, show a placeholder or leave empty
    if not reminder_list:
        reminder_list = [{"title": "No expired documents", "date": "", "person": "", "note": "All documents are up to date."}]
    
    lead_qs = leads_table.objects.filter(client=client_id)

    new_count = lead_qs.filter(status='New').count()
    quoted_lead_count = lead_qs.filter(status='Quoted').count()
    followup_count = lead_qs.filter(status='Follow-up').count()
    converted_count = lead_qs.filter(status='Converted').count()
    rejected_count = lead_qs.filter(status='Rejected').count()
    context = {
        "lead": leads_with_pending,
        'leads': lead,
        'lead_count':lead_count,
        'employee': employees,
        'client': client,
        'employees_count': employee_count,
        "converted_count": converted_count,
        'followup_count':followup_count,
        'quoted_count':quoted_count,
        "new_count": new_count,
        "quoted_lead_count": quoted_lead_count,
        "converted_count": converted_count,
        "rejected_count": rejected_count,
        'Quoted_amount': total_quoted_amount,
        "reminders": len(reminder_list) if reminder_list[0]['title'] != "No expired documents" else 0,  # ← Count only real reminders
        "reminder_list": reminder_list  
    }
    return render(request, 'dashboard.html', context)

def employee_list(request):
    client_id=request.session.get('client_id')
    client="None"

    if client_id:
        client=client_data.objects.get(id=client_id)
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')
    employees = employee.objects.filter(client=client_id).order_by('-id')
    context={"employees": employees,"client":client}
    return render(request, "employees.html", context)

def employee_create(request):
    # Get logged-in client (for context/security)
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in to continue.")
        return redirect('login')  # or your client login URL

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session. Please log in again.")
        return redirect('login')

    if request.method == "POST":
        # Extract form data
        employee_code = request.POST.get('employee_code', '').strip()
        employee_name = request.POST.get('employee_name', '').strip()
        gender = request.POST.get('gender')
        email = request.POST.get('email', '').strip()
        mobile = request.POST.get('mobile', '').strip()
        address = request.POST.get('address', '').strip() or None
        designation = request.POST.get('designation', '').strip()
        join_date = request.POST.get('join_date')
        status = request.POST.get('status')  # checkbox returns 'active' if checked
        password=request.POST.get('password')
        # Basic validation
        if not all([employee_code, employee_name, email, mobile, join_date]):
            messages.error(request, "Please fill all required fields.")
            return render(request, "employee_create.html", {"client": client})

        if employee.objects.filter(employee_code__iexact=employee_code).exists():
            messages.error(request, "employee code already exists.")
            return render(request, "employee_create.html", {"client": client})

        if employee.objects.filter(email__iexact=email).exists():
            messages.error(request, "Email already registered.")
            return render(request, "employee_create.html", {"client": client})

        if employee.objects.filter(mobile=mobile).exists():
            messages.error(request, "Mobile number already registered.")
            return render(request, "employee_create.html", {"client": client})

        # Create employee
        employee.objects.create(
            employee_code=employee_code.upper(),
            employee_name=employee_name,
            gender=gender or "Others",
            email=email,
            mobile=mobile,
            address=address,
            designation=designation,
            join_date=join_date,
            status=status,
            client=client,
            Password=password,
        )

        messages.success(request, f"employee '{employee_name}' created successfully!")
        return redirect('employee_list')  # redirect to list after success

    # GET request - show form
    return render(request, "employee_create.html", {"client": client})

def lead_source_list(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    # Get only this client's lead sources
    lead_sources = leadsource.objects.filter(client=client_id,status="Active").order_by('-id')

    # Handle AJAX CRUD
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        action = request.POST.get('action')

        if action == 'add':
            name = request.POST.get('name', '').strip()
            if not name:
                return JsonResponse({"success": False, "message": "Name is required."})
            if leadsource.objects.filter(client=client, name__iexact=name).exists():
                return JsonResponse({"success": False, "message": "This lead source already exists."})
            leadsource.objects.create(client=client, name=name)
            return JsonResponse({"success": True, "message": "lead source added!"})

        elif action == 'edit':
            source_id = request.POST.get('id')
            name = request.POST.get('name', '').strip()
            if not name or not source_id:
                return JsonResponse({"success": False, "message": "Invalid data."})
            try:
                source = leadsource.objects.get(id=source_id, client=client)
                if leadsource.objects.filter(client=client, name__iexact=name).exclude(id=source_id).exists():
                    return JsonResponse({"success": False, "message": "Name already exists."})
                source.name = name
                source.save()
                return JsonResponse({"success": True, "message": "Updated successfully!"})
            except leadsource.DoesNotExist:
                return JsonResponse({"success": False, "message": "Not authorized or not found."})

        elif action == 'delete':
            source_id = request.POST.get('id')
            try:
                source = leadsource.objects.get(id=source_id, client=client)
                source.status="Inactive"
                source.save()
                return JsonResponse({"success": True, "message": "Deleted successfully!"})
            except leadsource.DoesNotExist:
                return JsonResponse({"success": False, "message": "Not authorized or not found."})

    context = {
        "client": client,
        "lead_sources": lead_sources
    }
    return render(request, "lead_source_list.html", context)


def validate_lead_source(request):
    if request.method != "GET":
        return JsonResponse({"exists": False})

    name = request.GET.get('name', '').strip()
    if not name:
        return JsonResponse({"exists": False})

    client_id = request.session.get('client_id')
    if not client_id:
        return JsonResponse({"exists": False})

    try:
        client = client_data.objects.get(id=client_id)
        exists = leadsource.objects.filter(client=client, name__iexact=name).exists()
        return JsonResponse({"exists": exists})
    except client_data.DoesNotExist:
        return JsonResponse({"exists": False})


def product_master(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    products = product.objects.filter(client=client_id,status="Active").order_by('-id')

    # Handle AJAX CRUD
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        action = request.POST.get('action')

        if action == 'add':
            name = request.POST.get('name', '').strip()
            rate = request.POST.get('rate')
            hsn_code = request.POST.get("hsn_code", "")
            gst_type = request.POST.get('gst_type')
            gst = request.POST.get('gst')

            if not all([name, rate, gst_type, gst]):
                return JsonResponse({"success": False, "message": "All fields are required."})

            if product.objects.filter(client=client, name__iexact=name).exists() and action == 'add':
                return JsonResponse({"success": False, "message": "product already exists."})

            product.objects.create(
                client=client,
                hsn_code=hsn_code,
                name=name,
                rate=rate,
                gst_type=gst_type,
                gst=gst
            )
            return JsonResponse({"success": True, "message": "product added successfully!"})

        elif action == 'edit':
            prod_id = request.POST.get('id')
            name = request.POST.get('name', '').strip()
            hsn_code = request.POST.get("hsn_code", "")
            rate = request.POST.get('rate')
            gst_type = request.POST.get('gst_type')
            gst = request.POST.get('gst')

            if not all([prod_id, name, rate, gst_type, gst]):
                return JsonResponse({"success": False, "message": "Invalid data."})

            try:
                products = product.objects.get(id=prod_id, client=client)
                if product.objects.filter(client=client, name__iexact=name).exclude(id=products.id).exists():
                    return JsonResponse({"success": False, "message": "Product already exists."})
                products.name = name
                products.hsn_code=hsn_code
                products.rate = rate
                products.gst_type = gst_type
                products.gst = gst
                products.save()
                return JsonResponse({"success": True, "message": "product updated!"})
            except product.DoesNotExist:
                return JsonResponse({"success": False, "message": "Not authorized."})

        elif action == 'delete':
            prod_id = request.POST.get('id')
            try:
                products = product.objects.get(id=prod_id, client=client)
                products.status="Inactive"
                products.save()
                return JsonResponse({"success": True, "message": "product deleted!"})
            except products.DoesNotExist:
                return JsonResponse({"success": False, "message": "Not authorized."})

    context = {"client": client, "products": products}
    return render(request, "product_master.html", context)

def leads_page(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    lead = leads_table.objects.filter(client=client_id,deleted_at__isnull=True).order_by("-id")
    lead_sources = leadsource.objects.filter(client=client_id,status="Active")  # For dropdown in form
    products_category = enquiryfor.objects.filter(client=client_id,status="Active")        # For product Category dropdown
    employees = employee.objects.filter(client=client_id,status=1)
    
    stats = {
        "total": lead.count(),
        "new": lead.filter(status='New').count(),
        "in_progress": lead.filter(status='Quoted').count(),
        "followup": lead.filter(status='Follow-up').count(),
        "converted": lead.filter(status='Converted').count(),
        "rejected": lead.filter(status='Rejected').count(),
    }

    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        action = request.POST.get('action')

        if action in ['add', 'edit']:
            customer_name = request.POST.get('customer_name', '').strip()
            phone = request.POST.get('phone', '').strip()
            email = request.POST.get('email') or None
            address = request.POST.get('address') or None
            location = request.POST.get('location') or None
            product_category = request.POST.get('product_category', '').strip()
            lead_source_id = request.POST.get('lead_source')
            requirement_details = request.POST.get('requirement_details') or None
            next_followup_date = request.POST.get('next_followup_date') or None
            followup_time = request.POST.get('followup_time') or None
            status = request.POST.get('status', 'New')
            remarks = request.POST.get('remarks') or None
            assign_to = request.POST.get('assign_to') or None

            if not all([customer_name, phone, product_category, lead_source_id]):
                return JsonResponse({"success": False, "message": "Required fields missing."})

            try:
                lead_source = leadsource.objects.get(id=lead_source_id, client=client)
            except leadsource.DoesNotExist:
                return JsonResponse({"success": False, "message": "Invalid lead source."})

            # if leads_table.objects.filter(client=client, phone=phone).exclude(id=request.POST.get('id')).exists():
            #     return JsonResponse({"success": False, "message": "Phone already used."})

            if action == 'add':
                leads_table.objects.create(
                    client=client,
                    customer_name=customer_name,
                    phone=phone,
                    email=email,
                    address=address,
                    location=location,
                    product_category=product_category,
                    lead_source=lead_source,
                    requirement_details=requirement_details,
                    next_followup_date=next_followup_date,
                    followup_time=followup_time,
                    status=status,
                    remarks=remarks,
                    assign_to=assign_to,
                    created_at=timezone.now(),
                )
                return JsonResponse({"success": True, "message": "lead added!"})

            elif action == 'edit':
                try:
                    lead = leads_table.objects.get(id=request.POST.get('id'), client=client)
                    lead.customer_name = customer_name
                    lead.phone = phone
                    lead.email = email
                    lead.address = address
                    lead.location = location
                    lead.product_category = product_category
                    lead.lead_source = lead_source
                    lead.requirement_details = requirement_details
                    lead.next_followup_date = next_followup_date
                    lead.followup_time = followup_time
                    lead.status = status
                    lead.remarks = remarks
                    lead.assign_to = assign_to
                    lead.updated_at = timezone.now()
                    lead.save()
                    return JsonResponse({"success": True, "message": "lead updated!"})
                except lead.DoesNotExist:
                    return JsonResponse({"success": False, "message": "lead not found."})

        elif action == 'delete':
            try:
                lead = leads_table.objects.get(id=request.POST.get('id'), client=client)
                lead.status="Deleted"
                lead.deleted_at=timezone.now()
                lead.save()
                return JsonResponse({"success": True, "message": "lead deleted!"})
            except lead.DoesNotExist:
                return JsonResponse({"success": False, "message": "Not found."})
    lead = leads_table.objects.filter(client=client_id, deleted_at__isnull=True).order_by("-id")
    context = {
        "client": client,
        "leads": lead,
        "stats": stats,
        "lead_sources": lead_sources,  # Pass for dropdown
        "enquiry_category": products_category,       
        "employees": employees,
    }
    return render(request, "leads.html", context)

def client_admin_profile(request):
    if not request.session.get('client_logged_in'):
        messages.warning(request, "Please log in to access your profile.")
        return redirect('login')

    client_id = request.session.get('client_id')
    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Session error. Please log in again.")
        return redirect('login')

    # Build profile dict with real data
    profile = {
        "client_name": client.client_name or "—",
        "phone": client.phone_number,
        "business_name": client.business_name or "",
        "website": client.website or "",
        "gst": client.gst or "",
        "address": client.address or "",
        # Logo URL: if exists, use /media/ + relative path, else default
        "logo": f"/media/{client.logo}" if client.logo else "{% static 'images/default-logo.png' %}",
    }

    return render(request, "client_admin_profile.html", {
        "profile": profile,
        "client": client
    })
    

def save_client_profile(request):
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid request"}, status=400)

    if not request.session.get('client_logged_in'):
        return JsonResponse({"success": False, "message": "Please log in again."}, status=400)

    client_id = request.session.get('client_id')
    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        return JsonResponse({"success": False, "message": "Client not found."}, status=404)

    # Store old logo path for deletion
    old_logo_path = client.logo

    # Update allowed fields
    client.business_name = request.POST.get('business_name', client.business_name).strip()
    client.gst = request.POST.get('gst', '').strip() or None
    client.address = request.POST.get('address', '').strip() or None
    client.about = request.POST.get("about", "")
    new_logo_path = None

    # Handle new logo upload
    if 'logo_file' in request.FILES:
        logo_file = request.FILES['logo_file']

        if not logo_file.content_type.startswith('image/'):
            return JsonResponse({"success": False, "message": "Invalid image file."}, status=400)

        if logo_file.size > 2 * 1024 * 1024:
            return JsonResponse({"success": False, "message": "Image must be under 2MB."}, status=400)

        ext = logo_file.name.split('.')[-1].lower()
        filename = f"logo.{ext}"
        upload_dir = os.path.join(settings.MEDIA_ROOT, 'client_logos', client.phone_number)
        os.makedirs(upload_dir, exist_ok=True)

        new_file_path = os.path.join(upload_dir, filename)

        # Save new file
        with open(new_file_path, 'wb+') as f:
            for chunk in logo_file.chunks():
                f.write(chunk)

        # New relative path
        new_logo_path = os.path.join('client_logos', client.phone_number, filename)

    # Update logo field only if new image uploaded
    if new_logo_path:
        client.logo = new_logo_path

    client.save()

    # === DELETE OLD LOGO FILE IF EXISTS AND DIFFERENT ===
    if old_logo_path and new_logo_path and old_logo_path != new_logo_path:
        old_file_full_path = os.path.join(settings.MEDIA_ROOT, old_logo_path)
        if os.path.exists(old_file_full_path):
            try:
                os.remove(old_file_full_path)
                # Optional: remove empty directory
                old_dir = os.path.dirname(old_file_full_path)
                if not os.listdir(old_dir):
                    os.rmdir(old_dir)
            except Exception as e:
                print(f"Error deleting old logo: {e}")  # Log but don't fail save

    return JsonResponse({
        "success": True,
        "message": "Profile updated successfully!"
    })
# ---------------- COMPANY LOGIN ----------------
def company_login(request):
    if request.method == "POST":
        try:
            company.objects.get(
                username=request.POST.get("username"),
                password=request.POST.get("password")
            )
            request.session["company_logged_in"] = True
            messages.success(request, "Login Successful")
            return redirect("company_dashboard")

        except company.DoesNotExist:
            messages.error(request, "Invalid username or password")

    return render(request, "company/company_login.html")

def company_logout(request):   
    messages.success(request, "You have been logged out successfully.")
    return redirect('company_login')

# ---------------- DASHBOARD ----------------
def company_dashboard(request):
    if not request.session.get("company_logged_in"):
        return redirect("company_login")

    total_clients = client_data.objects.count()
    suspended_clients = client_data.objects.filter(status="Suspended").count()
    active_clients = total_clients - suspended_clients

    # Get the most recent 5 clients (ordered by creation date descending)
    recent_clients = client_data.objects.all().order_by('-created_at')[:3]

    stats = {
        "total_clients": total_clients,
        "active_clients": active_clients,
        "suspended_clients": suspended_clients,
        "reminders": 5,  
        "payment_reminders": 4,
    }

    context = {
        "stats": stats,
        "recent_clients": recent_clients,  # Pass to template
    }

    return render(request, "company/company_dashboard.html", context)


# ---------------- CLIENT LIST ----------------
def company_clients(request):
    clients = client_data.objects.all().order_by('-created_at')

    # Filters
    name = request.GET.get('name', '').strip()
    phone = request.GET.get('phone', '').strip()
    status = request.GET.get('status', '').strip()

    if name:
        clients = clients.filter(client_name__icontains=name)
    if phone:
        clients = clients.filter(phone_number__icontains=phone)
    if status:
        clients = clients.filter(status=status)

    return render(request, "company/clients.html", {"clients": clients})



# ---------------- CREATE CLIENT ----------------

def create_client(request):
    if request.method == "POST":
        client_name = request.POST.get("client_name", "").strip()
        business_name = request.POST.get("business_name", "").strip()
        phone_number = request.POST.get("phone", "").strip()
        email = request.POST.get("email", "").strip()
        status = request.POST.get("status", "Active")

        gst = request.POST.get("gst", "").strip() or None
        website = request.POST.get("website", "").strip() or None
        address = request.POST.get("address", "").strip() or None
        raw_password = request.POST.get("password", "").strip()

        # Validation
        if not all([client_name, business_name, phone_number, email]):
            return JsonResponse({"success": False, "message": "Required fields missing."}, status=400)

        if not phone_number.isdigit() or len(phone_number) != 10:
            return JsonResponse({"success": False, "message": "Invalid phone number."}, status=400)

        if client_data.objects.filter(username=phone_number).exists():
            return JsonResponse({"success": False, "message": "Phone already registered."}, status=400)

        # Auto password
        if not raw_password:
            name_part = "".join([c for c in client_name if c.isalpha()])[:3].upper() or "CLI"
            phone_part = phone_number[-4:]
            chars = "ABCDEFGHJKLMNPQRSTUVWXYZ123456789"
            raw_password = f"{name_part}{phone_part}@{random.choice(chars)}{random.choice(chars)}"

        logo_path = None

        # Priority: Upload takes precedence over URL
        if 'logo_file' in request.FILES:
            logo_file = request.FILES['logo_file']
            ext = logo_file.name.split('.')[-1].lower()
            if ext not in ['png', 'jpg', 'jpeg', 'gif', 'webp']:
                return JsonResponse({"success": False, "message": "Invalid image format."}, status=400)

            filename = f"logo.{ext}"
            upload_dir = os.path.join(settings.MEDIA_ROOT, 'client_logos', phone_number)
            os.makedirs(upload_dir, exist_ok=True)
            file_path = os.path.join(upload_dir, filename)

            with open(file_path, 'wb+') as f:
                for chunk in logo_file.chunks():
                    f.write(chunk)

            logo_path = os.path.join('client_logos', phone_number, filename)

        # Fallback to URL if no upload
        elif request.POST.get("logo_url", "").strip():
            logo_path = request.POST.get("logo_url").strip()

        # Create client
        client_data.objects.create(
            username=phone_number,
            password=raw_password,
            client_name=client_name,
            business_name=business_name,
            phone_number=phone_number,
            email=email,
            status=status,
            gst=gst,
            website=website,
            address=address,
            logo=logo_path,  # ← Saves relative path or external URL
        )

        # Email & response
        login_url = request.build_absolute_uri("/")
        try:
            send_mail(
                "Your CRM Login Credentials",
                f"Hello {client_name},\n\nUsername: {phone_number}\nPassword: {raw_password}\nLogin: {login_url}",
                settings.DEFAULT_FROM_EMAIL,
                [email],
                fail_silently=False,
            )
        except:
            pass  # Already handled in previous versions

        return JsonResponse({
            "success": True,
            "client_name": client_name,
            "username": phone_number,
            "password": raw_password,
            "login_url": login_url,
            "message": "Client created successfully!"
        })

    return render(request, "company/create_client.html")


def client_detail(request, id):
    try:
        client = client_data.objects.get(id=id)
        return JsonResponse({
            "id": client.id,
            "client_name": client.client_name,
            "password":client.password,
            "business_name": client.business_name,
            "phone_number": client.phone_number,
            "email": client.email,
            "gst": client.gst,
            "website": client.website,
            "logo": client.logo,  # relative path like "client_logos/123/logo.png"
            "address": client.address,
            "status": client.status,
            "created_at": client.created_at.isoformat()
        })
    except client_data.DoesNotExist:
        return JsonResponse({"error": "Client not found"}, status=404)

def delete_client(request, id):
    if request.method == "POST":
        try:
            client = client_data.objects.get(id=id)
            client.status = "Suspended" if client.status == "Active" else "Active"
            client.save()
            return JsonResponse({
                "success": True,
                "message": f"Client is now {client.status}"
            })
        except client_data.DoesNotExist:
            return JsonResponse({"success": False, "message": "Client not found"})
    return JsonResponse({"success": False, "message": "Invalid request"})

def update_client(request):
    if request.method == "POST":
        client_id = request.POST.get('id')
        try:
            client = client_data.objects.get(id=client_id)

            # Update text fields
            client.client_name = request.POST.get('client_name', client.client_name)
            client.business_name = request.POST.get('business_name', client.business_name)
            client.phone_number = request.POST.get('phone_number', client.phone_number)  # usually readonly
            client.email = request.POST.get('email', client.email)
            client.gst = request.POST.get('gst') or None
            client.website = request.POST.get('website') or None
            client.address = request.POST.get('address') or None
            client.status = request.POST.get('status', client.status)

            # Handle logo upload (new image replaces old one)
            if 'logo_file' in request.FILES:
                logo_file = request.FILES['logo_file']

                # Validate file type
                if not logo_file.content_type.startswith('image/'):
                    return JsonResponse({
                        "success": False,
                        "message": "Please upload a valid image file."
                    }, status=400)

                # Optional: limit size to 2MB
                if logo_file.size > 2 * 1024 * 1024:
                    return JsonResponse({
                        "success": False,
                        "message": "Image size should not exceed 2MB."
                    }, status=400)

                # Define path: media/client_logos/<phone_number>/logo.<ext>
                ext = logo_file.name.split('.')[-1].lower()
                filename = f"logo.{ext}"
                upload_dir = os.path.join(settings.MEDIA_ROOT, 'client_logos', client.phone_number)
                os.makedirs(upload_dir, exist_ok=True)

                file_path = os.path.join(upload_dir, filename)

                # Save the file
                with open(file_path, 'wb+') as destination:
                    for chunk in logo_file.chunks():
                        destination.write(chunk)

                # Save relative path to logo URLField
                client.logo = os.path.join('client_logos', client.phone_number, filename)

            client.save()

            return JsonResponse({
                "success": True,
                "message": "Client updated successfully!"
            })

        except client_data.DoesNotExist:
            return JsonResponse({
                "success": False,
                "message": "Client not found."
            }, status=404)
        except Exception as e:
            return JsonResponse({
                "success": False,
                "message": "An error occurred while updating."
            }, status=500)

    return JsonResponse({
        "success": False,
        "message": "Invalid request method."
    }, status=400)
    
    
def get_employee(request, id):
    try:
        client=request.session.get("client_id")
        emp = employee.objects.get(id=id,client=client)
        return JsonResponse({
            "id": emp.id,
            "employee_code": emp.employee_code,
            "employee_name": emp.employee_name,
            "gender": emp.gender,
            "email": emp.email,
            "mobile": emp.mobile,
            "designation": emp.designation,
            "join_date": emp.join_date.strftime("%Y-%m-%d"),
            "address": emp.address or "",
            "status": emp.status,
            "password":emp.Password,
        })
    except employee.DoesNotExist:
        return JsonResponse({"error": "Not found"}, status=404)

def update_employee(request):
    if employee.objects.filter(employee_code=request.POST.get('employee_code')).exclude(id=request.POST.get('id')).exists():
         messages.error(request,"This employee code already exists/assigned.")
    if request.method == "POST":
        try:
            emp = employee.objects.get(id=request.POST.get('id'))
            emp.employee_code = request.POST.get('employee_code')
            emp.employee_name = request.POST.get('employee_name')
            emp.gender = request.POST.get('gender')
            emp.email = request.POST.get('email')
            emp.mobile = request.POST.get('mobile')
            emp.designation = request.POST.get('designation')
            emp.join_date = request.POST.get('join_date')
            emp.address = request.POST.get('address') or None
            emp.status = request.POST.get('status') == 'active'
            emp.Password=request.POST.get('password')
            emp.save()
            return JsonResponse({"success": True, "message": "Updated successfully"})
        except employee.DoesNotExist:
            return JsonResponse({"success": False, "message": "employee not found"})
    return JsonResponse({"success": False, "message": "Invalid request"})

def delete_employee(request, id):
    if request.method == "POST":
        try:
            employees = employee.objects.get(id=id)
            employees.status = "Inactive" if employee.status == "Active" else "Active"
            employees.save()
            return JsonResponse({
                "success": True,
                "message": f"employee is now {employees.status}"
            })
        except employee.DoesNotExist:
            return JsonResponse({"success": False, "message": "employee not found"})
    return JsonResponse({"success": False, "message": "Invalid request"})

def get_lead(request, lead_id):
    client_id = request.session.get('client_id')
    if not client_id:
        return JsonResponse({"success": False, "message": "Unauthorized"}, status=400)

    try:
        lead = leads_table.objects.get(id=lead_id, client_id=client_id, deleted_at__isnull=True)
        remarks = followupremark.objects.filter( lead_id=lead_id, client_id=client_id).order_by('-remark_date', '-created_at').values( 'remark_date', 'remark_text')
        data = {
            "id": lead.id,
            "customer_name": lead.customer_name,
            "phone": lead.phone,
            "email": lead.email or "",
            "address": lead.address or "",
            "location": lead.location or "",
            "created_at":lead.created_at.strftime("%d-%m-%Y") if lead.created_at else None,
            "updated_at":lead.updated_at.strftime("%d-%m-%Y") if lead.updated_at else None,
            "product_category": lead.product_category,
            "lead_source": lead.lead_source.id,
            "lead_source_name":lead.lead_source.name,
            "requirement_details": lead.requirement_details or "",
            "next_followup_date": lead.next_followup_date.strftime("%Y-%m-%d") if lead.next_followup_date else "",
            "followup_time": lead.followup_time.strftime("%H:%M") if lead.followup_time else "",
            "status": lead.status,
            "remarks": lead.remarks or "",
            "followup_remarks":list(remarks),
            "assign_to": lead.assign_to or "",
        }
        return JsonResponse({"success": True, "data": data})
    except lead.DoesNotExist:
        return JsonResponse({"success": False, "message": "lead not found or access denied"}, status=404)
    
    
def enquiry_category_list(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please login first.")
        return redirect('login')

    client = get_object_or_404(client_data, id=client_id)
    categories = enquiryfor.objects.filter(client=client_id,status="Active").order_by('-created_at')

    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        action = request.POST.get('action')

        if action == 'add':
            name = request.POST.get('name', '').strip()

            if not name:
                return JsonResponse({"success": False, "message": "Name is required."})
            if enquiryfor.objects.filter(client=client, name__iexact=name).exists():
                return JsonResponse({"success": False, "message": "This category already exists."})
            else:
                enquiryfor.objects.create(client=client, name=name)
                return JsonResponse({"success": True, "message": "Category added successfully!"})

        elif action == 'edit':
            cat_id = request.POST.get('id')
            name = request.POST.get('name', '').strip()
            if not name:
                return JsonResponse({"success": False, "message": "Name is required."})
            category = get_object_or_404(enquiryfor, id=cat_id, client=client)
            if enquiryfor.objects.filter(client=client, name__iexact=name).exclude(id=cat_id).exists():
                return JsonResponse({"success": False, "message": "This category already exists."})
            else:
                category.name = name
                category.save()
                return JsonResponse({"success": True, "message": "Category updated successfully!"})

        elif action == 'delete':
            cat_id = request.POST.get('id')
            category = get_object_or_404(enquiryfor, id=cat_id, client=client)
            category.status="Inactive"
            category.save()
            return JsonResponse({"success": True, "message": "Category deleted successfully!"})

    context = {
        'client': client,
        'enquiry_categories': categories,  
    }
    return render(request, 'enquiry_category.html', context)

def generate_quotation_number(client):
    today = now().strftime("%Y%m%d")  # YYYYMMDD

    count_today = quotation.objects.filter(
        client=client,
        created_at__date=now().date()
    ).count() + 1

    return f"QUO-{client.id}_{today}{str(count_today).zfill(5)}"

def quotation_maker(request, lead_id=None):
    client_id = request.session.get('client_id')
    if not client_id:
        return JsonResponse({'success': False, 'message': 'Login required'})

    client = get_object_or_404(client_data, id=client_id)

    if request.method == 'POST':
        try:
             with transaction.atomic():  

                lead = get_object_or_404(
                    leads_table,
                    id=request.POST.get('lead_id'),
                    client=client
                )

                existing_quote = quotation.objects.filter(
                    lead=lead,
                    client=client
                ).first()

                if existing_quote:
                    messages.warning(
                        request,
                        f"quotation already exists (No: {existing_quote.quotation_number})"
                    )
                    return redirect("leads")

                quotations = quotation.objects.create(
                    client=client,
                    lead=lead,
                    quotation_number=generate_quotation_number(client),

                    client_name=request.POST.get('client_name'),
                    client_phone=request.POST.get('client_phone'),
                    client_email=request.POST.get('client_email', ''),
                    client_address=request.POST.get('client_address', ''),

                    subtotal=Decimal(request.POST.get('subtotal')),
                    gst_amount=Decimal(request.POST.get('gst_amount')),

                    cgst=Decimal(request.POST.get('cgst', 0)) or None,
                    sgst=Decimal(request.POST.get('sgst', 0)) or None,
                    igst=Decimal(request.POST.get('igst', 0)) or None,

                    total=Decimal(request.POST.get('total')),
                    valid_upto=request.POST.get('valid_upto'),
                    notes=request.POST.get('notes', ''),
                    version=1,
                )

                product_ids = request.POST.getlist('product_id[]')
                quantities = request.POST.getlist('quantity[]')
                rates = request.POST.getlist('rate[]')
                descriptions = request.POST.getlist('description[]')
                units = request.POST.getlist('unit[]')
                specs = request.POST.getlist('spec[]')

                if not any(product_ids):
                    raise ValueError("At least one product is required")

                for i, product_id in enumerate(product_ids):
                    if not product_id:
                        continue

                    qty = Decimal(quantities[i])
                    rate = Decimal(rates[i])
                    amount = qty * rate

                    products = get_object_or_404(
                        product,
                        id=product_id,
                        client=client
                    )

                    gst_rate = products.gst

                    # ✅ PER-ITEM GST LOGIC
                    if products.gst_type == "IGST":
                        igst_amt = amount * gst_rate / 100
                        cgst_amt = sgst_amt = None
                    else:
                        cgst_amt = amount * gst_rate / 200
                        sgst_amt = cgst_amt
                        igst_amt = None

                    quotationitem.objects.create(
                        quotation=quotations,
                        product=products,
                        description=descriptions[i] if i < len(descriptions) else "",
                        spec=specs[i] if i < len(specs) else "",
                        unit=units[i] if i < len(units) else "",
                        quantity=qty,
                        rate=rate,
                        amount=amount,
                        cgst=cgst_amt,
                        sgst=sgst_amt,
                        igst=igst_amt,
                    )

                lead.status = "Quoted"
                lead.save()

                messages.success(request, "quotation saved successfully")
                return redirect("leads")

        except Exception as e:
            # 🔥 EVERYTHING ROLLS BACK HERE
            messages.error(request, str(e))
            return redirect("quotation_maker", lead_id=request.POST.get("lead_id"))

    else:
        lead = get_object_or_404(leads_table, id=lead_id, client=client) if lead_id else None
        products = product.objects.filter(client=client)

        return render(request, 'quotation_maker.html', {
            'lead': lead,
            'products': products,
            'client': client
        })
def number_to_words_indian(amount):
    ones = (
        "", "One", "Two", "Three", "Four", "Five", "Six",
        "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
        "Thirteen", "Fourteen", "Fifteen", "Sixteen",
        "Seventeen", "Eighteen", "Nineteen"
    )
    tens = (
        "", "", "Twenty", "Thirty", "Forty", "Fifty",
        "Sixty", "Seventy", "Eighty", "Ninety"
    )

    def two_digits(n):
        if n < 20:
            return ones[n]
        return tens[n // 10] + (" " + ones[n % 10] if n % 10 else "")

    def three_digits(n):
        return ones[n // 100] + " Hundred " + two_digits(n % 100) if n > 99 else two_digits(n)

    num = int(amount)
    words = ""

    crore = num // 10000000
    num %= 10000000
    lakh = num // 100000
    num %= 100000
    thousand = num // 1000
    num %= 1000
    hundred = num

    if crore:
        words += three_digits(crore) + " Crore "
    if lakh:
        words += three_digits(lakh) + " Lakh "
    if thousand:
        words += three_digits(thousand) + " Thousand "
    if hundred:
        words += three_digits(hundred)

    return words.strip() + " Rupees Only"

      
def quotation_pdf(request, quotation_id,client_id=None):
    client = get_object_or_404(client_data, id=request.session.get('client_id') or client_id)
    quotations = get_object_or_404(quotation, id=quotation_id, client=client)
    raw_items = quotations.items.select_related('product')
    amount_words = number_to_words_indian(quotations.total)

    items = []
    gst_types = set()  # track GST types in all items

    for item in raw_items:
        cgst_percent = sgst_percent = igst_percent = 0
        row_total = item.amount  # start with taxable amount

        if item.amount and item.cgst:
            cgst_percent = round((item.cgst / item.amount) * 100, 2)
            row_total += item.cgst
        if item.amount and item.sgst:
            sgst_percent = round((item.sgst / item.amount) * 100, 2)
            row_total += item.sgst
        if item.amount and item.igst:
            igst_percent = round((item.igst / item.amount) * 100, 2)
            row_total += item.igst

        # Track GST type
        if item.igst and item.igst > 0:
            gst_types.add('IGST')
        elif (item.cgst and item.cgst > 0) or (item.sgst and item.sgst > 0):
            gst_types.add('GST')

        items.append({
            'product': item.product,
            'description': item.description,
            'spec':item.spec,
            'quantity': item.quantity,
            'unit': item.unit,
            'rate': item.rate,
            'amount': item.amount,
            'cgst': item.cgst,
            'sgst': item.sgst,
            'igst': item.igst,
            'cgst_percent': cgst_percent,
            'sgst_percent': sgst_percent,
            'igst_percent': igst_percent,
            'row_total': row_total,
        })

    # Decide which columns to show
    show_igst = 'IGST' in gst_types
    show_cgst_sgst = 'GST' in gst_types

    terms_condition = terms_conditions.objects.filter(client=request.session.get('client_id') or client_id).first()

    context = {
        'quotation': quotations,
        'items': items,
        'client': client,
        'amount_words': amount_words,
        'terms_conditions': terms_condition if terms_condition else None,
        'show_igst': show_igst,
        'show_cgst_sgst': show_cgst_sgst,
    }

    # html = render_to_string('quotation_pdf.html', context)
    # result = BytesIO()
    # pdf = pisa.pisaDocument(BytesIO(html.encode("UTF-8")), result)

    # if not pdf.err:
    #     response = HttpResponse(result.getvalue(), content_type='application/pdf')
    #     response['Content-Disposition'] = f'inline; filename="quotation_{quotation.id}.pdf"'
    #     return response

    # return HttpResponse("Error generating PDF", status=500)
    return render(request, 'quotation_pdf.html', context)

def edit_quotation(request, quotation_id):
    client = get_object_or_404(client_data, id=request.session.get('client_id'))
    quotations = get_object_or_404(quotation, id=quotation_id, client=client)

    if request.method == "POST":
        # Update main fields
        quotations.client_name = request.POST.get("client_name")
        quotations.client_phone = request.POST.get("client_phone")
        quotations.client_email = request.POST.get("client_email", "")
        quotations.client_address = request.POST.get("client_address", "")
        quotations.valid_upto = request.POST.get("valid_upto")
        quotations.notes = request.POST.get("notes", "")

        quotations.subtotal = Decimal(request.POST.get("subtotal", "0"))
        quotations.cgst = Decimal(request.POST.get("cgst", "0"))
        quotations.sgst = Decimal(request.POST.get("sgst", "0"))
        quotations.igst = Decimal(request.POST.get("igst", "0"))
        quotations.total = Decimal(request.POST.get("total", "0"))

        # Update gst_type and gst_amount
        if quotations.igst > 0:
            quotations.gst_type = 'IGST'
            quotations.gst_amount = quotations.igst
        else:
            quotations.gst_type = 'GST'
            quotations.gst_amount = quotations.cgst + quotations.sgst
        if quotations.version in [None, "", "1"]:
            quotations.version = "2"
        else:
            quotations.version = str(Decimal(quotations.version) + 1)
        quotations.save()

        # Get form data
        product_ids = request.POST.getlist("product_id[]")
        quantities = request.POST.getlist("quantity[]")
        rates = request.POST.getlist("rate[]")
        amounts = request.POST.getlist("amount[]")  # taxable amount per item
        descriptions = request.POST.getlist("description[]")
        units = request.POST.getlist("unit[]")
        specs = request.POST.getlist('spec[]')
        incoming_product_ids = [pid for pid in product_ids if pid]

        # Delete removed items
        quotationitem.objects.filter(quotation=quotations).exclude(product_id__in=incoming_product_ids).delete()

        # Update or create items with per-item GST
        gst_type = quotation.gst_type

        for i in range(len(product_ids)):
            pid = product_ids[i]
            if not pid:
                continue

            products = get_object_or_404(product, id=pid, client=client)
            qty = int(quantities[i] or 1)
            rate = Decimal(rates[i] or "0")
            taxable_amount = qty * rate

            gst_rate = Decimal(products.gst)

            if gst_type == 'IGST':
                igst_amt = taxable_amount * gst_rate / 100
                cgst_amt = sgst_amt = None
            else:
                cgst_amt = sgst_amt = taxable_amount * gst_rate / 200
                igst_amt = None
            
            quotationitem.objects.update_or_create(
    quotation=quotations,
    product_id=pid,
    defaults={
        'product': products,
        'description': descriptions[i] if i < len(descriptions) else "",
        'spec':specs[i] if i < len(specs) else "",
        'unit': units[i] if i < len(units) else "",
        'quantity': qty,
        'rate': rate,
        'amount': taxable_amount,
        'cgst': cgst_amt,
        'sgst': sgst_amt,
        'igst': igst_amt,
    }
)

        messages.success(request, "quotation updated successfully!")
        return redirect("leads")

    # GET: Load edit form
    items = quotations.items.select_related('product').all()
    products = product.objects.filter(client=client)

    context = {
        "client": client,
        "lead": quotations.lead,
        "quotation": quotations,
        "items": items,
        "products": products,
        "is_edit": True,
    }
    return render(request, "quotation_edit.html", context)


def followup(request, lead_id=None):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    lead = leads_table.objects.filter(client=client_id, deleted_at__isnull=True)
    lead_sources = leadsource.objects.filter(client=client_id, status="Active")
    products_category = enquiryfor.objects.filter(client=client_id, status="Active")
    employees = employee.objects.filter(client=client_id, status=1)
    today = timezone.now().date()
    stats = {
        "total": lead.count(),
        "new": lead.filter(status='New').count(),
        "in_progress": lead.filter(status='Quoted').count(),
        "followup": lead.filter(status='Follow-up').count(),
        "converted": lead.filter(status='Converted').count(),
        "rejected": lead.filter(status='Rejected').count(),
    }

    # ← ADD AJAX HANDLING FOR FOLLOWUP UPDATE
    if request.method == "POST" and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        try:
            with transaction.atomic():
                lead_id = request.POST.get('id')
                next_followup_date = request.POST.get('next_followup_date') or None
                followup_time = request.POST.get('followup_time') or None
                status = request.POST.get('status')
                remarks = request.POST.getlist('remarks[]')  # assuming list of remark texts

                lead = leads_table.objects.select_for_update().get(id=lead_id, client=client_id)
                if followup_time:
                    followup_time = datetime.strptime(followup_time, "%H:%M").time()
                # ← UPDATE OR CREATE FollowUp
                followup_obj, created = followup_table.objects.update_or_create(
                    lead_id=lead_id,
                    client_id=client_id,
                    defaults={
                        'status': status,
                        'next_followup_date': next_followup_date,
                        'next_followup_time': followup_time,
                    }
                )

                # ← SAVE REMARKS
                if remarks:
                    for remark_text in remarks:
                        if remark_text.strip():
                            followupremark.objects.create(
                                followup_id=followup_obj,
                                lead_id=lead_id,
                                client_id=client_id,
                                remark_text=remark_text.strip()
                            )

                # ← UPDATE LEAD STATUS TO MATCH FOLLOWUP
                lead.status = status
                if status.lower() == "converted":
                    lead.converted_at = timezone.now()
                lead.next_followup_date = next_followup_date
                lead.followup_time = followup_time
                lead.save()

            return JsonResponse({"success": True, "message": "Follow-up updated successfully"})

        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    # ← ORIGINAL GET LOGIC (unchanged)
    lead = leads_table.objects.filter(client=client_id, deleted_at__isnull=True, status__in=["Quoted","Converted","Follow-up","Rejected"]).prefetch_related('quotation_set')
    context = {
        "client": client,
        "leads": lead,
        "stats": stats,
        "lead_sources": lead_sources,
        "enquiry_category": products_category,
        "employees": employees,
        "today": today,
    }
    return render(request, "followup.html", context)

def document_master(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    documents = document.objects.filter(client_id=client_id)

    if request.method == "POST" and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        data = json.loads(request.body)
        action = data.get('action')

        try:
            if action in ["add", "edit"]:
                doc_id = data['document_id'].strip().upper()
                title = data['title'].strip()
                description = data.get('description', '').strip()
                doc_type = data.get('type', 'Other').strip()  # ← Now free text
                expiry_date = data.get('expiry_date') or None  # ← Can be null or empty
                if expiry_date == "":
                    expiry_date = None

                # Duplicate check
                if action == "add":
                    if document.objects.filter(client_id=client_id, document_id=doc_id).exists():
                        return JsonResponse({"success": False, "message": "Document ID already exists."})

                    document.objects.create(
                        client_id=client_id,
                        document_id=doc_id,
                        title=title,
                        description=description,
                        type=doc_type,
                        expiry_date=expiry_date
                    )
                    return JsonResponse({"success": True, "message": "Document added successfully!"})

                elif action == "edit":
                    doc = get_object_or_404(document, id=data['id'], client_id=client_id)
                    new_doc_id = doc_id

                    if doc.document_id != new_doc_id and document.objects.filter(
                        client_id=client_id, document_id=new_doc_id).exists():
                        return JsonResponse({"success": False, "message": "Document ID already exists."})

                    doc.document_id = new_doc_id
                    doc.title = title
                    doc.description = description
                    doc.type = doc_type  # ← Updated to free text
                    doc.expiry_date = expiry_date
                    doc.save()
                    return JsonResponse({"success": True, "message": "Document updated successfully!"})

            elif action == "delete":
                doc = get_object_or_404(document, id=data['id'], client_id=client_id)
                doc.delete()
                return JsonResponse({"success": True, "message": "Document deleted successfully!"})

        except Exception as e:
            return JsonResponse({"success": False, "message": str(e)}, status=400)

    context = {
        "client": client,
        "documents": documents,
    }
    return render(request, "document_master.html", context)

def reminder_list_view(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    today = timezone.now().date()
    week_from_today = today + timedelta(days=30)

    # Get documents expiring within 7 days OR already expired
    docs = document.objects.filter(
        client_id=client_id,
        expiry_date__lte=week_from_today
    ).order_by('expiry_date')

    reminder_list = []
    for doc in docs:
        days_diff = (doc.expiry_date - today).days

        if days_diff < 0:
            status = "Expired"
            days_text = f"{abs(days_diff)} day{'s' if abs(days_diff) != 1 else ''} ago"
        elif days_diff == 0:
            status = "Expires today"
            days_text = "today"
        elif days_diff == 1:
            status = "Expires tomorrow"
            days_text = "tomorrow"
        else:
            status = f"Expires in {days_diff} days"
            days_text = f"in {days_diff} days"

        reminder_list.append({
            'id': doc.id,
            'document_id': doc.document_id,
            'title': doc.title,
            'type': doc.type,
            'expiry_date': doc.expiry_date.strftime("%d-%m-%Y"),
            'status': status,
            'days_text': days_text,
            'description': doc.description or "—",
        })

    context = {
        'client': client,
        'reminder_list': reminder_list,
        'total_reminders': len(reminder_list),
    }
    return render(request, 'reminder_list.html', context)


def client_settings_view(request):
    client_id = request.session.get('client_id')
    if not client_id:
        messages.error(request, "Please log in.")
        return redirect('login')

    try:
        client = client_data.objects.get(id=client_id)
    except client_data.DoesNotExist:
        messages.error(request, "Invalid session.")
        return redirect('login')

    if request.method == "POST":
        action_taken = False

        # === DELETE HEADER IMAGE ===
        if 'delete_header' in request.POST:
            if client.header_image:
                if os.path.isfile(client.header_image.path):
                    os.remove(client.header_image.path)
                client.header_image = None
                action_taken = True
                messages.success(request, "Header image deleted successfully!")

        # === DELETE FOOTER IMAGE ===
        if 'delete_footer' in request.POST:
            if client.quotation_footer_image:
                if os.path.isfile(client.quotation_footer_image.path):
                    os.remove(client.quotation_footer_image.path)
                client.quotation_footer_image = None
                action_taken = True
                messages.success(request, "quotation footer image deleted successfully!")

        # === UPLOAD NEW HEADER IMAGE ===
        if 'header_image' in request.FILES:
            new_header = request.FILES['header_image']
            if client.header_image and os.path.isfile(client.header_image.path):
                os.remove(client.header_image.path)
            client.header_image = new_header
            action_taken = True
            messages.success(request, "Header image uploaded successfully!")

        # === UPLOAD NEW FOOTER IMAGE ===
        if 'quotation_footer_image' in request.FILES:
            new_footer = request.FILES['quotation_footer_image']
            if client.quotation_footer_image and os.path.isfile(client.quotation_footer_image.path):
                os.remove(client.quotation_footer_image.path)
            client.quotation_footer_image = new_footer
            action_taken = True
            messages.success(request, "quotation footer image uploaded successfully!")

        # Save only if something changed
        if action_taken:
            client.save()

        # Always redirect after POST to prevent resubmission
        return redirect('client_settings')

    # GET request - show form
    context = {
        'client': client,
        'header_image_url': client.header_image.url if client.header_image else None,
        'footer_image_url': client.quotation_footer_image.url if client.quotation_footer_image else None,
    }
    return render(request, 'client_settings.html', context)

def employee_login(request):
    if request.method == "POST":
        mobile = request.POST.get('mobile')
        password = request.POST.get('password')

        try:
            # Fetch employee with client relation
            employees = employee.objects.select_related('client').get(
                mobile=mobile,
                status=1  # Active only
            )

            if employees.Password == password:  # Your plain text password system
                # Store session data including client_id
                request.session['employee_logged_in'] = True
                request.session['employee_id'] = employees.id
                request.session['employee_name'] = employees.employee_name
                request.session['employee_mobile'] = employees.mobile
                request.session['client_id'] = employees.client_id
                request.session['client_name'] = employees.client.client_name or employee.client.business_name

                messages.success(request, f"Welcome back, {employees.employee_name}!")
                return redirect('employee_dashboard')
            else:
                messages.error(request, "Incorrect password.")
        except employee.DoesNotExist:
            messages.error(request, "No active employee found with this mobile number.")

    return render(request, 'employee/employee_login.html')

def employee_logout(request):
    keys = ['employee_logged_in', 'employee_id', 'employee_name', 'employee_mobile', 'client_id', 'client_name']
    for key in keys:
        request.session.pop(key, None)
    messages.success(request, "You have been logged out.")
    return redirect('employee_login')

def employee_dashboard(request):
    if not request.session.get('employee_logged_in'):
        return redirect('employee_login')

    employee_id = request.session.get('employee_id')
    client_id = request.session.get('client_id')

    try:
        employees = employee.objects.get(id=employee_id, client_id=client_id)
    except employee.DoesNotExist:
        messages.error(request, "Access denied.")
        return redirect('employee_login')

    # Only leads assigned to this employee AND under their client
    assigned_leads = leads_table.objects.filter(
        assign_to=employees.employee_name,
        client_id=client_id,
        deleted_at__isnull=True
    )

    stats = {
        'total': assigned_leads.count(),
        'follow_up': assigned_leads.filter(status='Follow-up').count(),
        'quoted': assigned_leads.filter(status='Quoted').count(),
        'converted': assigned_leads.filter(status='Converted').count(),
        'rejected': assigned_leads.filter(status='Rejected').count(),
    }

    recent_leads = assigned_leads.order_by('-created_at')[:7]

    context = {
        'employee': employees,
        'stats': stats,
        'recent_leads': recent_leads,
    }
    return render(request, 'employee/employee_dashboard.html', context)

def employee_leads(request):
    if not request.session.get('employee_logged_in'):
        return redirect('employee_login')

    employee_id = request.session.get('employee_id')
    client_id = request.session.get('client_id')

    try:
        employees = employee.objects.get(id=employee_id, client_id=client_id)
    except employee.DoesNotExist:
        messages.error(request, "Access denied.")
        return redirect('employee_login')

    lead = leads_table.objects.filter(
        assign_to=employees.employee_name,
        client_id=client_id,
        deleted_at__isnull=True
    ).order_by('-next_followup_date')

    enquiry_category = enquiryfor.objects.filter(client_id=client_id)
    lead_sources = leadsource.objects.filter(client_id=client_id)
    employees_ = employee.objects.filter(client_id=client_id, status=1)

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            lead_id = data.get('lead_id')
            phone = data.get('phone', '').strip()
            
            if not phone:
                return JsonResponse({'success': False, 'error': 'Phone is required'})
            if not phone.isdigit() or not (10 <= len(phone) <= 15):
                return JsonResponse({'success': False, 'error': 'Invalid phone number format'})
            # ================= CREATE LEAD =================
            if not lead_id:
                lead = leads_table.objects.create(
                customer_name=data.get('customer_name'),
                phone=phone,
                email=data.get('email', ''),
                location=data.get('location', ''),
                product_category=data.get('product_category'),
                lead_source_id=data.get('lead_source'),
                assign_to=data.get('assign_to'),
                next_followup_date=data.get('next_followup_date'),
                followup_time=data.get('followup_time'),
                status=data.get('status', 'New'),
                remarks=data.get('remarks', ''),
                address=data.get('address', ''),
                requirement_details=data.get('requirement_details', ''),
                client_id=client_id,
                staff=employees,
            )
                return JsonResponse({'success': True, 'message': 'lead added successfully'})
                # ================= UPDATE LEAD =================
            lead = get_object_or_404(leads_table,id=lead_id,client_id=client_id,deleted_at__isnull=True)
            lead.customer_name = data.get('customer_name')
            lead.phone = phone
            lead.email = data.get('email', lead.email)
            lead.location = data.get('location', lead.location)
            lead.product_category = data.get('product_category', lead.product_category)
            lead.lead_source_id = data.get('lead_source') or lead.lead_source_id
            lead.next_followup_date = data.get('next_followup_date')
            lead.followup_time = data.get('followup_time')
            lead.status = data.get('status', lead.status)
            lead.remarks = data.get('remarks', lead.remarks)
            lead.address = data.get('address', lead.address)
            lead.requirement_details = data.get('requirement_details', lead.requirement_details)
            lead.staff=employees
            lead.save()

            return JsonResponse({'success': True, 'message': 'lead updated successfully'})

        except json.JSONDecodeError:
            return JsonResponse({'success': False, 'error': 'Invalid JSON'}, status=400)
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)

    context = {
        'employees': employees_,
        'leads': lead,
        'enquiry_category': enquiry_category,
        'lead_sources': lead_sources,
        "employee":employee,
    }
    return render(request, 'employee/employee_leads.html', context)


def employee_profile(request):
    if not request.session.get('employee_logged_in'):
        messages.error(request, "Please log in.")
        return redirect('employee_login')

    employee_id = request.session.get('employee_id')
    client_id = request.session.get('client_id')

    if not client_id:
        messages.error(request, "Session error.")
        return redirect('employee_login')

    try:
        employees = employee.objects.get(id=employee_id, client_id=client_id)
    except employee.DoesNotExist:
        messages.error(request, "Profile not found.")
        return redirect('employee_dashboard')

    context = {
        'employee': employees,
    }
    return render(request, 'employee/employee_profile.html', context)

def employee_edit_quotation(request, quotation_id):
    client = get_object_or_404(client_data, id=request.session.get('client_id'))
    quotations = get_object_or_404(quotation, id=quotation_id, client=client)

    employee_id = request.session.get('employee_id')
    client_id = request.session.get('client_id')

    if not client_id:
        messages.error(request, "Session error.")
        return redirect('employee_login')

    try:
        employees = employee.objects.get(id=employee_id, client_id=client_id)
    except employee.DoesNotExist:
        messages.error(request, "Profile not found.")
        return redirect('employee_dashboard')

    if request.method == "POST":
        with transaction.atomic():

            # ================= MAIN QUOTATION FIELDS =================
            quotations.client_name = request.POST.get("client_name")
            quotations.client_phone = request.POST.get("client_phone")
            quotations.client_email = request.POST.get("client_email", "")
            quotations.client_address = request.POST.get("client_address", "")
            quotations.valid_upto = request.POST.get("valid_upto")
            quotations.notes = request.POST.get("notes", "")

            quotations.subtotal = Decimal(request.POST.get("subtotal", "0"))
            quotations.cgst = Decimal(request.POST.get("cgst", "0"))
            quotations.sgst = Decimal(request.POST.get("sgst", "0"))
            quotations.igst = Decimal(request.POST.get("igst", "0"))
            quotations.total = Decimal(request.POST.get("total", "0"))
            quotations.staff = employees

            # ================= GST TYPE =================
            if quotations.igst > 0:
                quotations.gst_type = "IGST"
                quotations.gst_amount = quotations.igst
            else:
                quotations.gst_type = "GST"
                quotations.gst_amount = quotations.cgst + quotations.sgst

            # ================= VERSION SAFE INCREMENT =================
            try:
                quotations.version = str(int(quotations.version or 1) + 1)
            except ValueError:
                quotations.version = "2"

            quotations.save()

            # ================= PRODUCT DATA =================
            product_ids = request.POST.getlist("product_id[]")
            quantities = request.POST.getlist("quantity[]")
            rates = request.POST.getlist("rate[]")

            incoming_product_ids = [pid for pid in product_ids if pid]

            # ================= DELETE REMOVED ITEMS =================
            quotationitem.objects.filter(
                quotation=quotations
            ).exclude(product_id__in=incoming_product_ids).delete()

            ZERO = Decimal("0.00")

            # ================= UPDATE / CREATE ITEMS =================
            for i in range(len(product_ids)):
                pid = product_ids[i]
                if not pid:
                    continue

                products = get_object_or_404(product, id=pid, client=client)
                qty = int(quantities[i] or 1)
                rate = Decimal(rates[i] or "0")
                taxable_amount = qty * rate
                gst_rate = Decimal(products.gst)

                if quotation.gst_type == "IGST":
                    igst_amt = taxable_amount * gst_rate / 100
                    cgst_amt = sgst_amt = ZERO
                else:
                    cgst_amt = sgst_amt = taxable_amount * gst_rate / 200
                    igst_amt = ZERO

                quotationitem.objects.update_or_create(
                    quotation=quotations,
                    product=products,
                    defaults={
                        "quantity": qty,
                        "rate": rate,
                        "amount": taxable_amount,
                        "cgst": cgst_amt,
                        "sgst": sgst_amt,
                        "igst": igst_amt,
                    }
                )

        messages.success(request, "quotation updated successfully!")
        return redirect("employee_leads")

    # ================= GET REQUEST =================
    items = quotations.items.select_related("product").all()
    products = product.objects.filter(client=client)

    context = {
        "client": client,
        "employee": employees,
        "lead": quotations.lead,
        "quotation": quotations,
        "items": items,
        "products": products,
        "is_edit": True,
    }

    return render(request, "employee/employee_quotation_edit.html", context)

def employee_quotation_maker(request, lead_id=None):
    client_id = request.session.get('client_id')
    if not client_id:
        return JsonResponse({'success': False, 'message': 'Login required'})

    client = get_object_or_404(client_data, id=client_id)
    client_id = request.session.get('client_id')
    employee_id=request.session.get('employee_id')
    if not client_id:
        messages.error(request, "Session error.")
        return redirect('employee_login')

    try:
        employees = employee.objects.get(id=employee_id, client_id=client_id)
    except employee.DoesNotExist:
        messages.error(request, "Profile not found.")
        return redirect('employee_dashboard')
    
    if request.method == 'POST':
        try:
            lead = get_object_or_404(leads_table, id=request.POST.get('lead_id'), client=client)

            gst_type = 'IGST' if Decimal(request.POST.get('igst', 0)) > 0 else 'GST'
            existing_quote = quotation.objects.filter(lead=lead, client=client).first()
            if existing_quote:
                messages.warning(request, f"quotation already exists for this lead (quotation No: {existing_quote.id})")
                return redirect("employee_leads")
            quotations = quotation.objects.create(
                client=client,
                lead=lead,
                quotation_number=generate_quotation_number(client),
                client_name=request.POST.get('client_name'),
                client_phone=request.POST.get('client_phone'),
                client_email=request.POST.get('client_email', ''),
                client_address=request.POST.get('client_address', ''),

                subtotal=Decimal(request.POST.get('subtotal')),
                gst_type=gst_type,
                gst_amount=Decimal(request.POST.get('gst_amount')),
                staff=employee,
                cgst=Decimal(request.POST.get('cgst', 0)) or None,
                sgst=Decimal(request.POST.get('sgst', 0)) or None,
                igst=Decimal(request.POST.get('igst', 0)) or None,
                total=Decimal(request.POST.get('total')),
                valid_upto=request.POST.get('valid_upto'),
                notes=request.POST.get('notes', ''),
                version=1,
            )

            product_ids = request.POST.getlist('product_id[]')
            quantities = request.POST.getlist('quantity[]')
            rates = request.POST.getlist('rate[]')

            for i in range(len(product_ids)):
                if product_ids[i]:
                    qty = int(quantities[i])
                    rate = Decimal(rates[i])
                    amount = qty * rate

                    product = get_object_or_404(product, id=product_ids[i], client=client)

                    if gst_type == 'IGST':
                        igst_amt = amount * Decimal(products.gst) / 100
                        cgst_amt = sgst_amt = None
                    else:
                        cgst_amt = amount * Decimal(products.gst) / 200
                        sgst_amt = cgst_amt
                        igst_amt = None

                    quotationitem.objects.create(
                        quotation=quotations,
                        product=product,
                        quantity=qty,
                        rate=rate,
                        amount=amount,
                        cgst=cgst_amt,
                        sgst=sgst_amt,
                        igst=igst_amt,
                    )

            lead.status = "Quoted"
            lead.save()
            messages.success(request,"quotation saved successfully")
            return redirect("employee_leads")

        except Exception as e:
            transaction.set_rollback(True)
            messages.error(request,str(e))
            return redirect("employee_quotation_maker")

    else:
        lead = get_object_or_404(leads_table, id=lead_id, client=client) if lead_id else None
        products = product.objects.filter(client=client)

        return render(request, 'employee/employee_quotation_maker.html', {
            'lead': lead,
            'products': products,
            'client': client,
            "employee":employees,
        })
        
        
def terms_conditions_view(request):
    client_id=request.session.get("client_id")
    client = get_object_or_404(client_data, id=client_id)  # add your security filter if needed (e.g. client.user == request.user)

    # Get or create one policy per client (you can change to .latest() if you want version history)
    terms, created = terms_conditions.objects.get_or_create(
        client=client,
        defaults={
            'content': '',
        }
    )

    context = {
        'client': client,
        'terms': terms,
    }
    return render(request, 'terms_and_conditions.html', context)


def save_terms_conditions(request, client_id):
    client = get_object_or_404(client_data, id=client_id)

    # Get the existing policy (we assume one per client)
    terms_condition = get_object_or_404(terms_conditions, client=client)

    content = request.POST.get('content', '').strip()

    # Very basic server-side validation
    errors = {}
    if not content:
        errors['content'] = "Terms and Conditions content is required."

    if errors:
        return JsonResponse({
            'success': False,
            'message': 'Validation errors occurred.',
            'errors': errors
        }, status=400)

    # Update and save
    terms_condition.content = content
    terms_condition.updated_by = request.user
    terms_condition.save()

    return JsonResponse({
        'success': True,
        'message': 'Terms and Conditions updated successfully!',
        'content': terms_condition.content
    })

def delete_terms_conditions(request, client_id):
    """Delete Terms & Conditions - Only the logged-in client can delete their own"""
    if not request.session.get('client_logged_in'):
        messages.error(request, "Please log in to continue.")
        return redirect('login')

    # Security: Only the logged-in client can delete their own terms
    if request.session.get('client_id') != client_id:
        messages.error(request, "You are not authorized to delete these terms.")
        return redirect('terms_conditions')

    try:
        terms = terms_conditions.objects.get(client=client_id)
        terms.delete()
        messages.success(request, "Terms and Conditions deleted successfully!")
    except terms_conditions.DoesNotExist:
        messages.warning(request, "No terms found to delete.")


    # If someone accesses directly via GET, redirect back
    return redirect('terms_conditions')

def forgot_password(request):
    if request.method == "POST":
        email = request.POST.get("email")

        try:
            client = client_data.objects.get(email=email)
        except client_data.DoesNotExist:
            messages.error(request, "Email not found.")
            return redirect("forgot_password")

        encoded_id = urlsafe_base64_encode(force_bytes(client.id))
        reset_link = request.build_absolute_uri(
            f"/reset-password/{encoded_id}/"
        )

        send_mail(
            subject="Reset Your CRM Password",
            message=f"""
Hello {client.client_name},

Click the link below to reset your password:

{reset_link}

If you did not request this, please ignore.
""",
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[email],
            fail_silently=False
        )

        messages.success(request, "Password reset link sent to your email.")
        return redirect("login")

    return render(request, "forgot_password.html")

def reset_password(request, uidb64):
    try:
        client_id = force_str(urlsafe_base64_decode(uidb64))
        client = client_data.objects.get(id=client_id)
    except:
        messages.error(request, "Invalid or expired link.")
        return redirect("login")

    if request.method == "POST":
        password = request.POST.get("password")
        confirm = request.POST.get("confirm_password")

        if password != confirm:
            messages.error(request, "Passwords do not match.")
            return redirect(request.path)

        client.password = password  
        client.save()

        messages.success(request, "Password reset successful.")
        return redirect("login")

    return render(request, "reset_password.html")

def privacy_policy(request):
    return render(request,'privacy_policy.html')

def delete_request(request):
    return render(request,'delete_request.html')

#API Views

class ClientTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, client):
        token = RefreshToken.for_user(client)
        # Force-add claims — make sure they are always there
        token['client_id'] = client.id
        token['client_name'] = client.client_name or client.username or ""
        token['phone'] = client.username or ""
        token['is_active'] = client.status == "Active"
        return token

    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')

        try:
            client = client_data.objects.get(username=username)
            if client.password == password and client.status == "Active":
                refresh = self.get_token(client)
                return {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'client_id': client.id,
                    'client_name': client.client_name or client.username,
                    'message': 'Login successful'
                }
            else:
                raise Exception("Invalid credentials or account suspended")
        except client_data.DoesNotExist:
            raise Exception("No account found with this username")


class ClientTokenObtainPairView(TokenObtainPairView):
    serializer_class = ClientTokenObtainPairSerializer



class ClientJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        client_id = validated_token.get('client_id')

        try:
            return client_data.objects.get(id=client_id)
        except client_data.DoesNotExist:
            raise AuthenticationFailed('Client not found')

# ──────────────────────────────────────────────
# Login — returns JWT access + refresh
# ──────────────────────────────────────────────
@api_view(['POST'])
@permission_classes([AllowAny])
def api_client_login(request):
    serializer = ClientTokenObtainPairSerializer(data=request.data)
    try:
        serializer.is_valid(raise_exception=True)
        return Response(serializer.validated_data, status=200)
    except Exception as e:
        return Response({"success": False, "message": str(e)}, status=400)


# ──────────────────────────────────────────────
# Logout — optional blacklist
# ──────────────────────────────────────────────
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def api_client_logout(request):
    # Blacklist current access token's JTI (for immediate invalidation)
    jti = request.auth.get('jti')  # AccessToken has jti
    if jti:
        # Set for 1 hour (longer than access lifetime)
        cache.set(f"blacklist_access_{jti}", True, timeout=3600)

    # Optional: blacklist refresh
    refresh = request.data.get('refresh')
    if refresh:
        try:
            RefreshToken(refresh).blacklist()
        except:
            pass

    return Response({
        "success": True,
        "message": "Logged out. All active tokens invalidated."
    })


# ──────────────────────────────────────────────
# Dashboard Stats — FIXED: uses JWT only
# ──────────────────────────────────────────────
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def api_dashboard_stats(request):
    client = request.user

    # Safety check - should never happen with correct auth setup
    if not hasattr(client, 'id') or not client.id:
        return Response(
            {"detail": "Invalid authentication - no valid client object"},
            status=status.HTTP_401_UNAUTHORIZED
        )

    try:
        # Make sure we have the full client object (in case get_user returned minimal)
        client = client_data.objects.get(id=client.id)
    except client_data.DoesNotExist:
        return Response(
            {
                "detail": "Client not found in database",
                "client_id_from_token": getattr(client, 'id', None)
            },
            status=status.HTTP_404_NOT_FOUND
        )

    today = timezone.now().date()
    thirty_days_ago = today - timedelta(days=30)
    thirty_one_days_future = today + timedelta(days=31)

    total_leads = leads_table.objects.filter(client=client).exclude(status="Deleted").count()
    new_leads = leads_table.objects.filter(client=client, status='New').count()
    quoted_leads = leads_table.objects.filter(client=client, status='Quoted').count()
    followup_leads = leads_table.objects.filter(client=client, status='Follow-up').count()
    converted_leads = leads_table.objects.filter(client=client, status='Converted').count()
    rejected_leads = leads_table.objects.filter(client=client, status='Rejected').count()

    # Recent leads (last 30 days)
    recent_leads_count = leads_table.objects.filter(
        client=client,
        created_at__gte=thirty_days_ago
    ).count()

    # Employees
    active_employees_count = employee.objects.filter(client=client, status=1).count()

    # Quotations
    total_quoted_amount = quotation.objects.filter(client=client).aggregate(
        total=Sum('total')
    )['total'] or 0

    total_quotations = quotation.objects.filter(client=client).count()

    # Documents / Reminders
    upcoming_and_expired_docs = document.objects.filter(
        client=client,
        expiry_date__lte=thirty_one_days_future,
        expiry_date__gte=today - timedelta(days=90)  # optional: don't show very old expired
    ).count()

    # ──────────────────────────────────────────────
    # Build response
    # ──────────────────────────────────────────────

    stats = {
        "success": True,
        "client": {
            "id": client.id,
            "username": client.username,
            "name": client.client_name or client.username,
            "status": client.status
        },
        "leads": {
            "total": total_leads,
            "new": new_leads,
            "quoted": quoted_leads,
            "followup": followup_leads,
            "converted": converted_leads,
            "rejected": rejected_leads,
            "recent_30_days": recent_leads_count
        },
        "employees": {
            "active": active_employees_count
        },
        "quotations": {
            "total_count": total_quotations,
            "total_amount": float(total_quoted_amount)
        },
        "documents": {
            "upcoming_and_expired": upcoming_and_expired_docs
        },
    }

    return Response(stats)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def api_lead_summary(request):
    """
    GET /api/client/leads/summary/
    
    Returns leads with computed pending_days, matching the dashboard table.
    Query params:
        status   — filter by lead status  (e.g. ?status=Follow-up)
        limit    — max records returned   (default 50, max 200)
        overdue  — "true" → only overdue leads
    """
    client = request.user
    today  = timezone.now().date()

    # ── query params ──────────────────────────────────────────
    status_filter = request.query_params.get('status')
    overdue_only  = request.query_params.get('overdue', '').lower() == 'true'
    try:
        limit = min(int(request.query_params.get('limit', 50)), 200)
    except ValueError:
        limit = 50

    # ── base queryset ─────────────────────────────────────────
    qs = leads_table.objects.filter(
        client=client,
        deleted_at__isnull=True
    ).select_related('lead_source').order_by('-id')

    if status_filter:
        qs = qs.filter(status=status_filter)

    if overdue_only:
        qs = qs.filter(
            next_followup_date__isnull=False,
            next_followup_date__lt=today
        )

    # ── build response ────────────────────────────────────────
    data = []
    for lead in qs[:limit]:
        pending_days = None
        pending_label = None
        is_overdue = False

        if lead.next_followup_date:
            pending_days = (lead.next_followup_date - today).days
            is_overdue   = pending_days < 0
            if pending_days < 0:
                pending_label = f"{abs(pending_days)} DAYS OVERDUE"
            elif pending_days == 0:
                pending_label = "DUE TODAY"
            else:
                pending_label = f"+{pending_days} DAYS"

        data.append({
            "id":                 lead.id,
            "customer_name":      lead.customer_name,
            "phone":              lead.phone,
            "category":           lead.product_category,        # shown as UPPER in UI
            "status":             lead.status,
            "assign_to":          lead.assign_to or "Unassigned",
            "lead_source":        lead.lead_source.name if lead.lead_source else None,
            "next_followup_date": (
                lead.next_followup_date.strftime("%d-%m-%Y")
                if lead.next_followup_date else None
            ),
            "followup_time": (
                lead.followup_time.strftime("%H:%M")
                if lead.followup_time else None
            ),
            "pending_days":       pending_days,    # integer, null if no followup date
            "pending_label":      pending_label,   # ready-made display string
            "is_overdue":         is_overdue,
            "created_at":         lead.created_at.strftime("%d-%m-%Y"),
        })

    return Response({
        "success": True,
        "total":   len(data),
        "today":   today.strftime("%d-%m-%Y"),
        "data":    data,
    })

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_employee_list_create(request):
    client = request.user
 
    if request.method == 'GET':
        employees = employee.objects.filter(client=client).order_by('-id').values(
            'id', 'employee_code', 'employee_name', 'mobile', 'email',
            'designation', 'status', 'gender', 'join_date', 'address','Password'
        )
        return Response({"success": True, "data": list(employees)})
 
    if request.method == 'POST':
        data = request.data
 
        # ── Required field validation (mirrors employee_create exactly) ────────
        employee_code = str(data.get('employee_code', '')).strip()
        employee_name = str(data.get('employee_name', '')).strip()
        email         = str(data.get('email', '')).strip()
        mobile        = str(data.get('mobile', '')).strip()
        join_date     = str(data.get('join_date', '')).strip()
 
        if not all([employee_code, employee_name, email, mobile, join_date]):
            missing = [
                f for f, v in {
                    'employee_code': employee_code,
                    'employee_name': employee_name,
                    'email':         email,
                    'mobile':        mobile,
                    'join_date':     join_date,
                }.items() if not v
            ]
            return Response(
                {"success": False, "message": f"Missing required fields: {', '.join(missing)}"},
                status=400
            )
 
        # ── Uniqueness checks (global, same as web form) ───────────────────────
        if employee.objects.filter(employee_code__iexact=employee_code).exists():
            return Response(
                {"success": False, "message": "Employee code already exists."},
                status=400
            )
 
        if employee.objects.filter(email__iexact=email).exists():
            return Response(
                {"success": False, "message": "Email already registered."},
                status=400
            )
 
        if employee.objects.filter(mobile=mobile).exists():
            return Response(
                {"success": False, "message": "Mobile number already registered."},
                status=400
            )
 
        # ── Optional fields ────────────────────────────────────────────────────
        gender      = str(data.get('gender', '')).strip() or "Others"
        address     = str(data.get('address', '')).strip() or None
        designation = str(data.get('designation', '')).strip()
        password    = str(data.get('Password', '')).strip() or None
 
        # status is a BooleanField: accept true/false/1/0/"true"/"false"/"1"/"0"
        raw_status = data.get('status', True)
        if isinstance(raw_status, bool):
            emp_status = raw_status
        elif isinstance(raw_status, int):
            emp_status = bool(raw_status)
        else:
            emp_status = str(raw_status).lower() not in ('false', '0', 'inactive', 'no')

        try:
            parsed_join_date = datetime.strptime(join_date, "%Y-%m-%d").date()
        except ValueError:
            return Response({"success": False, "message": "Invalid join_date format. Use YYYY-MM-DD"}, status=400)
 
        # ── Create ─────────────────────────────────────────────────────────────
        try:
            emp = employee.objects.create(
                client      = client,
                employee_code = employee_code.upper(),
                employee_name = employee_name,
                gender      = gender,
                email       = email,
                mobile      = mobile,
                address     = address,
                designation = designation,
                join_date   = parsed_join_date,
                status      = emp_status,
                Password    = password,
            )
        except Exception as e:
            return Response(
                {"success": False, "message": f"Failed to create employee: {str(e)}"},
                status=500
            )
 
        return Response({
            "success": True,
            "message": f"Employee '{emp.employee_name}' created successfully.",
            "data": {
                "id":            emp.id,
                "employee_code": emp.employee_code,
                "employee_name": emp.employee_name,
                "gender":        emp.gender,
                "email":         emp.email,
                "mobile":        emp.mobile,
                "designation":   emp.designation,
                "join_date":     emp.join_date.isoformat() if emp.join_date else None,
                "address":       emp.address or "",
                "status":        emp.status,
            }
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_employee_detail(request, pk):
    client = request.user

    try:
        emp = employee.objects.get(id=pk, client=client)
    except employee.DoesNotExist:
        return Response({"detail": "Employee not found or not yours"}, status=404)

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "id": emp.id,
                "employee_code": emp.employee_code,
                "employee_name": emp.employee_name,
                "mobile": emp.mobile,
                "email": emp.email,
                "designation": emp.designation,
                "status": emp.status,
                "Password":emp.Password,
            }
        })

    if request.method == 'PUT':
        data = request.data
        for field in ['employee_name', 'mobile', 'email', 'designation', 'status','gender','address','Password']:
            if field in data:
                setattr(emp, field, data[field])
        emp.save()
        return Response({"success": True, "message": "Updated"})

    if request.method == 'DELETE':
        emp.status = "Inactive"
        emp.save()
        return Response({"success": True, "message": "Deactivated"})


# ──────────────────────────────────────────────
# LEADSOURCE APIs
# ──────────────────────────────────────────────

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_leadsource_list_create(request):
    client = request.user

    if request.method == 'GET':
        sources = leadsource.objects.filter(client=client, status="Active").order_by('-id').values(
            'id', 'name', 'status', 'created_at'
        )
        return Response({"success": True, "data": list(sources)})

    if request.method == 'POST':
        name = request.data.get('name', '').strip()
        if not name:
            return Response({"success": False, "message": "Name is required"}, status=400)

        if leadsource.objects.filter(client=client, name__iexact=name).exists():
            return Response({"success": False, "message": "Lead source already exists"}, status=400)

        source = leadsource.objects.create(client=client, name=name, status="Active")
        return Response({
            "success": True,
            "message": "Lead source created",
            "data": {"id": source.id, "name": source.name}
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_leadsource_detail(request, pk):
    client = request.user

    try:
        source = leadsource.objects.get(id=pk, client=client)
    except leadsource.DoesNotExist:
        return Response({"detail": "Lead source not found or not yours"}, status=404)

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "id": source.id,
                "name": source.name,
                "status": source.status
            }
        })

    if request.method == 'PUT':
        name = request.data.get('name', '').strip()
        if not name:
            return Response({"success": False, "message": "Name is required"}, status=400)

        if leadsource.objects.filter(client=client, name__iexact=name).exclude(id=pk).exists():
            return Response({"success": False, "message": "Name already exists"}, status=400)

        source.name = name
        source.save()
        return Response({"success": True, "message": "Updated successfully"})

    if request.method == 'DELETE':
        source.status = "Inactive"
        source.save()
        return Response({"success": True, "message": "Lead source deactivated"})


# ──────────────────────────────────────────────
# ENQUIRY CATEGORY APIs
# ──────────────────────────────────────────────

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_enquiry_category_list_create(request):
    client = request.user

    if request.method == 'GET':
        categories = enquiryfor.objects.filter(client=client, status="Active").order_by('-id').values(
            'id', 'name', 'status'
        )
        return Response({"success": True, "data": list(categories)})

    if request.method == 'POST':
        name = request.data.get('name', '').strip()
        if not name:
            return Response({"success": False, "message": "Name is required"}, status=400)

        if enquiryfor.objects.filter(client=client, name__iexact=name).exists():
            return Response({"success": False, "message": "Category already exists"}, status=400)

        cat = enquiryfor.objects.create(client=client, name=name, status="Active")
        return Response({
            "success": True,
            "message": "Category created",
            "data": {"id": cat.id, "name": cat.name}
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_enquiry_category_detail(request, pk):
    client = request.user

    try:
        category = enquiryfor.objects.get(id=pk, client=client)
    except enquiryfor.DoesNotExist:
        return Response({"detail": "Category not found or not yours"}, status=404)

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {"id": category.id, "name": category.name, "status": category.status}
        })

    if request.method == 'PUT':
        name = request.data.get('name', '').strip()
        status = request.data.get('status', 'Active').strip()
        if not name:
            return Response({"success": False, "message": "Name is required"}, status=400)

        if enquiryfor.objects.filter(client=client, name__iexact=name).exclude(id=pk).exists():
            return Response({"success": False, "message": "Name already exists"}, status=400)

        category.name = name
        category.status=status
        category.save()
        return Response({"success": True, "message": "Updated"})

    if request.method == 'DELETE':
        category.status = "Inactive"
        category.save()
        return Response({"success": True, "message": "Category deactivated"})


# ──────────────────────────────────────────────
# PRODUCT APIs
# ──────────────────────────────────────────────

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_product_list_create(request):
    client = request.user

    if request.method == 'GET':
        products = product.objects.filter(client=client, status="Active").order_by('-id').values(
            'id', 'name', 'hsn_code', 'rate', 'gst_type', 'gst'
        )
        return Response({"success": True, "data": list(products)})

    if request.method == 'POST':
        required = ['name', 'rate', 'gst_type', 'gst']
        data = request.data
        missing = [f for f in required if f not in data or not data[f]]
        if missing:
            return Response({"success": False, "message": f"Missing fields: {', '.join(missing)}"}, status=400)

        if product.objects.filter(client=client, name__iexact=data['name']).exists():
            return Response({"success": False, "message": "Product name already exists"}, status=400)

        prod = product.objects.create(
            client=client,
            name=data['name'].strip(),
            hsn_code=data.get('hsn_code', ''),
            rate=Decimal(data['rate']),
            gst_type=data['gst_type'],
            gst=Decimal(data['gst'])
        )
        return Response({
            "success": True,
            "message": "Product created",
            "data": {"id": prod.id, "name": prod.name}
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_product_detail(request, pk):
    client = request.user

    try:
        product_obj = product.objects.get(id=pk, client=client)
    except product.DoesNotExist:
        return Response({"detail": "Product not found or not yours"}, status=400)

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "id": product_obj.id,
                "name": product_obj.name,
                "hsn_code": product_obj.hsn_code,
                "rate": str(product_obj.rate),
                "gst_type": product_obj.gst_type,
                "gst": str(product_obj.gst)
            }
        })

    if request.method == 'PUT':
        data = request.data
        for field in ['name', 'hsn_code', 'rate', 'gst_type', 'gst']:
            if field in data:
                if field in ['rate', 'gst']:
                    setattr(product_obj, field, Decimal(data[field]))
                else:
                    setattr(product_obj, field, data[field].strip())

        if 'name' in data and product.objects.filter(
            client=client, name__iexact=data['name']
        ).exclude(id=pk).exists():
            return Response({"success": False, "message": "Name already exists"}, status=400)

        product_obj.save()
        return Response({"success": True, "message": "Product updated"})

    if request.method == 'DELETE':
        product_obj.status = "Inactive"
        product_obj.save()
        return Response({"success": True, "message": "Product deactivated"})


# ──────────────────────────────────────────────
# LEADS APIs
# ──────────────────────────────────────────────

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_lead_list_create(request):
    client = request.user

    if request.method == 'GET':
        leads = leads_table.objects.filter(
            client=client, deleted_at__isnull=True
        ).order_by('-id').values(
            'id', 'customer_name', 'phone', 'status', 'created_at',
            'lead_source__name', 'product_category', 'assign_to'
        )
        return Response({"success": True, "data": list(leads)})

    if request.method == 'POST':
        required = ['customer_name', 'phone', 'product_category', 'lead_source']
        data = request.data
        missing = [f for f in required if f not in data or not data[f]]
        if missing:
            return Response({"success": False, "message": f"Missing: {', '.join(missing)}"}, status=400)

        try:
            lead_source = leadsource.objects.get(id=data['lead_source'], client=client)
        except leadsource.DoesNotExist:
            return Response({"success": False, "message": "Invalid lead source"}, status=400)

        lead = leads_table.objects.create(
            client=client,
            customer_name=data['customer_name'].strip(),
            phone=data['phone'].strip(),
            email=data.get('email'),
            address=data.get('address'),
            location=data.get('location'),
            product_category=data['product_category'].strip(),
            lead_source=lead_source,
            requirement_details=data.get('requirement_details'),
            next_followup_date=data.get('next_followup_date'),
            followup_time=data.get('followup_time'),
            status=data.get('status', 'New'),
            remarks=data.get('remarks'),
            assign_to=data.get('assign_to')
        )
        return Response({
            "success": True,
            "message": "Lead created",
            "data": {"id": lead.id, "customer_name": lead.customer_name}
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_lead_detail(request, pk):
    client = request.user

    try:
        lead = leads_table.objects.get(id=pk, client=client, deleted_at__isnull=True)
    except leads_table.DoesNotExist:
        return Response({"detail": "Lead not found or not yours"}, status=404)

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "id": lead.id,
                "customer_name": lead.customer_name,
                "phone": lead.phone,
                "status": lead.status,
                "product_category": lead.product_category,
                "lead_source": lead.lead_source.name if lead.lead_source else None,
                "assign_to": lead.assign_to,
                "next_followup_date": lead.next_followup_date.isoformat() if lead.next_followup_date else None
            }
        })

    if request.method == 'PUT':
        data = request.data
        for field in [
            'customer_name', 'phone', 'email', 'address', 'location',
            'product_category', 'requirement_details', 'remarks', 'assign_to',
            'status', 'next_followup_date', 'followup_time'
        ]:
            if field in data:
                if field == 'next_followup_date' and data[field]:
                    lead.next_followup_date = data[field]
                elif field == 'followup_time' and data[field]:
                    try:
                        lead.followup_time = datetime.strptime(data[field], "%H:%M").time()
                    except ValueError:
                        return Response({"detail": "Invalid time format (use HH:MM)"}, status=400)
                else:
                    setattr(lead, field, data[field])

        if 'lead_source' in data:
            try:
                ls = leadsource.objects.get(id=data['lead_source'], client=client)
                lead.lead_source = ls
            except leadsource.DoesNotExist:
                pass  # ignore invalid source

        lead.save()
        return Response({"success": True, "message": "Lead updated"})

    if request.method == 'DELETE':
        lead.deleted_at = timezone.now()
        lead.status = "Deleted"
        lead.save()
        return Response({"success": True, "message": "Lead marked as deleted"})


# ──────────────────────────────────────────────
# TERMS & CONDITIONS API
# ──────────────────────────────────────────────

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def api_terms_conditions_detail_update(request):
    client = request.user

    terms, _ = terms_conditions.objects.get_or_create(
        client=client,
        defaults={'content': ''}
    )

    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "content": terms.content,
                "updated_at": terms.updated_at.isoformat() if terms.updated_at else None
            }
        })

    if request.method == 'PUT':
        content = request.data.get('content', '').strip()
        if not content:
            return Response({"success": False, "message": "Content cannot be empty"}, status=400)

        terms.content = content
        terms.save()
        return Response({"success": True, "message": "Terms updated"})


# ──────────────────────────────────────────────
# QUOTATION APIs
# ──────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def api_quotation_list(request):
    client = request.user
    quotations = quotation.objects.filter(client=client).order_by('-created_at')

    data = [{
        "id": q.id,
        "quotation_number": q.quotation_number,
        "client_name": q.client_name,
        "total": float(q.total or 0),
        "status": q.lead.status if q.lead else "Unknown",
        "created_at": q.created_at.strftime("%Y-%m-%d"),
        "valid_upto": q.valid_upto.strftime("%Y-%m-%d") if q.valid_upto else None
    } for q in quotations[:50]]

    return Response({"success": True, "data": data})


# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def api_create_quotation(request, lead_id):
#     client = request.user

#     try:
#         lead = leads_table.objects.get(id=lead_id, client=client)
#     except leads_table.DoesNotExist:
#         return Response({"detail": "Lead not found or not yours"}, status=404)

#     if quotation.objects.filter(lead=lead, client=client).exists():
#         return Response({"success": False, "message": "Quotation already exists for this lead"}, status=400)

#     quote = quotation.objects.create(
#         client=client,
#         lead=lead,
#         quotation_number=generate_quotation_number(client),
#         client_name=lead.customer_name,
#         client_phone=lead.phone,
#         subtotal=Decimal("0.00"),
#         total=Decimal("0.00"),
#         version="1"
#     )

#     return Response({
#         "success": True,
#         "message": "Quotation created",
#         "quotation_id": quote.id,
#         "quotation_number": quote.quotation_number
#     }, status=200)

# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def api_create_quotation(request, lead_id):
#     """
#     POST /api/client/quotations/create-from-lead/<lead_id>/
 
#     Creates a full quotation with line items in one request.
 
#     Required fields:
#         client_name, client_phone, subtotal, gst_amount, total, valid_upto
#         items[]  — list of product line objects (see below)
 
#     Optional fields:
#         client_email, client_address, notes, gst_type (GST | IGST)
 
#     Each item in "items" must have:
#         product_id   — integer, must belong to this client
#         quantity     — number
#         rate         — decimal
#         description  — string (optional)
#         unit         — string (optional, e.g. "Nos", "m²")
#         spec         — string (optional)
 
#     GST per item is auto-computed from the product's gst and gst_type.
#     Quotation-level cgst / sgst / igst are summed from line items automatically.
#     Lead status is updated to "Quoted" on success.
#     """
#     client = request.user
#     data   = request.data
 
#     # ── 1. Validate lead ──────────────────────────────────────────────────────
#     try:
#         lead = leads_table.objects.get(id=lead_id, client=client, deleted_at__isnull=True)
#     except leads_table.DoesNotExist:
#         return Response({"success": False, "message": "Lead not found or not yours"}, status=404)
 
#     # ── 2. Block duplicate quotations ─────────────────────────────────────────
#     if quotation.objects.filter(lead=lead, client=client).exists():
#         existing = quotation.objects.filter(lead=lead, client=client).first()
#         return Response({
#             "success": False,
#             "message": "Quotation already exists for this lead",
#             "quotation_id": existing.id,
#             "quotation_number": existing.quotation_number,
#         }, status=400)
 
#     # ── 3. Validate required top-level fields ─────────────────────────────────
#     required_fields = ['client_name', 'client_phone', 'subtotal', 'gst_amount', 'total', 'valid_upto']
#     missing = [f for f in required_fields if not data.get(f)]
#     if missing:
#         return Response({"success": False, "message": f"Missing required fields: {', '.join(missing)}"}, status=400)
 
#     # ── 4. Validate items list ────────────────────────────────────────────────
#     items_data = data.get('items', [])
#     if not items_data or not isinstance(items_data, list):
#         return Response({"success": False, "message": "At least one item is required in 'items' list"}, status=400)
 
#     for idx, item in enumerate(items_data):
#         if not item.get('product_id'):
#             return Response({"success": False, "message": f"Item {idx + 1}: 'product_id' is required"}, status=400)
#         if not item.get('quantity') or not item.get('rate'):
#             return Response({"success": False, "message": f"Item {idx + 1}: 'quantity' and 'rate' are required"}, status=400)
 
#     # ── 5. Create quotation + items atomically ────────────────────────────────
#     try:
#         with transaction.atomic():
 
#             ZERO = Decimal("0.00")
 
#             # Determine overall gst_type from request or default to GST
#             overall_gst_type = data.get('gst_type', 'GST').upper()
#             if overall_gst_type not in ('GST', 'IGST'):
#                 overall_gst_type = 'GST'
 
#             # Parse quotation-level amounts
#             subtotal   = Decimal(str(data['subtotal']))
#             gst_amount = Decimal(str(data['gst_amount']))
#             total      = Decimal(str(data['total']))
 
#             # cgst/sgst/igst at quotation level — we'll sum from items below
#             # but also accept explicit values if the client provides them
#             q_cgst = Decimal(str(data.get('cgst', 0) or 0))
#             q_sgst = Decimal(str(data.get('sgst', 0) or 0))
#             q_igst = Decimal(str(data.get('igst', 0) or 0))
 
#             # ── Create quotation row ──────────────────────────────────────────
#             quote = quotation.objects.create(
#                 client         = client,
#                 lead           = lead,
#                 quotation_number = generate_quotation_number(client),
 
#                 # Customer info (pre-fill from lead, override with request data)
#                 client_name    = str(data.get('client_name', lead.customer_name)).strip(),
#                 client_phone   = str(data.get('client_phone', lead.phone)).strip(),
#                 client_email   = str(data.get('client_email', lead.email or '')).strip(),
#                 client_address = str(data.get('client_address', lead.address or '')).strip(),
 
#                 # Amounts
#                 subtotal       = subtotal,
#                 gst_type       = overall_gst_type,
#                 gst_amount     = gst_amount,
#                 cgst           = q_cgst if q_cgst else None,
#                 sgst           = q_sgst if q_sgst else None,
#                 igst           = q_igst if q_igst else None,
#                 total          = total,
 
#                 valid_upto     = data['valid_upto'],
#                 notes          = str(data.get('notes', '')).strip(),
#                 version        = "1",
#                 staff          = None,  # staff not applicable for client JWT calls
#             )
 
#             # ── Create quotation items ────────────────────────────────────────
#             total_cgst = ZERO
#             total_sgst = ZERO
#             total_igst = ZERO
 
#             created_items = []
 
#             for item in items_data:
#                 try:
#                     prod = product.objects.get(id=item['product_id'], client=client)
#                 except product.DoesNotExist:
#                     raise ValueError(f"Product ID {item['product_id']} not found or does not belong to this client")
 
#                 qty    = Decimal(str(item['quantity']))
#                 rate   = Decimal(str(item['rate']))
#                 amount = qty * rate
 
#                 gst_rate    = Decimal(str(prod.gst))
#                 item_gst_type = prod.gst_type.upper() if prod.gst_type else overall_gst_type
 
#                 # Per-item GST calculation (mirrors quotation_maker logic exactly)
#                 if item_gst_type == 'IGST':
#                     igst_amt = (amount * gst_rate / 100).quantize(Decimal("0.01"))
#                     cgst_amt = None
#                     sgst_amt = None
#                     total_igst += igst_amt
#                 else:
#                     half     = (amount * gst_rate / 200).quantize(Decimal("0.01"))
#                     cgst_amt = half
#                     sgst_amt = half
#                     igst_amt = None
#                     total_cgst += half
#                     total_sgst += half
 
#                 qi = quotationitem.objects.create(
#                     quotation   = quote,
#                     product     = prod,
#                     quantity    = qty,
#                     rate        = rate,
#                     amount      = amount,
#                     cgst        = cgst_amt,
#                     sgst        = sgst_amt,
#                     igst        = igst_amt,
#                     description = str(item.get('description', '')).strip(),
#                     unit        = str(item.get('unit', 'Nos')).strip(),
#                     spec        = str(item.get('spec', '')).strip(),
#                 )
#                 created_items.append(qi)
 
#             # ── Back-fill quotation-level GST from items if not provided ──────
#             if not q_cgst and not q_igst:
#                 quote.cgst = total_cgst if total_cgst else None
#                 quote.sgst = total_sgst if total_sgst else None
#                 quote.igst = total_igst if total_igst else None
#                 if total_igst:
#                     quote.gst_type  = 'IGST'
#                     quote.gst_amount = total_igst
#                 else:
#                     quote.gst_type  = 'GST'
#                     quote.gst_amount = total_cgst + total_sgst
#                 quote.save(update_fields=['cgst', 'sgst', 'igst', 'gst_type', 'gst_amount'])
 
#             # ── Update lead status to Quoted ──────────────────────────────────
#             lead.status = 'Quoted'
#             lead.save(update_fields=['status'])
 
#             # ── Build response with full summary ──────────────────────────────
#             return Response({
#                 "success"          : True,
#                 "message"          : "Quotation created successfully",
#                 "quotation_id"     : quote.id,
#                 "quotation_number" : quote.quotation_number,
#                 "lead_id"          : lead.id,
#                 "client_id"        : client.id,
#                 "lead_status"      : lead.status,
#                 "subtotal"         : float(quote.subtotal),
#                 "gst_amount"       : float(quote.gst_amount),
#                 "cgst"             : float(quote.cgst)  if quote.cgst  else None,
#                 "sgst"             : float(quote.sgst)  if quote.sgst  else None,
#                 "igst"             : float(quote.igst)  if quote.igst  else None,
#                 "total"            : float(quote.total),
#                 "valid_upto"       : quote.valid_upto.isoformat if quote.valid_upto else None,
#                 "items_created"    : len(created_items),
#                 "items": [
#                     {
#                         "item_id"     : qi.id,
#                         "product_id"  : qi.product.id,
#                         "product_name": qi.product.name,
#                         "quantity"    : float(qi.quantity),
#                         "rate"        : float(qi.rate),
#                         "amount"      : float(qi.amount),
#                         "cgst"        : float(qi.cgst) if qi.cgst else None,
#                         "sgst"        : float(qi.sgst) if qi.sgst else None,
#                         "igst"        : float(qi.igst) if qi.igst else None,
#                         "unit"        : qi.unit,
#                         "description" : qi.description,
#                         "spec"        : qi.spec,
#                     }
#                     for qi in created_items
#                 ],
#             }, status=200)
#     except ValueError as ve:
#         return Response({"success": False, "message": str(ve)}, status=400)
#     except Exception as e:
#         return Response({"success": False, "message": f"Failed to create quotation: {str(e)}"}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def api_create_quotation(request, lead_id):
    """
    Creates a full quotation with line items from Flutter (or any client app).
    Now safely handles valid_upto in both YYYY-MM-DD and DD-MM-YYYY formats.
    """
    client = request.user
    data = request.data

    # 1. Validate lead
    try:
        lead = leads_table.objects.get(id=lead_id, client=client, deleted_at__isnull=True)
    except leads_table.DoesNotExist:
        return Response({"success": False, "message": "Lead not found or not yours"}, status=404)

    # 2. Block duplicate quotation
    if quotation.objects.filter(lead=lead, client=client).exists():
        existing = quotation.objects.filter(lead=lead, client=client).first()
        return Response({
            "success": False,
            "message": "Quotation already exists for this lead",
            "quotation_id": existing.id,
            "quotation_number": existing.quotation_number,
        }, status=400)

    # 3. Required fields check
    required_fields = ['client_name', 'client_phone', 'subtotal', 'gst_amount', 'total', 'valid_upto']
    missing = [f for f in required_fields if not data.get(f)]
    if missing:
        return Response({"success": False, "message": f"Missing required fields: {', '.join(missing)}"}, status=400)

    # 4. Items validation
    items_data = data.get('items', [])
    if not items_data or not isinstance(items_data, list):
        return Response({"success": False, "message": "At least one item is required in 'items' list"}, status=400)

    for idx, item in enumerate(items_data):
        if not item.get('product_id'):
            return Response({"success": False, "message": f"Item {idx + 1}: 'product_id' is required"}, status=400)
        if not item.get('quantity') or not item.get('rate'):
            return Response({"success": False, "message": f"Item {idx + 1}: 'quantity' and 'rate' are required"}, status=400)

    # Helper: Safe date parser (handles both formats)
    def parse_date(value):
        if not value:
            return None
        value = str(value).strip()
        formats = ["%Y-%m-%d", "%d-%m-%Y", "%d/%m/%Y"]
        for fmt in formats:
            try:
                return datetime.strptime(value, fmt).date()
            except ValueError:
                continue
        raise ValueError(f"Invalid date format for valid_upto: '{value}'. Use YYYY-MM-DD or DD-MM-YYYY.")

    # 5. Create quotation + items
    try:
        with transaction.atomic():
            ZERO = Decimal("0.00")
            overall_gst_type = str(data.get('gst_type', 'GST')).upper()
            if overall_gst_type not in ('GST', 'IGST'):
                overall_gst_type = 'GST'

            # Parse amounts safely
            subtotal = Decimal(str(data['subtotal']))
            gst_amount = Decimal(str(data['gst_amount']))
            total = Decimal(str(data['total']))

            q_cgst = Decimal(str(data.get('cgst', 0) or 0))
            q_sgst = Decimal(str(data.get('sgst', 0) or 0))
            q_igst = Decimal(str(data.get('igst', 0) or 0))

            # === FIXED: Safe date parsing ===
            try:
                valid_upto_date = parse_date(data['valid_upto'])
            except ValueError as ve:
                return Response({"success": False, "message": str(ve)}, status=400)

            # Create main quotation
            quote = quotation.objects.create(
                client=client,
                lead=lead,
                quotation_number=generate_quotation_number(client),
                client_name=str(data.get('client_name', lead.customer_name)).strip(),
                client_phone=str(data.get('client_phone', lead.phone)).strip(),
                client_email=str(data.get('client_email', lead.email or '')).strip(),
                client_address=str(data.get('client_address', lead.address or '')).strip(),
                subtotal=subtotal,
                gst_type=overall_gst_type,
                gst_amount=gst_amount,
                cgst=q_cgst if q_cgst else None,
                sgst=q_sgst if q_sgst else None,
                igst=q_igst if q_igst else None,
                total=total,
                valid_upto=valid_upto_date,          # ← Now a proper date object
                notes=str(data.get('notes', '')).strip(),
                version="1",
            )

            # Create items + calculate GST
            total_cgst = total_sgst = total_igst = ZERO
            created_items = []

            for item in items_data:
                prod = get_object_or_404(product, id=item['product_id'], client=client)

                qty = Decimal(str(item['quantity']))
                rate = Decimal(str(item['rate']))
                amount = (qty * rate).quantize(Decimal("0.01"))

                gst_rate = Decimal(str(prod.gst))
                item_gst_type = (prod.gst_type or overall_gst_type).upper()

                if item_gst_type == 'IGST':
                    igst_amt = (amount * gst_rate / 100).quantize(Decimal("0.01"))
                    cgst_amt = sgst_amt = None
                    total_igst += igst_amt
                else:
                    half = (amount * gst_rate / 200).quantize(Decimal("0.01"))
                    cgst_amt = sgst_amt = half
                    igst_amt = None
                    total_cgst += half
                    total_sgst += half

                qi = quotationitem.objects.create(
                    quotation=quote,
                    product=prod,
                    quantity=qty,
                    rate=rate,
                    amount=amount,
                    cgst=cgst_amt,
                    sgst=sgst_amt,
                    igst=igst_amt,
                    description=str(item.get('description', '')).strip(),
                    unit=str(item.get('unit', 'Nos')).strip(),
                    spec=str(item.get('spec', '')).strip(),
                )
                created_items.append(qi)

            # Update quotation GST from items if not explicitly given
            if not q_cgst and not q_igst:
                if total_igst:
                    quote.gst_type = 'IGST'
                    quote.gst_amount = total_igst
                    quote.igst = total_igst
                else:
                    quote.gst_type = 'GST'
                    quote.gst_amount = total_cgst + total_sgst
                    quote.cgst = total_cgst
                    quote.sgst = total_sgst
                quote.save()

            # Update lead status
            lead.status = 'Quoted'
            lead.save(update_fields=['status'])

            return Response({
                "success": True,
                "message": "Quotation created successfully",
                "quotation_id": quote.id,
                "quotation_number": quote.quotation_number,
                "valid_upto": quote.valid_upto.isoformat() if quote.valid_upto else None,
                "items_created": len(created_items),
            }, status=201)

    except ValueError as ve:
        return Response({"success": False, "message": str(ve)}, status=400)
    except Exception as e:
        return Response({"success": False, "message": f"Failed to create quotation: {str(e)}"}, status=500)

# @api_view(['GET', 'PUT'])
# @permission_classes([IsAuthenticated])
# def api_quotation_detail_update(request, pk):
#     client = request.user
 
#     try:
#         quote = quotation.objects.get(id=pk, client=client)
#     except quotation.DoesNotExist:
#         return Response({"detail": "Quotation not found or not yours"}, status=404)
 
#     if request.method == 'GET':
#         return Response({
#             "success": True,
#             "data": {
#                 "id": quote.id,
#                 "quotation_number": quote.quotation_number,
#                 "client_name": quote.client_name,
#                 "total": float(quote.total or 0),
#                 "valid_upto": quote.valid_upto.strftime("%Y-%m-%d") if quote.valid_upto else None,
#                 "notes": quote.notes or ""
#             }
#         })
 
#     if request.method == 'PUT':
#         data = request.data
#         for field in ['client_name', 'client_phone', 'client_email', 'client_address', 'notes', 'valid_upto']:
#             if field in data:
#                 setattr(quote, field, data[field])
 
#         if 'subtotal' in data:
#             quote.subtotal = Decimal(data['subtotal'])
#         if 'total' in data:
#             quote.total = Decimal(data['total'])
 
#         quote.save()
#         return Response({"success": True, "message": "Quotation updated"})

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def api_quotation_detail_update(request, pk):
    client = request.user

    try:
        quote = quotation.objects.get(id=pk, client=client)
    except quotation.DoesNotExist:
        return Response({"detail": "Quotation not found or not yours"}, status=404)

    # ── GET ────────────────────────────────────────────────────────────────
    if request.method == 'GET':
        items = quote.items.select_related('product').all()
        return Response({
            "success": True,
            "data": {
                "id":               quote.id,
                "quotation_number": quote.quotation_number,
                "client_name":      quote.client_name,
                "client_phone":     quote.client_phone,
                "client_email":     quote.client_email or "",
                "client_address":   quote.client_address or "",
                "subtotal":         float(quote.subtotal or 0),
                "gst_type":         quote.gst_type,
                "gst_amount":       float(quote.gst_amount or 0),
                "cgst":             float(quote.cgst or 0),
                "sgst":             float(quote.sgst or 0),
                "igst":             float(quote.igst or 0),
                "total":            float(quote.total or 0),
                "valid_upto":       quote.valid_upto.strftime("%Y-%m-%d") if quote.valid_upto else None,
                "notes":            quote.notes or "",
                "version":          quote.version or "1",
                "created_at":       quote.created_at.strftime("%Y-%m-%d"),
                "lead_id":          quote.lead.id if quote.lead else None,
                "items": [
                    {
                        "item_id":      item.id,
                        "product_id":   item.product.id,
                        "product_name": item.product.name,
                        "hsn_code":     item.product.hsn_code or "",
                        "quantity":     float(item.quantity),
                        "rate":         float(item.rate),
                        "amount":       float(item.amount),
                        "cgst":         float(item.cgst) if item.cgst is not None else None,
                        "sgst":         float(item.sgst) if item.sgst is not None else None,
                        "igst":         float(item.igst) if item.igst is not None else None,
                        "unit":         item.unit or "",
                        "description":  item.description or "",
                        "spec":         item.spec or "",
                    }
                    for item in items
                ],
            }
        })

    # ── PUT ────────────────────────────────────────────────────────────────
    if request.method == 'PUT':
        data = request.data

        try:
            with transaction.atomic():

                # ── Header fields (all optional) ──────────────────────────
                for field in ['client_name', 'client_phone', 'client_email',
                               'client_address', 'notes', 'valid_upto']:
                    if field in data:
                        setattr(quote, field, data[field])

                if 'subtotal' in data:
                    quote.subtotal = Decimal(str(data['subtotal']))

                if 'cgst' in data:
                    quote.cgst = Decimal(str(data['cgst']))
                if 'sgst' in data:
                    quote.sgst = Decimal(str(data['sgst']))
                if 'igst' in data:
                    quote.igst = Decimal(str(data['igst']))
                if 'total' in data:
                    quote.total = Decimal(str(data['total']))

                # ── Recompute gst_type + gst_amount from igst (same as web edit) ──
                if 'igst' in data or 'cgst' in data:
                    igst_val = quote.igst or Decimal("0")
                    cgst_val = quote.cgst or Decimal("0")
                    sgst_val = quote.sgst or Decimal("0")
                    if igst_val > 0:
                        quote.gst_type   = 'IGST'
                        quote.gst_amount = igst_val
                    else:
                        quote.gst_type   = 'GST'
                        quote.gst_amount = cgst_val + sgst_val

                # ── Version increment (mirrors edit_quotation exactly) ─────
                try:
                    v = int(quote.version or 1)
                    quote.version = str(v + 1)
                except (ValueError, TypeError):
                    quote.version = "2"

                quote.save()

                # ── Items (optional — only processed if 'items' key is present) ──
                items_data = data.get('items')
                if items_data is not None:

                    if not isinstance(items_data, list) or len(items_data) == 0:
                        raise ValueError("'items' must be a non-empty list.")

                    # Validate every item before touching the DB
                    for idx, item in enumerate(items_data):
                        if not item.get('product_id'):
                            raise ValueError(f"Item {idx + 1}: 'product_id' is required.")
                        if not item.get('quantity') or not item.get('rate'):
                            raise ValueError(f"Item {idx + 1}: 'quantity' and 'rate' are required.")

                    # Resolve all products up-front — fail fast before any DB write
                    resolved = []
                    for idx, item in enumerate(items_data):
                        try:
                            prod = product.objects.get(
                                id=item['product_id'], client=client
                            )
                        except product.DoesNotExist:
                            raise ValueError(
                                f"Item {idx + 1}: product_id {item['product_id']} "
                                f"not found or does not belong to this client."
                            )
                        resolved.append((item, prod))

                    # Delete items whose product_id is no longer in the list
                    # (mirrors: quotationitem.objects.filter(...).exclude(...).delete())
                    incoming_product_ids = [item['product_id'] for item, _ in resolved]
                    quotationitem.objects.filter(
                        quotation=quote
                    ).exclude(product_id__in=incoming_product_ids).delete()

                    ZERO = Decimal("0.00")

                    for item, prod in resolved:
                        qty    = Decimal(str(item['quantity']))
                        rate   = Decimal(str(item['rate']))
                        amount = (qty * rate).quantize(Decimal("0.01"))

                        gst_rate      = Decimal(str(prod.gst))
                        item_gst_type = (prod.gst_type or quote.gst_type).upper()

                        # Per-item GST — mirrors api_create_quotation exactly
                        if item_gst_type == 'IGST':
                            igst_amt = (amount * gst_rate / 100).quantize(Decimal("0.01"))
                            cgst_amt = None
                            sgst_amt = None
                        else:
                            half     = (amount * gst_rate / 200).quantize(Decimal("0.01"))
                            cgst_amt = half
                            sgst_amt = half
                            igst_amt = None

                        quotationitem.objects.update_or_create(
                            quotation  = quote,
                            product_id = prod.id,
                            defaults={
                                'product':     prod,
                                'quantity':    qty,
                                'rate':        rate,
                                'amount':      amount,
                                'cgst':        cgst_amt,
                                'sgst':        sgst_amt,
                                'igst':        igst_amt,
                                'unit':        str(item.get('unit', '') or '').strip(),
                                'description': str(item.get('description', '') or '').strip(),
                                'spec':        str(item.get('spec', '') or '').strip(),
                            }
                        )

        except ValueError as ve:
            return Response({"success": False, "message": str(ve)}, status=400)
        except Exception as e:
            return Response(
                {"success": False, "message": f"Failed to update quotation: {str(e)}"},
                status=500
            )

        # Return updated quote + items in response
        updated_items = quote.items.select_related('product').all()
        return Response({
            "success": True,
            "message": "Quotation updated successfully.",
            "data": {
                "id":               quote.id,
                "quotation_number": quote.quotation_number,
                "subtotal":         float(quote.subtotal or 0),
                "gst_type":         quote.gst_type,
                "gst_amount":       float(quote.gst_amount or 0),
                "cgst":             float(quote.cgst or 0),
                "sgst":             float(quote.sgst or 0),
                "igst":             float(quote.igst or 0),
                "total":            float(quote.total or 0),
                "version":          quote.version,
                "items": [
                    {
                        "item_id":      qi.id,
                        "product_id":   qi.product.id,
                        "product_name": qi.product.name,
                        "quantity":     float(qi.quantity),
                        "rate":         float(qi.rate),
                        "amount":       float(qi.amount),
                        "cgst":         float(qi.cgst) if qi.cgst is not None else None,
                        "sgst":         float(qi.sgst) if qi.sgst is not None else None,
                        "igst":         float(qi.igst) if qi.igst is not None else None,
                        "unit":         qi.unit or "",
                        "description":  qi.description or "",
                        "spec":         qi.spec or "",
                    }
                    for qi in updated_items
                ],
            }
        })
# ──────────────────────────────────────────────
# LEAD FOLLOW-UP API
# ──────────────────────────────────────────────

@api_view(['POST', 'PUT'])
@permission_classes([IsAuthenticated])
def api_lead_followup_update(request, pk):
    client = request.user

    try:
        lead = leads_table.objects.select_for_update().get(
            id=pk,
            client=client,
            deleted_at__isnull=True
        )
    except leads_table.DoesNotExist:
        return Response(
            {"detail": "Lead not found or not yours"},
            status=status.HTTP_404_NOT_FOUND
        )

    data = request.data

    next_followup_date = data.get('next_followup_date')
    followup_time_str = data.get('followup_time')
    status = data.get('status')
    remarks_list = data.get('remarks', [])

    try:
        with transaction.atomic():
            if next_followup_date:
                lead.next_followup_date = next_followup_date

            if followup_time_str:
                try:
                    lead.followup_time = datetime.strptime(followup_time_str, "%H:%M").time()
                except ValueError:
                    return Response({"detail": "Invalid time format (use HH:MM)"}, status=400)

            if status:
                lead.status = status
                if status.lower() == "converted":
                    lead.converted_at = timezone.now()

            lead.save()

            if next_followup_date or followup_time_str or status:
                followup_table.objects.update_or_create(
                    lead_id=lead.id,
                    client_id=client.id,
                    defaults={
                        'status': lead.status,
                        'next_followup_date': lead.next_followup_date,
                        'next_followup_time': lead.followup_time,
                    }
                )

            if remarks_list:
                if isinstance(remarks_list, str):
                    remarks_list = [remarks_list]

                for remark_text in remarks_list:
                    remark_text = (remark_text or "").strip()
                    if remark_text:
                        followupremark.objects.create(
                            lead_id=lead.id,
                            client_id=client.id,
                            remark_text=remark_text
                        )

        return Response({
            "success": True,
            "message": "Follow-up updated successfully",
            "lead_status": lead.status,
            "next_followup_date": lead.next_followup_date.isoformat() if lead.next_followup_date else None,
            "followup_time": lead.followup_time.strftime("%H:%M") if lead.followup_time else None
        })

    except Exception as e:
        return Response(
            {"success": False, "message": f"Error updating follow-up: {str(e)}"},
            status=400
        )

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def api_leads_with_quotations(request):
    client = request.user

    # Get leads that have associated quotations
    leads_with_quotes = leads_table.objects.filter(
        client=client,
        deleted_at__isnull=True,
        quotation__isnull=False  # has at least one quotation
    ).distinct().order_by('-id')

    data = [
        {
            "lead_id": lead.id,
            "customer_name": lead.customer_name,
            "phone": lead.phone,
            "status": lead.status,
            "product_category": lead.product_category,
            "quotation_count": lead.quotation_set.count(),
            "latest_quotation_date": lead.quotation_set.latest('created_at').created_at.strftime("%Y-%m-%d") if lead.quotation_set.exists() else None,
            "next_followup_date": lead.next_followup_date.isoformat() if lead.next_followup_date else None,
            "assign_to": lead.assign_to,
            "lead_source":lead.lead_source,
        }
        for lead in leads_with_quotes[:100]  # limit to recent 100 for performance
    ]

    return Response({
        "success": True,
        "total": len(data),
        "data": data
    })

# ──────────────────────────────────────────────
# CLIENT PROFILE API (this one used session — now JWT consistent)
# ──────────────────────────────────────────────

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def api_client_profile_detail_update(request):
    client = request.user  

    if request.method == 'GET':
        profile_data = {
            "client_name": client.client_name or client.username or "—",
            "business_name": client.business_name or "",
            "phone_number": client.phone_number or "",
            "email": client.email or "",
            "gst": client.gst or "",
            "website": client.website or "",
            "address": client.address or "",
            "about": client.about or "",
            "logo_url": f"/media/{client.logo}" if client.logo else None,
            "status": client.status,
            "created_at": client.created_at.strftime("%Y-%m-%d") if client.created_at else None,
        }
        return Response({"success": True, "data": profile_data})

    if request.method == 'PUT':
        data = request.data
        files = request.FILES
        updated = False

        updatable_text_fields = [
            'business_name', 'gst', 'website', 'address', 'about',
            'client_name', 'email'
        ]

        for field in updatable_text_fields:
            if field in data:
                cleaned_value = (data[field] or "").strip()
                if cleaned_value != getattr(client, field, ""):
                    setattr(client, field, cleaned_value)
                    updated = True

        if 'logo' in files:
            logo_file = files['logo']
            if not logo_file.content_type.startswith('image/'):
                return Response({"success": False, "message": "Only image files allowed"}, status=400)

            if logo_file.size > 2 * 1024 * 1024:
                return Response({"success": False, "message": "Image size > 2MB"}, status=400)

            if client.logo and os.path.isfile(client.logo.path):
                try:
                    os.remove(client.logo.path)
                except:
                    pass

            ext = logo_file.name.split('.')[-1].lower()
            filename = f"profile_logo_{client.phone_number}.{ext}"
            upload_path = os.path.join('client_logos', client.phone_number, filename)
            full_path = os.path.join(settings.MEDIA_ROOT, upload_path)
            os.makedirs(os.path.dirname(full_path), exist_ok=True)

            with open(full_path, 'wb+') as destination:
                for chunk in logo_file.chunks():
                    destination.write(chunk)

            client.logo = upload_path
            updated = True

        if updated:
            client.save()
            return Response({
                "success": True,
                "message": "Profile updated",
                "logo_url": f"/media/{client.logo}" if client.logo else None
            })
        else:
            return Response({"success": True, "message": "No changes made"})

        
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def api_quotation_pdf_by_lead(request, lead_id):
    """
    GET /api/client/leads/<lead_id>/quotation-pdf-data/

    Returns ALL data needed to render & generate PDF on Flutter side.
    Finds the LATEST quotation for the given lead_id.
    Validates ownership via client_id from JWT.
    """
    client = request.user  # JWT authenticated client_data instance

    try:
        # Verify lead belongs to this client
        lead = leads_table.objects.get(id=lead_id, client=client, deleted_at__isnull=True)
    except leads_table.DoesNotExist:
        return Response(
            {"success": False, "message": "Lead not found or not yours"},
            status=status.HTTP_404_NOT_FOUND
        )

    # Find the latest quotation for this lead
    try:
        quotations = quotation.objects.filter(lead=lead, client=client).latest('created_at')
    except quotations.DoesNotExist:
        return Response(
            {"success": False, "message": "No quotation found for this lead"},
            status=status.HTTP_404_NOT_FOUND
        )

    # Get quotation items
    items = quotations.items.select_related('product').all()

    # Prepare clean, Flutter-friendly data
    data = {
        "success": True,
        "lead": {
            "lead_id": lead.id,
            "customer_name": lead.customer_name,
            "phone": lead.phone,
            "email": lead.email or "",
            "address": lead.address or "",
            "location": lead.location or "",
            "product_category": lead.product_category,
            "status": lead.status,
            "next_followup_date": lead.next_followup_date.strftime("%d-%m-%Y") if lead.next_followup_date else None,
            "assign_to": lead.assign_to or "Unassigned",
        },
        "quotation": {
            "id": quotations.id,
            "quotation_number": quotations.quotation_number,
            "client_name": quotations.client_name,
            "client_phone": quotations.client_phone,
            "client_email": quotations.client_email or "",
            "client_address": quotations.client_address or "",
            "subtotal": float(quotations.subtotal or 0),
            "gst_amount": float(quotations.gst_amount or 0),
            "cgst": float(quotations.cgst or 0),
            "sgst": float(quotations.sgst or 0),
            "igst": float(quotations.igst or 0),
            "total": float(quotations.total or 0),
            "valid_upto": quotations.valid_upto.strftime("%d-%m-%Y") if quotation.valid_upto else None,
            "notes": quotations.notes or "",
            "version": quotations.version or "1",
            "created_at": quotations.created_at.strftime("%d-%m-%Y"),
        },
        "client": {
            "business_name": client.business_name or "",
            "gst": client.gst or "",
            "address": client.address or "",
            "phone_number": client.phone_number or "",
            "email": client.email or "",
            "logo_url": f"{request.build_absolute_uri('/media/')}{client.logo}" if client.logo else None,
        },
        "items": [
            {
                "product_name": item.product.name if item.product else "—",
                "hsn": item.product.hsn_code if item.product.hsn_code else "-",
                "description": item.description or "",
                "spec":item.spec if item.spec else "-",
                "quantity": float(item.quantity or 0),
                "unit": item.unit or "Nos",
                "rate": float(item.rate or 0),
                "amount": float(item.amount or 0),
                "cgst": float(item.cgst or 0),
                "sgst": float(item.sgst or 0),
                "igst": float(item.igst or 0),
            }
            for item in items
        ],
        "terms_conditions": (
            terms_conditions.objects.filter(client=client).first().content
            if terms_conditions.objects.filter(client=client).exists()
            else ""
        ),
        "amount_in_words": number_to_words_indian(quotations.total),
    }

    return Response(data)


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def api_document_list_create(request):
    """
    GET  /api/client/documents/         — list all documents for this client
    POST /api/client/documents/         — add a new document

    POST body:
        document_id   — string, required, e.g. "DOC-001" (auto-uppercased, must be unique)
        title         — string, required
        description   — string, optional
        type          — string, optional, free text (default: "Other")
        expiry_date   — string, optional, YYYY-MM-DD or null / ""
    """
    client = request.user

    if request.method == 'GET':
        docs = document.objects.filter(client=client).order_by('-created_at').values(
            'id', 'document_id', 'title', 'description', 'type', 'expiry_date', 'created_at'
        )
        data = []
        for d in docs:
            data.append({
                'id':          d['id'],
                'document_id': d['document_id'],
                'title':       d['title'],
                'description': d['description'] or '',
                'type':        d['type'] or 'Other',
                'expiry_date': d['expiry_date'].strftime('%Y-%m-%d') if d['expiry_date'] else None,
                'created_at':  d['created_at'].strftime('%d-%m-%Y') if d['created_at'] else None,
            })
        return Response({"success": True, "data": data})

    if request.method == 'POST':
        # ── Required fields ────────────────────────────────────────────────
        doc_id_raw = str(request.data.get('document_id', '')).strip()
        title      = str(request.data.get('title', '')).strip()

        if not doc_id_raw:
            return Response({"success": False, "message": "document_id is required."}, status=400)
        if not title:
            return Response({"success": False, "message": "title is required."}, status=400)

        doc_id = doc_id_raw.upper()   # matches web form behaviour

        # ── Duplicate check (global unique on document_id) ─────────────────
        if document.objects.filter(document_id=doc_id).exists():
            return Response({"success": False, "message": "Document ID already exists."}, status=400)

        # ── Optional fields ────────────────────────────────────────────────
        description = str(request.data.get('description', '')).strip()
        doc_type    = str(request.data.get('type', 'Other')).strip() or 'Other'
        expiry_raw  = str(request.data.get('expiry_date', '') or '').strip()

        # Parse expiry_date — accept YYYY-MM-DD or null/""
        expiry_date = None
        if expiry_raw:
            try:
                expiry_date = datetime.strptime(expiry_raw, "%Y-%m-%d").date()
            except ValueError:
                return Response(
                    {"success": False, "message": "Invalid expiry_date format. Use YYYY-MM-DD."},
                    status=400
                )

        doc = document.objects.create(
            client      = client,
            document_id = doc_id,
            title       = title,
            description = description,
            type        = doc_type,
            expiry_date = expiry_date,
        )

        return Response({
            "success":     True,
            "message":     "Document added successfully.",
            "data": {
                "id":          doc.id,
                "document_id": doc.document_id,
                "title":       doc.title,
                "description": doc.description or '',
                "type":        doc.type,
                "expiry_date": doc.expiry_date.strftime('%Y-%m-%d') if doc.expiry_date else None,
            }
        }, status=200)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def api_document_detail(request, pk):
    """
    GET    /api/client/documents/<pk>/  — get single document
    PUT    /api/client/documents/<pk>/  — edit document
    DELETE /api/client/documents/<pk>/  — permanently delete document

    PUT body (all optional except at least one field must be sent):
        document_id   — string  (auto-uppercased; checked for uniqueness excluding self)
        title         — string
        description   — string
        type          — string  (free text)
        expiry_date   — string  YYYY-MM-DD or "" / null to clear
    """
    client = request.user

    try:
        doc = document.objects.get(id=pk, client=client)
    except document.DoesNotExist:
        return Response({"detail": "Document not found or not yours."}, status=404)

    # ── GET ────────────────────────────────────────────────────────────────
    if request.method == 'GET':
        return Response({
            "success": True,
            "data": {
                "id":          doc.id,
                "document_id": doc.document_id,
                "title":       doc.title,
                "description": doc.description or '',
                "type":        doc.type or 'Other',
                "expiry_date": doc.expiry_date.strftime('%Y-%m-%d') if doc.expiry_date else None,
                "created_at":  doc.created_at.strftime('%d-%m-%Y') if doc.created_at else None,
            }
        })

    # ── PUT ────────────────────────────────────────────────────────────────
    if request.method == 'PUT':
        data = request.data

        # document_id — optional but if sent must still be unique (excluding self)
        if 'document_id' in data:
            new_doc_id = str(data['document_id']).strip().upper()
            if not new_doc_id:
                return Response({"success": False, "message": "document_id cannot be empty."}, status=400)
            if new_doc_id != doc.document_id:
                if document.objects.filter(document_id=new_doc_id).exclude(id=pk).exists():
                    return Response(
                        {"success": False, "message": "Document ID already exists."},
                        status=400
                    )
            doc.document_id = new_doc_id

        if 'title' in data:
            title = str(data['title']).strip()
            if not title:
                return Response({"success": False, "message": "title cannot be empty."}, status=400)
            doc.title = title

        if 'description' in data:
            doc.description = str(data['description']).strip()

        if 'type' in data:
            doc.type = str(data['type']).strip() or 'Other'

        if 'expiry_date' in data:
            expiry_raw = str(data['expiry_date'] or '').strip()
            if expiry_raw == '' or expiry_raw.lower() == 'null':
                doc.expiry_date = None          # clear the date
            else:
                try:
                    doc.expiry_date = datetime.strptime(expiry_raw, "%Y-%m-%d").date()
                except ValueError:
                    return Response(
                        {"success": False, "message": "Invalid expiry_date format. Use YYYY-MM-DD."},
                        status=400
                    )

        doc.save()

        return Response({
            "success": True,
            "message": "Document updated successfully.",
            "data": {
                "id":          doc.id,
                "document_id": doc.document_id,
                "title":       doc.title,
                "description": doc.description or '',
                "type":        doc.type,
                "expiry_date": doc.expiry_date.strftime('%Y-%m-%d') if doc.expiry_date else None,
            }
        })

    # ── DELETE ─────────────────────────────────────────────────────────────
    if request.method == 'DELETE':
        doc.delete()    # hard delete, same as web page
        return Response({"success": True, "message": "Document deleted successfully."})