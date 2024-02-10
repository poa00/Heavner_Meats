from flask import Flask, request, jsonify
from util.api_constants import data
import sys
from util.trace_error_handling import er, verbose_print
from calendar_functions import _read_all_calendar, _delete_calendar, _create_calendar
from customers_functions import _read_all_customers, _read_customers, _update_customers, _delete_customers, _create_customers
from user_functions import _read_all_user, _read_user, _delete_user, _create_user


def api_crud_handler(request, app_name, operation, tier):
    """
    Handles CRUD operations. This function is called by Flask - Crazyflie

    Args:
        request: request object to be handled
        app_name: name of the application that is running the operation
        operation: name of the operation that is running the application
        tier: the authorization tier (default: 2)

    Returns:
        jsonified response with a status code and message
    """
    if app_name and operation:
        function_name = f"_{operation}_{app_name}"
        route_function = getattr(sys.modules[__name__], function_name)

        if route_function is not None and callable(route_function):
            verbose_print(f'route_function is not None and callable({route_function})\n')
            return route_function(request)
        else:
            return jsonify({'message': f'Function not found for app_name: {app_name} and operation: {operation}'}), 400
    else:
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
