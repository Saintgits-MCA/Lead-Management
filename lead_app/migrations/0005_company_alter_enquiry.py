from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('lead_app', '0004_client_data_last_logout_at'),
    ]

    operations = [
        # From 0046_alter_enquiryfor_name
        migrations.AlterField(
            model_name='enquiryfor',
            name='name',
            field=models.CharField(max_length=100),
        ),
        
        # From 0049_delete_company
        migrations.DeleteModel(
            name='Company',
        ),
        
        # From 0050_company (recreating company model)
        migrations.CreateModel(
            name='company',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=150, unique=True)),
                ('password', models.CharField(max_length=255)),
                ('company_name', models.CharField(default='Tisser', max_length=255)),
                ('email', models.EmailField(max_length=255, unique=True)),
                ('phone', models.CharField(max_length=20)),
                ('gst', models.CharField(blank=True, help_text='GST Number (Optional)', max_length=20, null=True)),
                ('address', models.TextField(default='')),
                ('logo', models.ImageField(blank=True, null=True, upload_to='company_logos/')),
                ('created_at', models.DateTimeField(auto_now=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('is_active', models.BooleanField(default=True)),
            ],
            options={
                'db_table': 'company',
            },
        ),
    ]