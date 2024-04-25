from django.shortcuts import render
from .models import Hospital, District
from django.http import HttpResponse


def index(request):
    return HttpResponse("Hello, world. You're at the logistics index.")

def getDistrict(request, district_id):
    district_list = District.objects.all()
    return HttpResponse(district_list[int(district_id)].name)

def getHospitalCount(request, district_id):
    district_list = District.objects.all()
    district = district_list[int(district_id)]
    return HttpResponse(str(district.hospital_set.count()))


"""
void fetchData() async {
    var url = Uri.parse('http://127.0.0.1:8000/logistics/0/getHospitalCount/');
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
