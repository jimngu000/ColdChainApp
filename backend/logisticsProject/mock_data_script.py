
import random
import django
import os
from django.db import transaction
from django.core.management import execute_from_command_line

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'logisticsProject.settings')
django.setup()

from logistics.models import District, Hospital

# Cleanup and recreate tables.
with transaction.atomic():

    hospital_id = 1
    # Insert districts and hospitals
    for i in range(1, 11):  # Insert 10 districts
        district_name = f"District{i}"
        district = District.objects.create(name=district_name)
        num_hospitals = random.randint(2, 4)  # Randomly generate 2 to 4 hospitals per district
        for j in range(1, num_hospitals + 1):
            hospital_name = f"Hospital{hospital_id}"
            Hospital.objects.create(name=hospital_name, district=district)
            hospital_id += 1
    print("Data inserted successfully.")