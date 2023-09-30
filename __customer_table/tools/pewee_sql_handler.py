from peewee import Model, CharField, IntegerField, PostgresqlDatabase, SqliteDatabase, IntegrityError
from customerCSV import CustomersJson
from pathlib import Path
import random
from PEWEE_model import Customer, db, sql_connect

######################################
# from pewee_secret_model import db
######################################
# Connect to the database once at the beginning of your application
db = sql_connect()

@db.atomic()
def create_customer(data):
    """
    Create a new customer record in the database.

    Args:
        data (dict): Dictionary containing customer data.
        generate_new_id (bool): Whether to generate a new customer ID (default: True).

    Returns:
        Customer object if successful, None if unsuccessful.
    """
    data["customerID"] = generate_new_id()
    return Customer.create(**data)
    # except Exception as e:
    #     print(f"encountered an error:\n{e}\n")

def generate_new_id():
    x = 0
    while True:
        new_id = random.randint(10000, 99999)
        if not Customer.select().where(Customer.customerID == new_id).exists():
            return new_id
        else:
            x += 1
            if x > 100:
                return 10001
        

@db.atomic()
def insert_new_customer(data):
    try:
        customer = Customer.create(**data)
        return customer
    except Exception as e:
        print(str(f"\n{e}\nexception caught while creating a new customer ID. trying again.\n"))
        pass


def read_customer(customer_id):
    """
    Read a customer record from the database by customer ID.

    Args:
        customer_id (int): The customer ID to look up.

    Returns:
        Customer object if found, None if not found.
    """
    try:
        with db.atomic():
            storage = Customer.get(Customer.customerID == customer_id)
        return storage
    except Customer.DoesNotExist:
        return None
    
    # Iterate over key-value pairs
    for key, value in customer_instance.__dict__.items():
        if not key.startswith('_'):
            print(f'{key}: {value}')

@db.atomic()
def update_customer(customer_id, data):
    """
    Update a customer record in the database.

    Args:
        customer_id (int): The customer ID to update.
        data (dict): Dictionary containing updated customer data.

    Returns:
        Updated Customer object if successful, None if customer doesn't exist.
    """
    try:
        # Ensure the customer exists
        customer = Customer.select().where(Customer.customerID == customer_id).first()
        if customer:
            # Validate and apply updates
            for key, value in data.items():
                setattr(customer, key, value)
            customer.save()
            return True
        else:
            print(f"customer not found at id {customer_id}")
        return None
    except Exception as e:
        # Handle exceptions, log errors, and possibly perform rollback
        print(f"Error updating customer: {str(e)}")
        return None

def delete_customer(customer_id):
    """
    Delete a customer record from the database.

    Args:
        customer_id (int): The customer ID to delete.

    Returns:
        True if deletion is successful, False if customer doesn't exist.
    """
    with db.atomic():
        customer = read_customer(customer_id)
        if customer:
            customer.delete_instance()
            return True
        return False
    
def convert_all_json_to_sql():
    """
    Convert data from JSON to SQL records in the database.
    """
    obj = CustomersJson(cwd)
    with db.atomic():
        customers = obj.load_customers()
        Customer.insert_many(customers).execute()

@db.atomic()
def grab_customers_for_jinja():
    """
    Retrieve all customer records from the database.

    Returns:
        Query result containing all customer records.
    """
    storage = Customer.select().order_by(Customer.full_name)
    return storage


if __name__ == "__main__":
    # Initialize the database connection
    cwd = Path.cwd()
    # for cleanup
    # Customer.drop_table()
    
    db.create_tables([Customer])
    convert_all_json_to_sql()
    CUSTOMERS = Customer.select()
    
    for customer in CUSTOMERS:
        print(f"{customer.full_name} => ID => {customer.customerID} == {customer.telephone}\n\n")
    # Close the database connection when done
    db.close()
    # Define the customer data as a dictionary
