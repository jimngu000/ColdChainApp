import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'logisticsProject.settings')
django.setup()

from django.apps import apps
from django.db import transaction, IntegrityError

def clear_all_data():
    for model in apps.get_models():
        try:
            # Using transaction.atomic() to ensure that changes can be rolled back if needed
            with transaction.atomic():
                model.objects.all().delete()
                print(f"Cleared all data from {model._meta.db_table}")
        except IntegrityError as e:
            print(f"Failed to clear data from {model._meta.db_table}: {e}")

if __name__ == '__main__':
    clear_all_data()
