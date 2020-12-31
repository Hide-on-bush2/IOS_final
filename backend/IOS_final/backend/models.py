from django.db import models

# Create your models here.
class Tag(models.Model):
    tag_name = models.CharField(max_length=255)
    def __str__(self) -> str:
        return self.tag_name

class Catalog(models.Model):
    catalog_name = models.CharField(max_length=255)
    def __str__(self) -> str:
        return self.catalog_name

class Record(models.Model):
    title = models.CharField(max_length=255)
    completed_date = models.DateTimeField("date completed")
    content = models.TextField()
    priority = models.IntegerField(default=0) #0无优先级 1低优先级 2中优先级 3高优先级
    tag = models.ForeignKey(Tag,on_delete=models.CASCADE)
    catalog = models.ForeignKey(Catalog,on_delete=models.CASCADE)

    def __str__(self) -> str:
        return self.title
