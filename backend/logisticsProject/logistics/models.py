from django.db import models

class District(models.Model):
    name = models.CharField(max_length=200)

class Hospital(models.Model):
    name = models.CharField(max_length=200)
    district = models.ForeignKey(District, on_delete=models.CASCADE)
    
class Vaccine(models.Model):
    name = models.CharField(max_length=200)
    type = models.CharField(max_length=200)
    producer = models.CharField(max_length=200)
    hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)

class Log(models.Model):
    user = models.CharField(max_length=200)
    district = models.ForeignKey(District, on_delete=models.CASCADE)
    hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)
    value = models.IntegerField(default=0)
    timestamp = models.DateTimeField(auto_now_add=True)

