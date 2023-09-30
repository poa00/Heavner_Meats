from flask import Flask, request, jsonify
from util.api_constants import data
import sys
from util.trace_error_handling import er, verbose_print
from pewee_sql_handler import *
import traceback
from time import sleep

def handle_crud_event(request, app_name, operation):
    """
        Handles CRUD operations. This function is called by Flask - Crazyflie
    
    Args:
        request: request object to be handled
        app_name: name of the application that is running the operation
        operation: name of the operation that is running the application
    
    Returns: 
        jsonified response with status code and message of the
    """
    match_found = False
    if app_name and operation:
        for function_name_string in list_of_functions():
            if app_name in function_name_string and operation in function_name_string:
                print("match found")
                match_found = True
                try:
                    route_function = getattr(sys.modules[__name__], f'_{operation}_{app_name}')
                    return route_function(request)
                except Exception as e:
                    verbose_print(e, route_function)
                    er(e)
                    app_operation_mapping = list_of_functions()
                    return jsonify({'message': f'error running application function, please see log'}), 500
        if not match_found:
            print("error, please place app name and operation in list_of_functions() or correct request method.")
            sleep(2)
            return jsonify({'message': f'{app_operation_mapping}could not find {app_name} and {operation} in the above itemized list'}), 500
    else:
        print("failed to match")
        return jsonify({'message': f'Invalid parameters, app_name: {app_name} | operation: {operation} | one of these was empty'}), 400


def list_of_functions():
    return [ "_read_customers",  "_read_all_customers", "_update_customers", "_delete_customers", "_create_customers" ]


def _read_customers(request):
    """
     Read a customer from the database. This is a helper method for viewing customer data.
     
     Args:
     	 request: The request to the API. It should contain the customer's id.
     
     Returns: 
     	 The JSON response with the created customer object. Example request **. : http Example response **. :
    """
    customer_dic = jsonify(read_customer(request.json["customerID"]))
    if customer_dic:
        return customer_dic, 201
    else:
        jsonify({'message': 'Invalid return/response for _read_customers()'}), 400


def _read_all_customers(request):
    """
     Read all customers from the database. This is a helper method for viewing customer data.
     
     Args:
     	 request: The request to the API. It should contain the customer's id.
     
     Returns: 
     	 The JSON response with the created customer's id
    """
    customers_dic = jsonify(read_all_customers())
    if customers_dic:
        return customers_dic, 201
    else:
        return jsonify({'message': 'Invalid return/response _read_all_customers()'}), 400

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
    return jsonify({'message': f'customer data deleted: {ret_stat}'}), 200


def _update_customers(request):
    """
     Update customer data in the database. This is a helper method to allow a client to update a customer's s data in the database.
     
     Args:
     	 request: a request that contains the customer data to be updated
     
     Returns: 
     	 a JSON response with a status code and a message
    """
    customerJdata = request.json
    status = update_customer(customerJdata["customerID"], customerJdata)
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
    # JSON response for new_entry. json
    if create_customer(request.json):
        return jsonify({'message': 'new customer data created successfully'}), 201
    else:
        return jsonify({'message': 'Invalid return/response. No customer created.'}), 400


def route_get_request(request):
    """
     Route to get data from data. json file. This is called when GET request is received.
     
     Args:
     	 request: request that will be handled. It's a dict
     
     Returns: 
     	 json response with data or
    """
    try:
        return jsonify(data)
    except Exception as e:
        print(f'Exception occurred in get_data(): {e}')
        er(e)
        return jsonify({'message': 'An error occurred'}), 500
    
    
if __name__ == '__main__':
    app = Flask(__name__)
    app.run(debug=True)
