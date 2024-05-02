from django.core import serializers
from django.shortcuts import render
from .models import Hospital, District
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt


def index(request):
    return HttpResponse("Hello, world. You're at the logistics index.")

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
            user_instance.save()   # Save the object to the database
            print(user_instance)
    return HttpResponse("OK")


""""
void fetchData() async {
    var url = Uri.parse('http://127.0.0.1:8000/logistics/0/getHospitalCount');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('Data fetched successfully:');
        print(response.body);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }
"""
