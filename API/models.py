from typing import Text
from xmlrpc.client import Boolean
from peewee import *
from pewee_secret_model import db_cfg
import socket
from pathlib import Path
import json 

dbpath = Path.cwd() / 'mydatabase.db'
  
        
class Customer(Model):
    full_name = CharField()
    telephone = CharField()
    fax = CharField(null=True)
    mobile = CharField(null=True)
    email = CharField(null=True)
    billing_street = CharField(null=True)
    billing_city = CharField(null=True)
    billing_state = CharField(null=True)
    billing_zip = CharField(null=True)
    billing_country = CharField(null=True)
    shipping_street = CharField(null=True)
    shipping_city = CharField(null=True)
    shipping_state = CharField(null=True)
    details = CharField(null=True)
    shipping_zip = CharField(null=True)
    customerID = IntegerField(unique=True)

    class Meta:
        database = db
        
class Events(Model):
    yweek = IntegerField(null=True)
    cows = IntegerField(null=True)
    pigs = IntegerField(null=True)
    lambs = IntegerField(null=True)
    cutsheet_complete = IntegerField(null=True)
    cutsheet_remainder = CharField(null=True)
    saved_cutsheet = JSONField(null=True)
    customer = ForeignKeyField(Customer, backref='events')

    class Meta:
        database = db
        

class Cutsheet(Model):
    cutsheet = JSONField()
    day = IntegerField(null=True)
    month = IntegerField(null=True)
    year = IntegerField(null=True)
    animal = CharField(null=True)
    amount = CharField(null=True)
    producer = ForeignKeyField(Customer, backref='cutsheets_as_producer')
    event = ForeignKeyField(Events, backref='cutsheets', null=True)
    recipient = ForeignKeyField(
        Customer, backref='cutsheets_as_recipient', null=True)

    class Meta:
        database = db

        
class Animals(Model):
    species = CharField()
    live_weight = IntegerField()
    sex = CharField()
    is_over_30_months = BooleanField(null=True)
    abscess = BooleanField(null=True)
    organs_acceptable = BooleanField(null=True)
    no_organs = BooleanField(null=True)
    save_head = BooleanField(null=True)
    save_hide = BooleanField(null=True)
    comments = CharField(null=True)
    event = ForeignKeyField(Events, backref='animals')
    customer = ForeignKeyField(Events, backref='animals')

    class Meta:
        database = db

        
class Meat(Model):
    section = CharField()
    weight = CharField()
    grind = BooleanField()
    animal = ForeignKeyField(Animals, backref='meat')

    class Meta:
        database = db