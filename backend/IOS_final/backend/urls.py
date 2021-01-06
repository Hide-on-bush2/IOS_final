from django.urls import path

from . import views

urlpatterns = [
    path('record/all/',views.get_all_records,name="GetAllRecords"),
    path('record/post/',views.post_records,name="PostRecords"),
    path('record/getbycatalog/',views.get_records_by_catalog,name="GetRecordByCattalog"),
    path('record/getbytag/',views.get_records_by_tag,name="GetRecordByTag"),
    path('record/getbytime/',views.get_records_by_datetime,name="GetRecordByDatetime"),
    path('record/deletebyid/',views.delete_records_by_id,name="DeleteRecordById"),
    path('tag/all/',views.get_all_tags,name="GetAllTags"),
    path('tag/deletetag/',views.delete_tag,name="DeleteTag"),
    path('catalog/all/',views.get_all_catalogs,name="GetAllCatalogs"),
    path('catalog/post/',views.add_catalog,name="AddCatalog"),
    path('catalog/deletecatalog/',views.delete_catalog,name="DeleteCatalog"),
]

