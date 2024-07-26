from peewee import Model, CharField, IntegerField, PostgresqlDatabase, SqliteDatabase, ForeignKeyField
from pewee_secret_model import db_cfg
import socket
from util.progress_bar_mang import ProgressBarManager as b
from pathlib import Path

dbpath = Path.cwd() / 'mydatabase.db'

# Create a new database object.
if dbpath.exists():
    db = SqliteDatabase(dbpath)
else:
    db = SqliteDatabase('mydatabase.db')
    dbpath = 'mydatabase.db'
    

bar = b('sql connection', max=3)

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
    shipping_zip = CharField(null=True)
    details = CharField(null=True)
    customerID = IntegerField(unique=True)

    class Meta:
        database = db
        
# class Events(Model):
#     week = IntegerField(null=True)
#     cows = IntegerField(null=True)
#     pigs = IntegerField(null=True)
#     lambs = IntegerField(null=True)
#     customer = ForeignKeyField(Customer, backref='events')

#     class Meta:
#         database = db

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
     Connect to the database. This is a wrapper around : func : ` SqliteDatabase. connect `
     
     Args:
     	 force_sqlite: If True the database will be connected even if it is in use.
     
     Returns: 
     	 A connection to the database. If an error occurs it will return a : class : ` SqliteDatabase `
    """
    global db, dbpath
    bar.next()
    # Returns a database object for the current connection.
    if force_sqlite == False:
        # Returns the database object for the internet connection.
        if is_internet_connected():
            try:
                db = PostgresqlDatabase(**db_cfg())
            except Exception as e:
                db = SqliteDatabase(dbpath)
        else:
            db = SqliteDatabase(dbpath)
        bar.next()
        try:
            db.connect()
            bar.next()
            print(str(f"\n\n{db}\n\n"))
            return db
        except Exception as e:
            print(str(f"\n\n{e}\n\n"))
            return SqliteDatabase(dbpath)
    else:
        return SqliteDatabase(dbpath)

# SQL Connect to the database.
if __name__ == "__main__":
    sql_connect()