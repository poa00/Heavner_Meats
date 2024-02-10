# Install the peewee library if you haven't already
# pip install peewee

from peewee import SqliteDatabase, Model, CharField, ForeignKeyField, ManyToManyField

# Create a SQLite database
db = SqliteDatabase('tutorial_advanced.db')

# Define the models (tables)
class Student(Model):
    name = CharField()

    class Meta:
        database = db

class Course(Model):
    name = CharField()
    teacher = ForeignKeyField('Teacher', backref='courses')

    class Meta:
        database = db

class Enrollment(Model):
    student = ForeignKeyField(Student, backref='enrollments')
    course = ForeignKeyField(Course, backref='enrollments')

    class Meta:
        database = db

class Teacher(Model):
    name = CharField()

    class Meta:
        database = db

# Many-to-Many relationship between Student and Course through Enrollment
Student.add_to_class('courses', ManyToManyField(Course, through=Enrollment))
Course.add_to_class('students', ManyToManyField(Student, through=Enrollment))

# Connect to the database
db.connect()

# Create tables
db.create_tables([Student, Course, Enrollment, Teacher])

# Insert data into tables
# Students
alice = Student.create(name='Alice')
bob = Student.create(name='Bob')

# Teachers
professor_smith = Teacher.create(name='Professor Smith')
professor_jones = Teacher.create(name='Professor Jones')

# Courses
math_course = Course.create(name='Mathematics', teacher=professor_smith)
physics_course = Course.create(name='Physics', teacher=professor_jones)

# Enroll students in courses
Enrollment.create(student=alice, course=math_course)
Enrollment.create(student=bob, course=math_course)
Enrollment.create(student=bob, course=physics_course)

# Query data
# Get all students and their enrolled courses
for student in Student.select():
    print(f"{student.name} is enrolled in the following courses:")
    for course in student.courses:
        print(f"  - {course.name} with {course.teacher.name}")

# Get all courses and their enrolled students
for course in Course.select():
    print(f"Course: {course.name}, Taught by: {course.teacher.name}, Enrolled students:")
    for student in course.students:
        print(f"  - {student.name}")

# Perform a JOIN operation to get courses and their teachers
query = (Course
         .select(Course.name, Teacher.name.alias('teacher_name'))
         .join(Teacher)
         .order_by(Course.name))

print("Courses and their Teachers:")
for result in query:
    print(f"{result.name} taught by {result.teacher_name}")

# Disconnect from the database
db.close()
