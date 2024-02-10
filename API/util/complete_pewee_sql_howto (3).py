# pip install peewee psycopg2
from pathlib import Path
from peewee import PostgresqlDatabase, Model, CharField, ForeignKeyField, SqliteDatabase

# Connect to the PostgreSQL database
# db = PostgresqlDatabase('wexlqizj', user='wexlqizj', password='6RrqsNEMPMAwnnNZ1lFRxLgsh0BJp5nA', host='baasu.db.elephantsql.com', port=5432)

db_path = Path.cwd() / "customer_database.db"
db = SqliteDatabase(str(db_path))

# Define the models
class Department(Model):
    name = CharField(unique=True)

    class Meta:
        database = db

class Employee(Model):
    name = CharField()
    department = ForeignKeyField(Department, backref='employees')

    class Meta:
        database = db

class Task(Model):
    name = CharField()
    employee = ForeignKeyField(Employee, backref='tasks')

    class Meta:
        database = db

# Create tables defined by the models
db.connect()
db.create_tables([Department, Employee, Task])



def insert_data():
    engineering = Department.create(name='Engineering')
    john = Employee.create(name='John Doe', department=engineering)
    task1 = Task.create(name='Task 1', employee=john)
    task2 = Task.create(name='Task 2', employee=john)






from peewee import *
import datetime


db = SqliteDatabase('my_database.db')

class BaseModel(Model):
    class Meta:
        database = db

class User(BaseModel):
    username = CharField(unique=True)

class Tweet(BaseModel):
    user = ForeignKeyField(User, backref='tweets')
    message = TextField()
    created_date = DateTimeField(default=datetime.datetime.now)
    is_published = BooleanField(default=True)
Connect to the database and create tables:

db.connect()
db.create_tables([User, Tweet])
Create a few rows:

charlie = User.create(username='charlie')
huey = User(username='huey')
huey.save()

# No need to set `is_published` or `created_date` since they
# will just use the default values we specified.
Tweet.create(user=charlie, message='My first tweet')
Queries are expressive and composable:

# A simple query selecting a user.
User.get(User.username == 'charlie')

# Get tweets created by one of several users.
usernames = ['charlie', 'huey', 'mickey']
users = User.select().where(User.username.in_(usernames))
tweets = Tweet.select().where(Tweet.user.in_(users))

# We could accomplish the same using a JOIN:
tweets = (Tweet
          .select()
          .join(User)
          .where(User.username.in_(usernames)))

# How many tweets were published today?
tweets_today = (Tweet
                .select()
                .where(
                    (Tweet.created_date >= datetime.date.today()) &
                    (Tweet.is_published == True))
                .count())

# Paginate the user table and show me page 3 (users 41-60).
User.select().order_by(User.username).paginate(3, 20)

# Order users by the number of tweets they've created:
tweet_ct = fn.Count(Tweet.id)
users = (User
         .select(User, tweet_ct.alias('ct'))
         .join(Tweet, JOIN.LEFT_OUTER)
         .group_by(User)
         .order_by(tweet_ct.desc()))

# Do an atomic update (for illustrative purposes only, imagine a simple
# table for tracking a "count" associated with each URL). We don't want to
# naively get the save in two separate steps since this is prone to race
# conditions.
Counter.update(count=Counter.count + 1).where(Counter.url == request.url)




######################################################
# Insert data
#engineering = Department.create(name='Engineering')
#john = Employee.create(name='John Doe', department=engineering)
#task1 = Task.create(name='Task 1', employee=john)
#task2 = Task.create(name='Task 2', employee=john)
######################################################

# Query and display data
#departments = Department.select()
def query_and_display_data():
    departments = Department.select()
    tp = list(departments)
    print("printing tuple list")
    print(f"{tp}")
    for department in departments:
        print("Department:", department.name)
        tp = list(department)
        print("printing tuple list")
        print(f"{tp}")
        for employee in department.employees:
            tp = list(employee)
            print("printing tuple list")
            print(f"{tp}")
            print("  Employee:", employee.name) 
            for task in employee.tasks:
                tp = list(task)
                print("printing tuple list")
                print(f"{tp}")
                print("    Task:", task.name)

# Function to update data
def update_data():
    john = Employee.get(Employee.name == 'John Doe')
    john.name = 'John Smith'
    john.save()

# Function to delete data
def delete_data():
    john = Employee.get(Employee.name == 'John Smith')
    john.delete_instance()

# Execute CRUD operations
if __name__ == '__main__':
    # Create tables defined by the models
    insert_data()
    query_and_display_data()
    # update_data()
    delete_data()
    db.close()
