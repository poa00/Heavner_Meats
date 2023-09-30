from peewee import Model, CharField, IntegerField, PostgresqlDatabase, SqliteDatabase, ForeignKeyField
from pewee_secret_model import db_cfg
import socket
from pathlib import Path

dbpath = Path.cwd() / 'mydatabase.db'

if dbpath.exists():
    db = SqliteDatabase(dbpath)
else:
    db = SqliteDatabase('mydatabase.db')
    dbpath = 'mydatabase.db'
    

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
    week = IntegerField(null=True)
    cows = IntegerField(null=True)
    pigs = IntegerField(null=True)
    lambs = IntegerField(null=True)
    customer = ForeignKeyField(Customer, backref='events')

    class Meta:
        database = db

def is_internet_connected(host="www.google.com", port=80, timeout=0):
    try:
        # Attempt to create a socket connection to the host and port
        socket.create_connection((host, port), timeout=timeout)
        return True
    except OSError:
        pass
    return False

def sql_connect(force_sqlite=False):
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