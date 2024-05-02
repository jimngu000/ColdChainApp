from django.urls import path, re_path

from . import views

urlpatterns = [
    re_path(r'^$', views.index, name='index'),
    # ex: /polls/5/
    re_path(r'^getDistrict/(?P<district_id>[0-9]+)$', views.getDistrict, name='getDistrict'),
    re_path(r'^getHospitalCount/(?P<district_id>[0-9]+)$', views.getHospitalCount, name='getHospitalCount'),
    re_path(r'^getHospitalList/(?P<district_id>[0-9]+)$', views.getHospitalList, name='getHospitalList'),
    #re_path(r'^getHospitalList/(?P<district_id>[0-9]+)$', views.getHospitalList, name='getHospitalList'),
    re_path(r'^getHospitalById/(?P<district_id>[0-9]+)/(?P<hospital_id>[0-9]+)$', views.getHospitalById, name='getHospitalById'),
    re_path(r'^getHospitalValueById/(?P<district_id>[0-9]+)/(?P<hospital_id>[0-9]+)$', views.getHospitalValueById, name='getHospitalValueById'),
    re_path(r'^modifyHospitalById/(?P<district_id>[0-9]+)/(?P<hospital_id>[0-9]+)/(?P<value>[0-9]+)$', views.modifyHospitalById, name='modifyHospitalById'),
    re_path(r'^addHospital', views.addHospital, name='addHospital'),
]