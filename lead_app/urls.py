from django.urls import path,include # type: ignore
from . import views
from django.conf import settings # type: ignore
from django.conf.urls.static import static # type: ignore

urlpatterns = [
    path('', views.client_admin_login, name='login'),
    path('logout/', views.logout, name='logout'),
    path('dashboard/', views.client_admin_dashboard, name='dashboard'),
    path('employees/', views.employee_list, name='employee_list'),
    path('employees/create/', views.employee_create, name='employee_create'),
    path("lead-source/", views.lead_source_list, name="lead_source_list"),
    path("validate-lead-source/", views.validate_lead_source, name="validate_lead_source"),
    path("product-master/", views.product_master, name="product_master"),
    path("leads/", views.leads_page, name="leads"),
    path("profile/", views.client_admin_profile, name="client_admin_profile"),
    path("profile/save/", views.save_client_profile, name="save_client_profile"),
    path("company/login/", views.company_login, name="company_login"),
    path("company/dashboard/", views.company_dashboard, name="company_dashboard"),
    path("company/clients/", views.company_clients, name="company_clients"),
    path("company/clients/create/", views.create_client, name="create_client"),
    path('company/client-detail/<int:id>/', views.client_detail, name='client_detail'),
    path('company/suspend-client/<int:id>/', views.delete_client, name='suspend_client'),
    path('company/update-client/', views.update_client, name='update_client'),
    path('get-employee/<int:id>/', views.get_employee, name='get_employee'),
    path('update-employee/', views.update_employee, name='update_employee'),
    path('get-lead/<int:lead_id>/', views.get_lead, name='get_lead'),
    path('company/logout/',views.company_logout,name="company_logout"),
    path('enquiry-category/', views.enquiry_category_list, name='enquiry_category_list'),
    path('quotation-maker/<int:lead_id>/', views.quotation_maker, name='quotation_maker'),
    path('quotation-pdf/<int:quotation_id>/', views.quotation_pdf, name='quotation_pdf'),
    path('quotation-pdf/<int:quotation_id>/<int:client_id>/', views.quotation_pdf, name='quotation_pdf_with_client'),
    path("quotation/edit/<int:quotation_id>/", views.edit_quotation, name="quotation_edit"),
    path("followup/",views.followup,name="followup"),
    path('documents/', views.document_master, name='document_master'),
    path('reminders/', views.reminder_list_view, name='reminder_list'),
    path('client_admin_settings/', views.client_settings_view, name='client_settings'),
    path('employee-login/', views.employee_login, name='employee_login'),
    path('employee-dashboard/', views.employee_dashboard, name='employee_dashboard'),
    path('employee-leads/', views.employee_leads, name='employee_leads'),
    path('employee-logout/', views.employee_logout, name='employee_logout'),
    path('employee-profile/', views.employee_profile, name='employee_profile'),
    path('employee-quotation/<int:lead_id>/', views.employee_quotation_maker, name='employee_quotation_maker'),
    path('employee_quotation_edit/<int:quotation_id>/',views.employee_edit_quotation,name="employee_quotation_edit"),
    path('terms-conditions/', views.terms_conditions_view, name='terms_conditions'),
    path('terms-conditions/<int:client_id>/', views.save_terms_conditions, name='save_terms_conditions'),
    path('delete-terms/<int:client_id>/', views.delete_terms_conditions, name='delete_terms_conditions'),
    path("forgot-password/", views.forgot_password, name="forgot_password"),
    path("reset-password/<uidb64>/", views.reset_password, name="reset_password"),
    #rest-api urls are below
    path('api/client/login/', views.api_client_login, name='api_client_login'),
    path('api/client/logout/', views.api_client_logout, name='api_client_logout'),
    path('api/client/dashboard/stats/', views.api_dashboard_stats, name='api_dashboard_stats'),
    path('api/client/lead-summary/', views.api_lead_summary, name='api_lead_summary'),
    # Employees
    path('api/client/employees/', views.api_employee_list_create, name='api_employee_list_create'),
    path('api/client/employees/<int:pk>/', views.api_employee_detail, name='api_employee_detail'),
    # Products
    path('api/client/products/', views.api_product_list_create, name='api_product_list_create'),
    path('api/client/products/<int:pk>/', views.api_product_detail, name='api_product_detail'),
    # Lead Sources
    path('api/client/lead-sources/', views.api_leadsource_list_create, name='api_leadsource_list_create'),
    path('api/client/lead-sources/<int:pk>/', views.api_leadsource_detail, name='api_leadsource_detail'),
    # Enquiry Categories
    path('api/client/enquiry-categories/', views.api_enquiry_category_list_create, name='api_enquiry_category_list_create'),
    path('api/client/enquiry-categories/<int:pk>/', views.api_enquiry_category_detail, name='api_enquiry_category_detail'),
    # Leads (most important CRUD)
    path('api/client/leads/', views.api_lead_list_create, name='api_lead_list_create'),
    path('api/client/leads/<int:pk>/', views.api_lead_detail, name='api_lead_detail'),
    path('api/client/leads/<int:pk>/followup/', views.api_lead_followup_update, name='api_lead_followup'),
    path('api/client/followup/', views.api_leads_with_quotations, name='api_leads_with_quotations'),

    # Quotations
    path('api/client/quotations/', views.api_quotation_list, name='api_quotation_list'),
    path('api/client/quotations/create-from-lead/<int:lead_id>/', views.api_create_quotation, name='api_create_quotation'),
    path('api/client/quotations/<int:pk>/', views.api_quotation_detail_update, name='api_quotation_detail'),
    path('api/client/leads/quotation-pdf/<int:lead_id>/', views.api_quotation_pdf_by_lead, name='api_quotation_pdf_data_by_lead'),
    # Profile
    path('api/client/profile/', views.api_client_profile_detail_update, name='api_client_profile'),
    # Terms & Conditions
    path('api/client/terms-conditions/', views.api_terms_conditions_detail_update, name='api_terms_conditions'),
    path('api/client/documents/', views.api_document_list_create, name='api_document_list_create'),
    path('api/client/documents/<int:pk>/', views.api_document_detail, name='api_document_detail'),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)