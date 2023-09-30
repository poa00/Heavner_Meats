import sqlite3
import json
from peewee import PostgresqlDatabase, Model, CharField, IntegerField

# def convert_postgres():
#     # Define your Peewee model
#     db = PostgresqlDatabase('your_database_name', user='your_username', password='your_password', host='your_host')

#     class YourModel(Model):
#         # Define your model fields
#         name = CharField()
#         age = IntegerField()

#         class Meta:
#             database = db


def convert_peewee_to_json(db, MyModel):
    try:
        db.connect()  # Connect to the PostgreSQL database
        data = list(MyModel.select().dicts())  # Query the data and convert to list of dictionaries
        json_filename = 'exported_data.json'  # Specify the name of the JSON file

        with open(json_filename, 'w') as json_file:
            json.dump(data, json_file, indent=4)

        print(f'Data from table "{MyModel._meta.db_table}" exported to "{json_filename}"')
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()  # Close the database connection



def convert_sqlite(database):
    """
    Convert database from sqlite to json

    Args:
        database (str): database to convert to json

    Returns:
        n/a
    """
    # Connect to the SQLite database
    db_connection = sqlite3.connect(database)  # Replace 'your_database.db' with your database file
    # Create a cursor object to interact with the database
    cursor = db_connection.cursor()
    # Define the table you want to export
    table_name = 'customer'  # Replace with the name of your table
    # Fetch all records from the table
    cursor.execute(f'SELECT * FROM {table_name}')
    records = cursor.fetchall()
    # Get the column names from the table
    column_names = [description[0] for description in cursor.description]
    # Create a list of dictionaries for each row
    data = []
    for record in records:
        data.append(dict(zip(column_names, record)))
    # Close the cursor and database connection
    cursor.close()
    db_connection.close()
    # Export the data to a JSON file
    json_filename = 'exported_data.json'  # Specify the name of the JSON file
    with open(json_filename, 'w') as json_file:
        json.dump(data, json_file, indent=4)

    print(f'Data from table "{table_name}" exported to "{json_filename}"')

if __name__ == "__main__":
    convert_sqlite('mydatabase.db')