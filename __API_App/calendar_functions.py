import sys
from util.trace_error_handling import er, verbose_print
from flask import Flask, request, jsonify
from pewee_sql_handler import *
from util.PEWEE_model import *

def calendar_post_route(operation, request):
    """
     Route to calendar function based on operation. This is used to route requests that are sent to the calendar server to create or update calendars
     
     Args:
     	 operation: operation that should be performed
     	 request: request object that contains request parameters and other data
     
     Returns: 
     	 json response with status code and message of the route
    """
    for op in calendar_functions():
        if operation == op:
            verbose_print("calendar function found")
            match_found = True
            try:
                route_function = getattr(sys.modules[__name__], f'_{operation}_calendar')
                return route_function(request)
            
            except Exception as e:
                verbose_print(e, route_function)
                er(e)
                return jsonify({'message': f'error running application function, please see log'}), 500
            
        
def calendar_functions():
    """
     List of calendar functions. This is a list of function names that are used to create / update / delete calendars.
     
     
     Returns: 
     	 a list of calendar functions to be called by the
    """
    return [ "read",  "read_all", "update", "delete", "create" ]

def _create_calendar():
    jdata = request.json
    customer = read_customer(jdata["customerID"], dict=True)
    if customer:
        Events.create(**jdata, customer=customer)


def test_add_event():
    """
     Add event to a customer GET : customerID = " xxx " POST :
    """
    jdata = request.json
    customer = read_customer(jdata["customerID"], dict=True)
    if customer:
        Events.create(**jdata, customer=customer)
        
        """
        
        return jsonify(customer), 201
    return jsonify({'message': 'error reading customer'}), 400"""