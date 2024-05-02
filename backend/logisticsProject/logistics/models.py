from django.core import serializers
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
    value = models.IntegerField(default=0)

    def __str__(self):
        #build = "name: " + self.name + " district: " + self.district.name + " value: " + str(self.value)
        #return serializers.serialize('json', [self])
        return str(self.name)+","+str(self.district.name)+","+str(self.value) + " "


class Log(models.Model):
    user = models.CharField(max_length=200)
    district = models.ForeignKey(District, on_delete=models.CASCADE)
    hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)
    value = models.IntegerField(default=0)
    timestamp = models.DateTimeField(auto_now_add=True)

