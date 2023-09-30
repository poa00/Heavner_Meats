from flask import jsonify
from pewee_sql_handler import *
from util.trace_error_handling import er, verbose_print
from util._extend_backend import process_pewee_update
import sys


def customer_post_route(operation, request):
    match_found = False
    for function_name_string in customer_functions():
        if operation in function_name_string:
            print(f"function found: {function_name_string}")
            match_found = True
            try:
                route_function = getattr(sys.modules[__name__], f'_{operation}_customers')
                return route_function(request)
            
            except Exception as e:
                verbose_print(e, route_function)
                er(e)
                return jsonify({'message': f'error running application function, please see log'}), 500
    
    if not match_found:
        print("error, please place app name and operation in list_of_functions() or correct request method.")
        sleep(2)
        app_operation_mapping = customer_functions()
        return jsonify({'message': f'{app_operation_mapping} could not find customers and {operation} in the above itemized list'}), 500


def customer_functions():
    return [ "_read_customers",  "_read_all_customers", "_update_customers", "_delete_customers", "_create_customers" ]


def _read_customers(request):
    """
     Read a customer from the database. This is a helper method for viewing customer data.
     
     Args:
     	 request: The request to the API. It should contain the customer's id.
     
     Returns: 
     	 The JSON response with the created customer object. Example request **. : http Example response **. :
    """
    jdata = request.json
    customer = read_customer(jdata["customerID"], dict=True)
    if customer:
        return jsonify(customer), 201
    return jsonify({'message': 'error reading customer'}), 400


def _read_all_customers(request):
    """
     Read all customers from the database. This is a helper method for viewing customer data.
     
     Args:
     	 request: The request to the API. It should contain the customer's id.
     
     Returns: 
     	 The JSON response with the created customer's id
    """
    customer = read_all_customers()
    if customer:
        return jsonify(customer), 201
    return jsonify({'message': 'error reading customer'}), 400
    

def _delete_customers(request):
    """
     Delete customer from database. This is called by ajax to delete a customer.
     
     Args:
     	 request: request that contains customerID and customerID as json
     
     Returns: 
     	 200 if customer deleted 200 if customer not deleted and error
    """
    del_entry = request.json
    ret_stat = delete_customer(del_entry["customerID"])
    verbose_print(request, del_entry["customerID"])
    return jsonify({'message': f'customer data deleted: {ret_stat}'}), 201


def _update_customers(request):
    """
     Update customer data in the database. This is a helper method to allow a client to update a customer's s data in the database.
     
     Args:
     	 request: a request that contains the customer data to be updated
     
     Returns: 
     	 a JSON response with a status code and a message
    """
    customerJdata = request.json
    status = process_pewee_update(customerJdata)
    # JSON response for new_entry. json
    if not status:
        return jsonify({'message': 'Invalid return/response'}), 400
    return jsonify({'message': 'customer data updated successfully'}), 201


def _create_customers(request):
    """
     Create a customer in the database. This is a helper method for customer creation. You should use this instead of create_customer if you want to create a customer in your application.
     
     Args:
     	 request: The request that contains the customer data. It must be a JSON object with at least the following fields : id description
     
     Returns: 
     	 A JSON object with the message and success status of the JSON
    """
    if create_customer(request.json):
        return jsonify({'message': 'new customer data created successfully'}), 201
    else:
        return jsonify({'message': 'Invalid return/response. No customer created.'}), 400
