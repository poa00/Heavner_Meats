from flask import Flask, request, jsonify
from util.api_constants import data
import sys
from util.trace_error_handling import er, verbose_print
from customer_funcs import *
import traceback
from time import sleep
from util._extend_backend import process_pewee_update
from calendar_functions import calendar_post_route
from customers_functions import * 
from user_functions import user_post_route

def api_crud_handler(request, app_name, operation, tier):
    """
        Handles CRUD operations. This function is called by Flask - Crazyflie
    
    Args:
        request: request object to be handled
        app_name: name of the application that is running the operation
        operation: name of the operation that is running the application
    
    Returns: 
        jsonified response with status code and message of the
    """
    if app_name and operation:
        if app_name == "customers":
            return customer_post_route(operation, request, tier)
            
        elif app_name == "calendar":
            return calendar_post_route(operation, request, tier)
        
        elif app_name == "user":
            return user_post_route(operation, request, tier)
                    
        
    else:
        print("failed to match")
        return jsonify({'message': f'Invalid parameters, app_name: {app_name} | operation: {operation} | one of these was empty'}), 400


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
    app.run(debug=True)
