from django.utils import timezone
from django.db import models # type: ignore
from django.utils.timezone import now # type: ignore

class client_data(models.Model):
    username = models.CharField(max_length=150,unique=True)
    password = models.CharField(max_length=255,null=False,blank=False)
    client_name = models.CharField(max_length=255, blank=True, null=True)
    business_name=models.CharField(max_length=255, blank=True, null=True)
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    status=models.CharField(max_length=10,null=False,blank=False,default="Active")
    gst = models.CharField(max_length=50, blank=True, null=True, verbose_name="GST Number")
    logo = models.URLField(max_length=500, blank=True, null=True, verbose_name="Logo URL")  # Now a link  
    address = models.TextField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)
    header_image = models.ImageField(upload_to='client_headers/', null=True, blank=True)
    quotation_footer_image = models.ImageField(upload_to='client_footers/', null=True, blank=True)
    about = models.TextField(blank=True,null=True)
    last_logout_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.username
    
    @property
    def is_authenticated(self):
        """Make client_data compatible with IsAuthenticated permission"""
        return True

    class Meta:
        db_table = "client_data"  
        

class employee(models.Model):
    employee_code = models.CharField(max_length=20,unique=True,null=False,blank=False)
    employee_name = models.CharField(max_length=100,null=False,blank=False)
    gender = models.CharField(max_length=10,null=False,blank=False)
    email = models.EmailField(unique=True)
    mobile = models.CharField(max_length=15)
    address = models.TextField(blank=True,null=True)
    designation = models.CharField(max_length=100)
    join_date = models.DateField(null=False)
    status = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    client = models.ForeignKey(client_data,on_delete=models.CASCADE,null=False)
    Password = models.CharField(max_length=255,null=True)
    def __str__(self):
        return f"{self.employee_code} - {self.employee_name}"
        db_table = "employee" 
        
class leadsource(models.Model):
    name = models.CharField(max_length=100, unique=False)
    client = models.ForeignKey(client_data, on_delete=models.CASCADE,null=False,blank=False)
    created_at = models.DateTimeField(auto_now_add=True)
    status=models.CharField(max_length=10,null=False,blank=False,default="Active")
    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "lead Source"
        verbose_name_plural = "lead Sources"
        db_table = "leadsource"  
        
        
class product(models.Model):
    client = models.ForeignKey('client_data', on_delete=models.CASCADE, related_name='products')
    name = models.CharField(max_length=150)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    gst_type = models.CharField(max_length=10, choices=[('GST', 'GST'), ('IGST', 'IGST')])
    gst = models.DecimalField(max_digits=5, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    status=models.CharField(max_length=10,null=False,blank=False,default="Active")
    hsn_code = models.CharField(max_length=20,blank=True,null=True)
    class Meta:
        db_table = "product"

    def __str__(self):
        return self.name
    
    
class leads_table(models.Model):
    client = models.ForeignKey('client_data', on_delete=models.CASCADE, related_name='leads')
    customer_name = models.CharField(max_length=150)
    phone = models.CharField(max_length=15)
    email = models.EmailField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)
    product_category = models.CharField(max_length=100)
    lead_source = models.ForeignKey('leadsource', on_delete=models.CASCADE,null=False,blank=False)
    requirement_details = models.TextField(blank=True, null=True)
    next_followup_date = models.DateField(null=True, blank=True)
    followup_time = models.TimeField(null=True, blank=True)
    status = models.CharField(max_length=20, default='New')
    remarks = models.TextField(blank=True, null=True)    
    assign_to = models.CharField(max_length=100, blank=True, null=True) 
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    deleted_at= models.DateTimeField(null=True)
    staff=models.ForeignKey("employee",on_delete=models.CASCADE,null=True)

    class Meta:
        db_table="leads_table"

    def __str__(self):
        return f"{self.customer_name} - {self.phone}"
    
class enquiryfor(models.Model):
    client = models.ForeignKey(client_data, on_delete=models.CASCADE, related_name='enquiry_categories')
    name = models.CharField(max_length=100, unique=False)  
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    status=models.CharField(max_length=10,null=False,blank=False,default="Active")

    class Meta:
        verbose_name = "Enquiry Category"
        verbose_name_plural = "Enquiry Categories"
        unique_together = ('client', 'name')
        db_table='enquiryfor'

    def __str__(self):
        return self.name
    
    
class quotation(models.Model):
    client = models.ForeignKey(client_data, on_delete=models.CASCADE)
    lead = models.ForeignKey(leads_table, on_delete=models.SET_NULL, null=True, blank=True)
    client_name = models.CharField(max_length=200)
    client_phone = models.CharField(max_length=20)
    client_email = models.CharField(max_length=100, blank=True)
    client_address = models.TextField(blank=True)
    subtotal = models.DecimalField(max_digits=12, decimal_places=2)
    gst_type = models.CharField(max_length=10, choices=[('GST', 'GST'), ('IGST', 'IGST')])
    gst_amount = models.DecimalField(max_digits=12, decimal_places=2)
    total = models.DecimalField(max_digits=12, decimal_places=2)
    notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    valid_upto = models.DateField(null=False,blank=True)
    cgst = models.DecimalField(max_digits=12, decimal_places=2,null=True)
    sgst = models.DecimalField(max_digits=12, decimal_places=2,null=True)
    igst= models.DecimalField(max_digits=12, decimal_places=2,null=True)
    quotation_number=models.CharField(max_length=80,null=True,blank=True)
    version=models.CharField(max_length=20,null=True,blank=True)
    staff=models.ForeignKey("employee",on_delete=models.CASCADE,null=True)

    class Meta:
        db_table ="quotation"
    
class quotationitem(models.Model):
    quotation = models.ForeignKey(quotation, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField()
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    cgst = models.DecimalField(max_digits=12, decimal_places=2,null=True)
    sgst = models.DecimalField(max_digits=12, decimal_places=2,null=True)
    igst= models.DecimalField(max_digits=12, decimal_places=2,null=True)
    description = models.TextField(blank=True,null=True)
    unit = models.CharField(max_length=50, blank=True,null=True)
    spec = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table ="quotationitem"

class followup_table(models.Model):
    lead_id = models.IntegerField()
    client_id = models.IntegerField()
    status = models.CharField(max_length=50)
    next_followup_date = models.DateField(null=True, blank=True)
    next_followup_time = models.TimeField(null=True, blank=True)
    converted_time = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(default=now)

    def save(self, *args, **kwargs):
        if self.status and self.status.lower() == "converted" and self.converted_time is None:
            self.converted_time = now()
        super().save(*args, **kwargs)
    class Meta:
        db_table ="followup_table"



class followupremark(models.Model):
    followup_id = models.ForeignKey(followup_table, on_delete=models.CASCADE, related_name="remarks")
    lead_id = models.IntegerField()
    client_id = models.IntegerField()
    remark_date = models.DateField(default=now)
    remark_text = models.CharField(max_length=500)
    created_at = models.DateTimeField(default=now)
    class Meta:
        db_table ="followupremark"


class document(models.Model):
    client = models.ForeignKey(client_data, on_delete=models.CASCADE)
    document_id = models.CharField(max_length=50, unique=True)  # e.g., DOC-001
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    type = models.CharField(max_length=20, default='Other')
    created_at = models.DateTimeField(auto_now_add=True)
    expiry_date=models.DateField(null=True,blank=True)
    def __str__(self):
        return f"{self.document_id} - {self.title}"

    class Meta:
        db_table ="document"
        ordering = ['-created_at']
        
        
class terms_conditions(models.Model):
    client = models.ForeignKey('client_data',on_delete=models.CASCADE,related_name='terms_conditions')
    content = models.TextField(blank=True,null=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = "Terms and Conditions"
        ordering = ['-updated_at']
        db_table = "terms_conditions"
    def __str__(self):
        return f"Terms and Conditions- {self.client.client_name} ({self.updated_at.date()})"
    
class company(models.Model):
    username = models.CharField(max_length=150,unique=True)
    password = models.CharField(max_length=255,null=False,blank=False)
    class Meta:
        db_table ="company"