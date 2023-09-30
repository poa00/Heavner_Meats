# pip install peewee psycopg2

from peewee import PostgresqlDatabase, Model, CharField, ForeignKeyField

# Connect to the PostgreSQL database
db = PostgresqlDatabase('wexlqizj', user='wexlqizj', password='6RrqsNEMPMAwnnNZ1lFRxLgsh0BJp5nA', host='baasu.db.elephantsql.com', port=5432)

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



######################################################
# Insert data
engineering = Department.create(name='Engineering')
john = Employee.create(name='John Doe', department=engineering)
task1 = Task.create(name='Task 1', employee=john)
task2 = Task.create(name='Task 2', employee=john)
######################################################

# Query and display data
departments = Department.select()
for department in departments:
    print("Department:", department.name)
    for employee in department.employees:
        print("  Employee:", employee.name)
        for task in employee.tasks:
            print("    Task:", task.name)

# Close the database connection when done
db.close()
