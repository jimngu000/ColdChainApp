from django.urls import path, re_path

from . import views

urlpatterns = [
    re_path(r'^$', views.index, name='index'),
    # ex: /polls/5/
    re_path(r'^(?P<district_id>[0-9]+)/getDistrict$', views.getDistrict, name='getDistrict'),
    re_path(r'^(?P<district_id>[0-9]+)/getHospitalCount/$', views.getHospitalCount, name='getHospitalCount'),
]