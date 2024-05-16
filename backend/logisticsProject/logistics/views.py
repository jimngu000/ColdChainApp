from django.core import serializers
from django.core.serializers import serialize
from .models import Hospital, District, User, Refrigerator, Log, ConflictLog
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt


def getAllDistricts(request):
    district_list = District.objects.all()
    return HttpResponse(serialize('json', district_list), content_type="application/json")


def getHospitalsByDistrictID(request):
    district_id = request.GET.get('district_id')
    if district_id != None and request.method == 'GET':
        try:
            hospitals = Hospital.objects.filter(district_id=district_id)
            serialized_hospitals = serialize('json', hospitals)
            return HttpResponse(serialized_hospitals, content_type='application/json')
        except Hospital.DoesNotExist:
            return HttpResponse("Hospitals not found", status=404)
    else:
        return HttpResponse("Invalid request method", status=405)


def getAllUserInfo(request):
    user_list = User.objects.all()
    return HttpResponse(serialize('json', user_list), content_type="application/json")


@csrf_exempt
def addHospital(request):
    """"
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    hospitalArray = hospital.split(',')
    Hospital.objects.create(hospitalArray[0], hospitalArray[1], hospitalArray[2])
    return HttpResponse("added " + str(hospital))
    """
    if request.method == 'POST':
        for obj in serializers.deserialize('json', request.body):
            user_instance = obj.object  # Get the deserialized object
            user_instance.save()  # Save the object to the database
            print(user_instance)
    return HttpResponse("OK")


@csrf_exempt
def addUser(request):
    if request.method == 'POST':
        for obj in serializers.deserialize("json", request.body):
            user_instance = obj.object  # Get the deserialized object
            user_instance.save()  # Save the object to the database
            print(user_instance)
    return HttpResponse("OK")


@csrf_exempt
def addFridge(request):
    if request.method == 'POST':
        for obj in serializers.deserialize("json", request.body):
            user_instance = obj.object  # Get the deserialized object
            user_instance.save()  # Save the object to the database
            print(user_instance)
    return HttpResponse("OK")


def getAllFridges(request):
    fridge_list = Refrigerator.objects.all()
    return HttpResponse(serialize('json', fridge_list), content_type="application/json")


def getAllHospitals(request):
    hospital_list = Hospital.objects.all()
    return HttpResponse(serialize('json', hospital_list), content_type="application/json")


def getLog(request):
    log_list = Log.objects.all()
    return HttpResponse(serialize('json', log_list), content_type="application/json")


def getConflictLog(request):
    conflict_list = ConflictLog.objects.all()
    return HttpResponse(serialize('json', conflict_list), content_type="application/json")

def getRefrigerators(request, hospitalId):
    fridge_list = Refrigerator.objects.filter(hospital=hospitalId)
    return HttpResponse(serialize('json', fridge_list), content_type="application/json")


def logOut(request):
    return HttpResponse("OK")

def logIn(request, username, password):
    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return HttpResponse("-1,,-1")
    if user.password == password:
        if user.is_system_admin:
            return HttpResponse(str(user.id) + "," + username + "," + "2")  # System admin
        return HttpResponse(str(user.id) + "," + username + "," + "1")  # DM
    return HttpResponse("-1,,-1")  # unauthorized


@csrf_exempt
def reassignDM(request, userId, newDistrictId):
    user = User.objects.get(pk=userId)
    if user is None:
        return HttpResponse("User does not exist")
    newDistrict = District.objects.get(pk=newDistrictId)
    if newDistrict is None:
        return HttpResponse("District does not exist")
    newDistrict.user = user
    newDistrict.save()
    return HttpResponse("OK")


def getHospitalAssignments(request, userId):
    user_id = int(userId)
    districtList = District.objects.filter(user=user_id)
    hospital_list = districtList.all().first().hospital_set.all()
    for district in districtList.all():
        hospital_list = district.hospital_set.all().union(hospital_list)
    return HttpResponse(serialize('json', hospital_list), content_type="application/json")

def getDistrictAssignments(request, userId):
    user_id = int(userId)
    districtList = District.objects.filter(user=user_id)
    return HttpResponse(serialize('json', districtList), content_type="application/json")


@csrf_exempt
def updateFridge(request, userId):
    """"
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    hospitalArray = hospital.split(',')
    Hospital.objects.create(hospitalArray[0], hospitalArray[1], hospitalArray[2])
    return HttpResponse("added " + str(hospital))
    """
    if request.method == 'POST':
        user_id = int(userId)
        for obj in serializers.deserialize('json', request.body):
            fridge_instance = obj.object
        if not isinstance(fridge_instance, Refrigerator):
            return HttpResponse("Failed to update fridge")
        hospital = fridge_instance.hospital
        district = hospital.district
        caller = User.objects.get(pk=user_id)
        if caller is None:
            return HttpResponse("User does not exist")
        old_fridge = Refrigerator.objects.get(pk=fridge_instance.id)
        if old_fridge is None:
            return HttpResponse("Fridge does not exist")
        log = Log(user=caller, district=district, hospital=hospital,
                  refrigerator=fridge_instance, previous_value=serialize("json", [old_fridge]),
                  new_value=serialize("json", [fridge_instance]))
        fridge_instance.save()
        # conflict occurs if the hospital being pushed to is in someone else's assigned district
        # This does not account for synchronization issues. Only when a user pushes to another person's hospital
        users = User.objects.all()
        log.save()
        for user in users:
            if user.id != caller.id:
                if district.user.id == user.id:
                    newLog = ConflictLog(log=log)
                    newLog.save()
        return HttpResponse("OK")
    else:
        return HttpResponse("Invalid request method", status=405)


"""

def getDistrict(request, district_id):
    district_list = District.objects.all()
    return HttpResponse(district_list[int(district_id)].name)

def getHospitalCount(request, district_id):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    return HttpResponse(str(district.hospital_set.count()))

def getHospitalList(request, district_id):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    return HttpResponse(district.hospital_set.all())

def getHospitalById(request, district_id, hospital_id):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    return HttpResponse(district.hospital_set.all()[int(hospital_id)])

def getHospitalValueById(request, district_id, hospital_id):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    return HttpResponse(district.hospital_set.all()[int(hospital_id)].value)

def modifyHospitalById(request, district_id, hospital_id, value):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    hospital = district.hospital_set.all()[int(hospital_id)]
    hospital.value = value
    hospital.save()
    return HttpResponse("changed Hospital value to " + str(value))
    
"""
