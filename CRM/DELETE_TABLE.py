import peewee
from peewee import *


db = peewee.connect('sqlite:///mydatabase.db')
MyModel.delete().execute()



class MyModel(Model):
     name = TextField()
     age = IntegerField()
     class Meta:
        database = 'mydatabase'

# Adding a new field to the model
class MyModel(Model):
    name = TextField()
    age = IntegerField()
    location = GeoPointField()

    class Meta:
        database = 'mydatabase'
        
 # Inserting a column into an existing table
class MyModel(Model):
    id = PrimaryKeyField()
    name = TextField()
    age = IntegerField()

    class Meta:
        database = 'mydatabase'
        column_a = StringField()
        column_b = BooleanField()
 # Deleting a table
db = peewee.connect('sqlite:///mydatabase.db')
MyModel.delete().execute()
