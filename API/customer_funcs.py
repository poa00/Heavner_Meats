from peewee import *
from customerCSV import CustomersJson
from pathlib import Path
import random
from util.PEWEE_model import *
from time import sleep
import threading
import concurrent.futures

from util.trace_error_handling import verbose_print



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


def read_customer(customer_id, dict=False):
    """
    Read a customer record from the database by customer ID.

    Args:
        customer_id (int): The customer ID to look up.
        dict (False): if true, returns k,v pair for customer attributes instead of SQL object

    Returns:
        Customer object if found, None if not found.
    """
    try:
        with db.atomic():
            if len(str(customer_id)) > 4:
                customer = Customer.get(Customer.customerID == int(customer_id))
            else: 
                customer = Customer.get(Customer.id == int(customer_id))
        if dict:
            return customer.__dict__["__data__"]
        else:
            return customer
    except Customer.DoesNotExist:
        return None
    
    # Iterate over key-value pairs
    # for key, value in customer_instance.__dict__.items():
    #     if not key.startswith('_'):
    #         print(f'{key}: {value}')

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

@db.atomic()
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
    customers = Customer.select().order_by(Customer.full_name).dicts()
    # customers = Customer.select().order_by(Customer.full_name)
    storage = [customer.__dict__["__data__"] for customer in customers]
    return storage


@db.atomic()
def read_all_customers():
    """
    Retrieve all customer records from the database.

    Returns:
        Query result containing all customer records.
    """
    # customers = Customer.select().order_by(Customer.full_name)
    # storage = [customer.__dict__["__data__"] for customer in customers]
    try:
        with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
            futures = [executor.submit(lambda customer: customer.__dict__["__data__"], customer) for customer in Customer.select().order_by(Customer.full_name)]
            storage = [future.result() for future in concurrent.futures.as_completed(futures)]
        
        cleaned_storage = []
        
        cleaned_storage = threaded_process_data(storage)
    
    except Exception as e:
        verbose_print("ERROR function=> read_all_customers", e)

    """original code
    
    for data in storage:
        cleaned_data = {}
        for key, value in data.items():
            if isinstance(value, str):
                cleaned_data[key] = value.replace("'", "").replace('"', '')
            else:
                cleaned_data[key] = value
        cleaned_storage.append(cleaned_data)"""
        
    """comprehension version
        cleaned_data = {key: value.replace("'", "").replace('"', '') if isinstance(value, str) else value for key, value in data.items()}
        """
    return cleaned_storage

def threaded_process_data(data, num_threads=10):
    """
     Process data in multiple threads. This is useful for testing the performance of a data source that is large ( as long as you don't have to worry about memory leaks )
     
     Args:
     	 data: The data to be processed
     	 num_threads: The number of threads to use for processing
     
     Returns: 
     	 A list of cleaned data in the form of a
    """
    cleaned_storage = []
    chunk_size = len(data) // num_threads
    threads = []

    for i in range(num_threads):
        start_idx = i * chunk_size
        end_idx = start_idx + chunk_size if i < num_threads - 1 else len(data)
        chunk = data[start_idx:end_idx]

        thread = threading.Thread(target=lambda: cleaned_storage.extend(map(clean_data, chunk)))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

    return cleaned_storage


def clean_data(data):
    """
     Cleans data to be used in templates. This is a helper function to make it easier to use in templates
     
     Args:
     	 data: The data to be cleaned
     
     Returns: 
     	 A cleaned version of the data that can be used in
    """
    cleaned_data = {}
    for key, value in data.items():
        if isinstance(value, str):
            cleaned_data[key] = value.replace("'", "").replace('"', '')
        else:
            cleaned_data[key] = value
    return cleaned_data


if __name__ == "__main__":
    # Initialize the database connection
    db.create_tables([Customer, Events])
    cwd = Path.cwd()
    db.close()
    
    # for cleanup
    # Customer.drop_table()
    
    # convert_all_json_to_sql()
    CUSTOMERS = Customer.select()
    
    for customer in CUSTOMERS:
        print(f"{customer.full_name} => ID => {customer.customerID} == {customer.telephone}\n\n")
    # Close the database connection when done
    db.close()
    # Define the customer data as a dictionary
