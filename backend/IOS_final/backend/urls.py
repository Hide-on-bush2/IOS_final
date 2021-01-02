from django.urls import path

from . import views

urlpatterns = [
    path('record/all/',views.get_all_records,name="GetAllRecords"),
    path('record/post/',views.post_records,name="PostRecords"),
]

