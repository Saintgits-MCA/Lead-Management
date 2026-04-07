from rest_framework import serializers
from decimal import Decimal
from .models import (
    client_data, employee, leadsource, enquiryfor, product,
    leads_table, quotation, quotationitem, document, terms_conditions
)


class EmployeeSerializer(serializers.ModelSerializer):
    Password = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = employee
        fields = [
            'id', 'employee_code', 'employee_name', 'gender', 'email',
            'mobile', 'address', 'designation', 'join_date', 'status', 'Password'
        ]
        extra_kwargs = {
            'employee_code': {'required': True},
            'employee_name': {'required': True},
            'email': {'required': True},
            'mobile': {'required': True},
            'join_date': {'required': True},
        }

    def validate_employee_code(self, value):
        queryset = employee.objects.filter(employee_code__iexact=value)
        if self.instance:
            queryset = queryset.exclude(id=self.instance.id)
        if queryset.exists():
            raise serializers.ValidationError("Employee code already exists.")
        return value.upper()

    def validate_email(self, value):
        queryset = employee.objects.filter(email__iexact=value)
        if self.instance:
            queryset = queryset.exclude(id=self.instance.id)
        if queryset.exists():
            raise serializers.ValidationError("Email already registered.")
        return value

    def validate_mobile(self, value):
        queryset = employee.objects.filter(mobile=value)
        if self.instance:
            queryset = queryset.exclude(id=self.instance.id)
        if queryset.exists():
            raise serializers.ValidationError("Mobile number already registered.")
        return value


class LeadSourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = leadsource
        fields = ['id', 'name', 'status']


class EnquiryCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = enquiryfor
        fields = ['id', 'name', 'status']


class ProductSerializer(serializers.ModelSerializer):
    rate = serializers.DecimalField(max_digits=12, decimal_places=2)
    gst = serializers.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        model = product
        fields = ['id', 'name', 'hsn_code', 'rate', 'gst_type', 'gst']


class LeadSerializer(serializers.ModelSerializer):
    lead_source = serializers.PrimaryKeyRelatedField(
        queryset=leadsource.objects.none(), required=True
    )

    class Meta:
        model = leads_table
        fields = [
            'id', 'customer_name', 'phone', 'email', 'address', 'location',
            'product_category', 'lead_source', 'requirement_details',
            'next_followup_date', 'followup_time', 'status', 'remarks', 'assign_to'
        ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        client = self.context.get('request').user if self.context.get('request') else None
        if client:
            self.fields['lead_source'].queryset = leadsource.objects.filter(client=client, status="Active")


class QuotationItemSerializer(serializers.Serializer):
    product_id = serializers.IntegerField(required=True)
    quantity = serializers.DecimalField(max_digits=10, decimal_places=2, required=True)
    rate = serializers.DecimalField(max_digits=12, decimal_places=2, required=True)
    description = serializers.CharField(required=False, allow_blank=True)
    unit = serializers.CharField(required=False, allow_blank=True)
    spec = serializers.CharField(required=False, allow_blank=True)


class QuotationCreateSerializer(serializers.Serializer):
    lead_id = serializers.IntegerField(required=True)
    client_name = serializers.CharField(required=True)
    client_phone = serializers.CharField(required=True)
    client_email = serializers.EmailField(required=False, allow_blank=True)
    client_address = serializers.CharField(required=False, allow_blank=True)
    subtotal = serializers.DecimalField(max_digits=12, decimal_places=2, required=True)
    gst_amount = serializers.DecimalField(max_digits=12, decimal_places=2, required=True)
    cgst = serializers.DecimalField(max_digits=12, decimal_places=2, required=False, allow_null=True)
    sgst = serializers.DecimalField(max_digits=12, decimal_places=2, required=False, allow_null=True)
    igst = serializers.DecimalField(max_digits=12, decimal_places=2, required=False, allow_null=True)
    total = serializers.DecimalField(max_digits=12, decimal_places=2, required=True)
    valid_upto = serializers.DateField(required=True)
    notes = serializers.CharField(required=False, allow_blank=True)
    gst_type = serializers.ChoiceField(choices=['GST', 'IGST'], default='GST')
    items = serializers.ListField(
        child=QuotationItemSerializer(),
        min_length=1,
        required=True
    )


class DocumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = document
        fields = ['id', 'document_id', 'title', 'description', 'type', 'expiry_date']


class TermsConditionsSerializer(serializers.ModelSerializer):
    class Meta:
        model = terms_conditions
        fields = ['content']


class ClientProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = client_data
        fields = [
            'client_name', 'business_name', 'email', 'gst',
            'website', 'address', 'about'
        ]
        read_only_fields = ['phone_number']