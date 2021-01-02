# Generated by Django 3.1.4 on 2020-12-31 08:30

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0002_auto_20201231_0328'),
    ]

    operations = [
        migrations.CreateModel(
            name='Tag_Record',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('record', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.record')),
                ('tag', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.tag')),
            ],
        ),
        migrations.CreateModel(
            name='Catalog_Record',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('catalog', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.catalog')),
                ('record', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.record')),
            ],
        ),
    ]
