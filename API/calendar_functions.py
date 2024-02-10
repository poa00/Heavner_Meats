import sys
from util.trace_error_handling import er, verbose_print
from flask import Flask, request, jsonify
from customer_funcs import *
from peewee import *
from util.PEWEE_model import *

def calendar_post_route(operation, request, tier=2):
    """
     Route to calendar function based on operation. This is used to route requests that are sent to the calendar server to create or update calendars
     
     function: read_all_calendar(): app == calendar, operation == read_all
     
     Args:
     	 operation: operation that should be performed
     	 request: request object that contains request parameters and other data
     
     Returns: 
     	 json response with status code and message of the route
    """
    match_found = False
    for function_name in calendar_functions(tier):
        if operation.strip() == function_name:
            verbose_print("calendar function found")
            match_found = True
            try:
                route_function = getattr(sys.modules[__name__], f'_{operation}_calendar')
                return route_function(request)
            
            except Exception as e:
                verbose_print(e, route_function)
                er(e)
                return jsonify({'message': f'error running application function, please see log'}), 500
            
    if not match_found:
        return jsonify({'message': f'error, no function found, please add the right function to the list of funcs. \notherwise you do not have authorization to access this function{operation}, \n{request.text}'}), 500
        
def calendar_functions(tier):
    """
     List of calendar functions. This is a list of function names that are used to create / update / delete calendars.
     
     Returns: 
     	 a list of calendar functions to be called by the
    """
    function_dictionary = {}
    function_dictionary['1'] = [ "read",  "read_all", "update", "delete", "create"]
    function_dictionary['2'] = ["read"]
    return function_dictionary[str(tier).strip()]
    # return [ "read",  "read_all", "update", "delete", "create" ]


def _create_calendar(request):
    """
     Create calendar for customer. This will be used by create_event and create_event_with_customers
     
     Args:
     	 request: request to create calendar for
     
     Returns: 
     	 json with message and
    """
    jdata = request.json
    customer = read_customer(jdata["customerID"], dict=False)
    jdata["customer"] = customer
    if customer:
        ret_stat = Events.create(**jdata)
        ret_boolean = "True" if ret_stat == 1 else "False"
        return jsonify({'message': f'event data created: {ret_boolean}'}), 201 
    return jsonify({'message': f'Invalid return/response: {ret_boolean}'}), 400


def _read_all_calendar(request):
    """
     Read all customers from the database. This is a helper method for viewing customer data.
     
     Args:
     	 request: The request to the API. It should contain the customer's id.
     
     Returns: 
     	 The JSON response with the created customer's id
    """
    events = Events.select().order_by(Events.week)
    if events:
        storage = [events.__dict__["__data__"] for events in events]
        return jsonify(storage), 201
    return jsonify({'message': 'error reading customer'}), 400
    
    
@db.atomic()
def _delete_calendar(request):
    """ 
    Delete a customer record from the database.

    Args:
        customer_id (int): The customer ID to delete.

    Returns:
        True if deletion is successful, False if customer doesn't exist.
    """
    
    with db.atomic():
        jdata = request.json
        customer = read_customer(jdata["customerID"], dict=False)
        jdata["customer"] = customer
        if customer:
            for event in customer.events:
                ret_stat = event.delete_instance()
                return jsonify({'message': f'customer data deleted: {ret_stat}'}), 201 
        return jsonify({'message': 'error reading customer'}), 400

