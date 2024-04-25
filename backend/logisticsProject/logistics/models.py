from django.db import models


# id should be automatically generated as a primary key
# Create your models here.
class District(models.Model):
    name = models.CharField(max_length=200)

    def __str__(self):
        return self.name


class Hospital(models.Model):
    name = models.CharField(max_length=200)
    district = models.ForeignKey(District, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
