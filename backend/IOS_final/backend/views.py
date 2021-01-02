from django.shortcuts import render
import json
from django.http import *
from backend.models import Record,Tag,Catalog,Tag_Record
from django.views.decorators.csrf import csrf_exempt
from datetime import datetime

# Create your views here.
def get_all_records(request):
    all_record = Record.objects.all()
    query_res = []
    for record in all_record:
        curr_record = {}
        curr_record["title"] = record.title
        curr_record["completed_date"] = str(record.completed_date)
        curr_record["content"] = record.content
        curr_record["priority"] = record.priority


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
    res = {"status":"success","data":query_res}
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
            date = datetime.strptime(param["completed_date"],"%Y/%m/%d")

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
        return "Not a post request"
    