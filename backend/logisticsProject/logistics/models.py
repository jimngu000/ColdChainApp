from django.db import models

class User(models.Model):
    username = models.CharField(max_length=200)
    password = models.CharField(max_length=200)

class District(models.Model):
    name = models.CharField(max_length=200)
    # user = models.ForeignKey(User, on_delete=models.CASCADE)

class Hospital(models.Model):
    name = models.CharField(max_length=200)
    district = models.ForeignKey(District, on_delete=models.CASCADE)

# TODO Refrigerator model
class Refrigerator(models.Model):
   hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)

class Vaccine(models.Model):
    name = models.CharField(max_length=200)
    type = models.CharField(max_length=200)
    producer = models.CharField(max_length=200)
    value = models.CharField(max_length=200)
    refrigerator = models.ForeignKey(Refrigerator, on_delete=models.CASCADE)

class Log(models.Model):

    # TODO: this should also be a reference to a user model, which is not defined yet.
    user = models.CharField(max_length=200)

    # references
    district = models.ForeignKey(District, on_delete=models.CASCADE)
    hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)
    refrigerator = models.ForeignKey(Refrigerator, on_delete=models.CASCADE)
    vaccine = models.ForeignKey(Vaccine, on_delete=models.CASCADE)

    # TODO: previous and updated value.
    value = models.IntegerField(default=0)

    timestamp = models.DateTimeField(auto_now_add=True)

