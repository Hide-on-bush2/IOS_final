from typing import Callable
from django.shortcuts import render
import json
from django.http import *
from backend.models import Record,Tag,Catalog,Tag_Record
from django.views.decorators.csrf import csrf_exempt
from datetime import datetime


def get_all_records(request):
    all_record = Record.objects.all()
    query_res = []
    for record in all_record:
        curr_record = {}
        curr_record["title"] = record.title
        curr_record["completed_date"] = str(record.completed_date)
        curr_record["content"] = record.content
        curr_record["priority"] = record.priority
        curr_record["id"] = record.id

        #通过catalog_id去Catalog表找catalog_name
        curr_catalog_id = record.catalog_id
        curr_catalog = Catalog.objects.get(pk = curr_catalog_id)
        curr_record["catalog"] = curr_catalog.catalog_name

        #去Tag_Record表找初所有的tag
        all_tags = Tag_Record.objects.filter(record_id=record.id)
        tags = []
        for item in all_tags:
            tags.append(Tag.objects.get(pk=item.tag_id).tag_name)

        curr_record["tags"] = tags

        query_res.append(curr_record)
    res = {"status":"success","num":len(query_res),"data":query_res}
    return HttpResponse(json.dumps(res), content_type="application/json")

def get_records_by_tag(request):

    return HttpResponse("You get all records")

@csrf_exempt
def post_records(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if len(param):
            print(param)
            need_key = ["title","completed_date","content","priority","catalog","tags"]
            for key in need_key:
                if key not in param:
                    res = {"status":"failure","data":"lack of param"}
                    return HttpResponse(json.dumps(res), content_type="application/json")

            #寻找catalog，不存在就返回failure
            catalog = Catalog.objects.filter(catalog_name=param["catalog"])
            if not catalog.exists():
                res = {"status":"failure","data":"catalog not exits"}
                return HttpResponse(json.dumps(res), content_type="application/json")
            
            #处理日期数据
            try:
                date = datetime.strptime(param["completed_date"],"%Y/%m/%d/%H/%M/%S")
            except ValueError:
                return HttpResponse(json.dumps({"status":"failure","data":"Incorrect date format, should be Y/m/d/H/M/S"}), content_type="application/json")

            new_record = Record(title=param["title"],completed_date=date,content=param["content"],priority=param["priority"],catalog_id=catalog[0].id)
            new_record.save()

            for tag_name in param["tags"]:
                tag = Tag.objects.filter(tag_name=tag_name)
                if tag.exists():
                    tag_record = Tag_Record(tag_id=tag[0].id,record_id=new_record.id)
                    tag_record.save()
                else:
                    new_tag = Tag(tag_name=tag_name)
                    new_tag.save()
                    tag_record = Tag_Record(tag_id=new_tag.id,record_id=new_record.id)
                    tag_record.save()
            return HttpResponse(json.dumps({"status":"success","data":""}), content_type="application/json")
        else:
            return HttpResponse(json.dumps({"status":"failure","data":"You post nothing"}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")
    

def get_all_tags(request):
    all_tags = Tag.objects.all()
    if not all_tags.exists():
        return HttpResponse(json.dumps({"status":"failure","data":"no tags"}), content_type="application/json")    
    res = []
    for tag in all_tags:
        res.append(tag.tag_name)
    return HttpResponse(json.dumps({"status":"success","data":res}), content_type="application/json")

def get_all_catalogs(request):
    all_catalogs = Catalog.objects.all()
    if not all_catalogs.exists():
        return HttpResponse(json.dumps({"status":"failure","data":"no catalogs"}), content_type="application/json")    
    res = []
    for catalog in all_catalogs:
        res.append(catalog.catalog_name)
    return HttpResponse(json.dumps({"status":"success","data":res}), content_type="application/json")

@csrf_exempt
def add_catalog(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if len(param):
            # print(param)
            if "catalog_name" not in param:
                return HttpResponse(json.dumps({"status":"failure","data":"key 'catalog' not found"}), content_type="application/json")
            curr_catalog_name = param["catalog_name"]
            catalog = Catalog.objects.filter(catalog_name=curr_catalog_name)
            if catalog.exists():
                return HttpResponse(json.dumps({"status":"failure","data":"catalog " + curr_catalog_name +  " exits"}), content_type="application/json")
            new_catalog = Catalog(catalog_name=curr_catalog_name)
            new_catalog.save()
            return HttpResponse(json.dumps({"status":"success","data":""}), content_type="application/json")
        else:
            return HttpResponse(json.dumps({"status":"failure","data":"You post nothing"}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def get_records_by_catalog(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "catalog_name" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'catalog_name' not found"}), content_type="application/json")
        curr_catalog_name = param["catalog_name"]
        catalog_query = Catalog.objects.filter(catalog_name=curr_catalog_name)
        if not catalog_query.exists():
            return HttpResponse(json.dumps({"status":"failure","data":"catalog " + curr_catalog_name +  " not exits"}), content_type="application/json")
        curr_catalog_id = catalog_query[0].id
        records = Record.objects.filter(catalog_id=curr_catalog_id)
        res = []
        for record in records:
            curr_record = {}
            curr_record["title"] = record.title
            curr_record["completed_date"] = str(record.completed_date)
            curr_record["content"] = record.content
            curr_record["priority"] = record.priority
            curr_record["id"] = record.id

            #通过catalog_id去Catalog表找catalog_name
            curr_catalog_id = record.catalog_id
            curr_catalog = Catalog.objects.get(pk = curr_catalog_id)
            curr_record["catalog"] = curr_catalog.catalog_name

            #去Tag_Record表找初所有的tag
            all_tags = Tag_Record.objects.filter(record_id=record.id)
            tags = []
            for item in all_tags:
                tags.append(Tag.objects.get(pk=item.tag_id).tag_name)

            curr_record["tags"] = tags

            res.append(curr_record)
        
        return HttpResponse(json.dumps({"status":"success","num":len(res),"data":res}), content_type="application/json")

    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def get_records_by_tag(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "tag_name" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'tag_name' not found"}), content_type="application/json")
        curr_tag_name = param["tag_name"]
        curr_tag = Tag.objects.filter(tag_name=curr_tag_name)
        if not curr_tag.exists():
            return HttpResponse(json.dumps({"status":"failure","data":"tag " + curr_tag_name + " not exit"}), content_type="application/json")
        curr_tag_id = curr_tag[0].id
        records_id = Tag_Record.objects.filter(tag_id=curr_tag_id)
        res = []
        for record_id in records_id:
            record = Record.objects.get(pk=record_id.record_id)
            curr_record = {}
            curr_record["title"] = record.title
            curr_record["completed_date"] = str(record.completed_date)
            curr_record["content"] = record.content
            curr_record["priority"] = record.priority
            curr_record["id"] = record.id

            #通过catalog_id去Catalog表找catalog_name
            curr_catalog_id = record.catalog_id
            curr_catalog = Catalog.objects.get(pk = curr_catalog_id)
            curr_record["catalog"] = curr_catalog.catalog_name

            #去Tag_Record表找初所有的tag
            all_tags = Tag_Record.objects.filter(record_id=record.id)
            tags = []
            for item in all_tags:
                tags.append(Tag.objects.get(pk=item.tag_id).tag_name)

            curr_record["tags"] = tags

            res.append(curr_record)
        return HttpResponse(json.dumps({"status":"success","num":len(res),"data":res}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def get_records_by_datetime(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "datetime" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'datetime' not found"}), content_type="application/json")
        curr_datetime = param["datetime"]
        start_datetime = curr_datetime
        end_datetime = start_datetime + "/23/59/59"

        try:
            start_date = datetime.strptime(start_datetime,"%Y/%m/%d")
            end_date = datetime.strptime(end_datetime,"%Y/%m/%d/%H/%M/%S")
        except ValueError:
            return HttpResponse(json.dumps({"status":"failure","data":"Incorrect date format"}), content_type="application/json")
        
        records = Record.objects.filter(completed_date__gte=start_date,completed_date__lte=end_date)
        res = []
        for record in records:
            curr_record = {}
            curr_record["title"] = record.title
            curr_record["completed_date"] = str(record.completed_date)
            curr_record["content"] = record.content
            curr_record["priority"] = record.priority
            curr_record["id"] = record.id

            #通过catalog_id去Catalog表找catalog_name
            curr_catalog_id = record.catalog_id
            curr_catalog = Catalog.objects.get(pk = curr_catalog_id)
            curr_record["catalog"] = curr_catalog.catalog_name

            #去Tag_Record表找初所有的tag
            all_tags = Tag_Record.objects.filter(record_id=record.id)
            tags = []
            for item in all_tags:
                tags.append(Tag.objects.get(pk=item.tag_id).tag_name)

            curr_record["tags"] = tags

            res.append(curr_record)
        return HttpResponse(json.dumps({"status":"success","num":len(res),"data":res}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def delete_records_by_id(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "record_id" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'record_id' not found"}), content_type="application/json")
        curr_record_id = param["record_id"]
        curr_record = Record.objects.filter(pk=curr_record_id)
        if not curr_record.exists():
            return HttpResponse(json.dumps({"status":"failure","data":"the record to be deleted not exit"}), content_type="application/json")
        tag_records = Tag_Record.objects.filter(record_id=curr_record_id)
        tags_id = []
        for item in tag_records:
            tags_id.append(item.tag_id)
        #删除tag_record表中的记录
        tag_records.delete()
        for tag_id in tags_id:
            t_tag_record = Tag_Record.objects.filter(tag_id=tag_id)
            if not t_tag_record.exists():
                deleted_tag = Tag.objects.filter(pk=tag_id)
                deleted_tag.delete()
        curr_record.delete()
        #将Tag_Record表中的记录删了
        return HttpResponse(json.dumps({"status":"success","data":""}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def delete_catalog(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "catalog_name" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'catalog_name' not found"}), content_type="application/json")
        catalog_name = param["catalog_name"]
        catalog = Catalog.objects.filter(catalog_name=catalog_name)
        if not catalog.exists():
            return HttpResponse(json.dumps({"status":"failure","data":"the catalog to be deleted not exit"}), content_type="application/json")
        catalog.delete()
        return HttpResponse(json.dumps({"status":"success","data":""}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")

@csrf_exempt
def delete_tag(request):
    if request.method == "POST":
        param = json.loads(request.body.decode())
        if "tag_name" not in param:
            return HttpResponse(json.dumps({"status":"failure","data":"key 'tag_name' not found"}), content_type="application/json")
        tag_name = param["tag_name"]
        tag = Tag.objects.filter(tag_name=tag_name)
        if not tag.exists():
            return HttpResponse(json.dumps({"status":"failure","data":"the tag to be deleted not exit"}), content_type="application/json")
        tag_id = tag[0].id
        tag_record_query = Tag_Record.objects.filter(tag_id=tag_id)
        record_id_set = set()
        for tag_record in tag_record_query:
            record_id_set.add(tag_record.record_id)
        print(record_id_set)
        tag_record_query.delete()
        tag.delete()
        for record_id in record_id_set:
            other_tag_record = Tag_Record.objects.filter(record_id=record_id)
            other_tag_ids = set()
            for item in other_tag_record:
                other_tag_ids.add(item.tag_id)
            other_tag_record.delete()
            for tag_id in other_tag_ids:
                t_tag_record_query = Tag_Record.objects.filter(tag_id=tag_id)
                if not t_tag_record_query.exists():
                    deleted_tag = Tag.objects.filter(id=tag_id)
                    deleted_tag.delete()
            record = Record.objects.filter(id=record_id)
            if record.exists():
                record.delete()
        
        return HttpResponse(json.dumps({"status":"success","data":""}), content_type="application/json")
    else:
        return HttpResponse(json.dumps({"status":"failure","data":"Not a post request"}), content_type="application/json")