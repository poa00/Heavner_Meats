from typing import Text
from xmlrpc.client import Boolean
from peewee import *
from pewee_secret_model import db_cfg
import socket
from pathlib import Path
import json
from datetime import date

dbpath = Path.cwd() / 'mydatabase.db'

if dbpath.exists():
    db = SqliteDatabase(dbpath)
else:
    db = SqliteDatabase('mydatabase.db')
    dbpath = 'mydatabase.db'

# logging.basicConfig(level=logging.DEBUG)
# logger = logging.getLogger(__name__)

class JSONField(TextField):
    def db_value(self, value):
        try:
            return json.dumps(value)
        except TypeError as e:
            raise

    def python_value(self, value):
        try:
            if value is not None:
                return json.loads(value)
        except json.JSONDecodeError as e:
            raise


# class JSONField(TextField):
#     def db_value(self, value):
#         return json.dumps(value)

#     def python_value(self, value):
#         if value is not None:
#             return json.loads(value)

        
class Customer(Model):
    full_name = CharField()
    company_name = CharField()
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

    class Meta:
        database = db
        
class Events(Model):
    yweek = IntegerField(null=True)
    cows = IntegerField(null=True)
    pigs = IntegerField(null=True)
    lambs = IntegerField(null=True)
    notes = TextField(null=True)
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
    nickname = CharField(null=True)
    producer = ForeignKeyField(Customer, backref='cutsheets_as_producer')
    event = ForeignKeyField(Events, backref='cutsheets', null=True)
    recipient = ForeignKeyField(Customer, backref='cutsheets_as_recipient', null=True)

    class Meta:
        database = db


class Animals(Model):
    species = CharField()
    gender = CharField(null=True)
    organs = JSONField(null=True)
    comments = CharField(null=True)
    event = ForeignKeyField(Events, backref='animals')
    customer = ForeignKeyField(Customer, backref='animals', null=True)
    cutsheet = ForeignKeyField(Cutsheet, backref='animals', null=True)
    created_on = DateField(default=date.today)

    class Meta:
        database = db


class Cow(Model):
    animal = ForeignKeyField(Animals, backref='cows')
    live_weight = IntegerField(null=True)
    manual_entry_weight = IntegerField(null=True)
    ear_tag = CharField(null=True)
    teid = CharField(null=True)
    is_over_30_months = BooleanField(null=True)

    class Meta:
        database = db


class Pig(Model):
    animal = ForeignKeyField(Animals, backref='pigs')
    gender = CharField(null=True)
    weight = IntegerField(null=True)

    class Meta:
        database = db


class Lamb(Model):
    animal = ForeignKeyField(Animals, backref='pigs')
    gender = CharField(null=True)
    weight = IntegerField(null=True)

    class Meta:
        database = db
    
        


def is_internet_connected(host="www.google.com", port=80, timeout=0):
    """
     Checks if internet is connected. This is a wrapper around socket. create_connection to avoid problems with concurrent access
     
     Args:
     	 host: hostname or IP address of the internet server
     	 port: port to connect to the internet server ( default 80 )
     	 timeout: time in seconds to wait for a connection before giving up
     
     Returns: 
     	 True if connection is established False if not ( in which case we don't know the connection status
    """
    try:
        # Attempt to create a socket connection to the host and port
        socket.create_connection((host, port), timeout=timeout)
        return True
    except OSError:
        pass
    return False

def sql_connect(force_sqlite=False):
    """
     Connect to the database. This is a wrapper around : py : func : ` sql_connect ` to make sure we are connected to the database before returning the connection object.
     
     Args:
     	 force_sqlite: If True a database connection will be made even if it is in use.
     
     Returns: 
     	 A connection object that can be used to interact with the database. If the database could not be connected a : py
    """
    global db, dbpath
    if force_sqlite == False:
        if is_internet_connected():
            try:
                db = PostgresqlDatabase(**db_cfg())
            except Exception as e:
                db = SqliteDatabase(dbpath)
        else:
            db = SqliteDatabase(dbpath)
        try:
            db.connect()
            print(str(f"\n\n{db}\n\n"))
            return db
        except Exception as e:
            print(str(f"\n\n{e}\n\n"))
            return SqliteDatabase(dbpath)
    else:
        return SqliteDatabase(dbpath)

if __name__ == "__main__":
    sql_connect()