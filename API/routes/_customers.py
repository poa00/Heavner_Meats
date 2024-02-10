from tabnanny import verbose
from flask import Blueprint, request, jsonify
from customer_funcs import *
from util.trace_error_handling import er, verbose_print
from util._extend_backend import process_pewee_update
from time import sleep
from datetime import datetime, timedelta
from util.PEWEE_model import Customer, Events
from playhouse.shortcuts import model_to_dict

customer_routes = Blueprint('customer_routes', __name__)


@customer_routes.route('/customers/', methods=['POST'])
def create_customer_route():
    """
     Create a customer in the database. This is a route for POST / create_customer. The request must be a JSON object with a message indicating whether the customer was created or not and an HTTP status code.
     
     
     Returns: 
     	 Response as a JSON tuple containing a JSON response with a message indicating whether the customer was created or not
    """
    data = request.json
    if create_customer(data):
        return api_reply_util('New customer data created successfully', 201, [str(request.json)])
    else:
        return api_reply_util('Invalid return/response. No customer created.', 400, [str(request.json)])


@customer_routes.route('/customers/<customerID>', methods=['GET'])
def read_customer_route(customerID):
    """
     Read a customer by customerID. This is a route to the read_customer function. It will return a JSON response with the customer's information and an HTTP status code.
     
     Args:
     	 customerID: The ID of the customer to read.
     
     Returns: 
     	 A JSON response with the customer's information and an HTTP status code. Example request **. : http Example response **. : http HTTP / 1. 1 200 OK Content - Type : application / json { " customer " : { " id " : " my - customer - id "
    """
    if str(customerID).isnumeric():
        customerID = int(customerID)
    customer = read_customer(customerID, dict=True)
    if customer:
        verbose_print("Customer found")
        return jsonify(customer), 200
    return api_reply_util('Error reading customer', 400, customerID)


@customer_routes.route('/customers/', methods=['GET'])
def read_all_customers_route():
    """
     Read all customers from the database. This is the route for the /customers/ endpoint.
     
     Returns: 
         A tuple containing a JSON response with a dictionary of customers where the customer id is the key,
         and an HTTP status code. If there is an error the response will be formatted as an error.
    """
    try:
        customers_query = Customer.select()
        customers_dict = {customer.id: model_to_dict(
            customer) for customer in customers_query}
        return jsonify(customers_dict), 200
    except Exception as e:
        # Assuming api_reply_util is a function to format error messages
        return api_reply_util('Error reading customer: {}'.format(e), 400)
    
    
@customer_routes.route('/customer/<int:customer_id>/cutsheets', methods=['GET'])
def get_customer_cutsheets_as_producer(customer_id):
    try:
        customer = Customer.get(Customer.id == customer_id)
        cutsheets = customer.cutsheets_as_producer
        cutsheets_data = [
            {'id': cutsheet.id, 'cutsheet': cutsheet.cutsheet} for cutsheet in cutsheets]
        return jsonify(cutsheets_data)
    except Customer.DoesNotExist:
        return jsonify({'error': 'Customer not found'}), 404


# @customer_routes.route('/customers/', methods=['GET'])
# def search_customers_route():
#     """
#     Search and retrieve customers based on query parameters passed as key-value pairs.

#     Query Parameters:
#     Can include any keys that are fields in the customer model to use as filters.

#     Returns:
#         A JSON response containing the filtered customers data if successful, or an error message if unsuccessful.
#     """
#     try:
#         query = Customer.select()  # Start with selecting all customers

#         for key, value in request.args.items():  # Iterate over query parameters from the URL
#             if hasattr(Customer, key):
#                 if str(value).isnumeric():
#                     value = int(value)
#                 query = query.where(getattr(Customer, key) == value)
#             else:
#                 return api_reply_util(f'Invalid query parameter: {key}', 400, [key])

#         customers = query.execute()  # Execute the query with the applied filters
#         # make sure to replace `.to_dict()` with actual method to convert models to dictionaries
#         customers_data = [customer.to_dict() for customer in customers]
#         return jsonify(customers_data), 200
#     except IntegrityError as e:
#         # Handle any database errors such as invalid field name
#         return api_reply_util(f'Error in search parameters: {str(e)}', 400, [])
#     except Exception as e:
#         return api_reply_util(f'Error searching customers: {str(e)}', 500, [])

@customer_routes.route('/customers/name_and_farm/', methods=['GET'])
def read_customers_fullname_farm_id_route():
    """
    Read all customers from the database and return only their full name, farm, and ID.
    
    Returns:
        A JSON response with a list of customers' full name, farm, and ID, and an HTTP status code.
    """
    try:
        query = Customer.select(
            Customer.full_name, Customer.company_name.alias('farm'), Customer.id)
        customers_list = [{'full_name': customer.full_name,
                           'company_name': customer.farm, 'id': customer.id} for customer in query]
        return jsonify(customers_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400
    

@customer_routes.route('/customers/<customerID>', methods=['PUT'])
def update_customer_route(customerID):
    """
     Update a customer in the database. This is a REST call to update an existing Peephole customer's data
     
     Args:
     	 customerID: The ID of the customer to update
     
     Returns: 
     	 200 if successful 400 if not ( in order to avoid confusion with other services ) or 500 if an error
    """

    data = request.json
    status = process_pewee_update(data)
    if not status:
        return api_reply_util('Invalid return/response', 400, [str(request.json)])
    return api_reply_util('Customer data updated successfully', 200)


@customer_routes.route('/customers/<customerID>', methods=['DELETE'])
def delete_customer_route(customerID):
    """
     Delete a customer from the database. This is a wrapper around the delete_customer function that takes care of the common case of deleting a customer from the database as well as deleting the customer from the database.
     
     Args:
     	 customerID: The ID of the customer to delete.
     
     Returns: 
     	 A tuple containing a JSON response with a message indicating whether the customer was deleted or not and an HTTP status code
    """
    if str(customerID).isnumeric():
        customerID = int(customerID)
    ret_stat = delete_customer(customerID)
    return api_reply_util(f'Customer data deleted: {ret_stat}', 200)


@customer_routes.route('/customers/<customerID>/events', methods=['GET'])
def get_customer_events_route(customerID):
    """
    Get events associated with a customer.

    Args:
        customerID: The ID of the customer.

    Returns:
        A JSON response with events associated with the customer and an HTTP status code.
    """
    try:
        if str(customerID).isnumeric():
            customerID = int(customerID)
        # Retrieve the customer using customerID
        customer = read_customer(customerID, dict=False)

        # Retrieve events associated with the customer
        events = Events.select().where(Events.customer == customer)

        # Convert events to a list of dictionaries
        event_list = [
            {
                "week": event.week,
                "cows": event.cows,
                "pigs": event.pigs,
                "lambs": event.lambs,
            }
            for event in events
        ]

        return jsonify(event_list), 200

    except Customer.DoesNotExist:
        return api_reply_util('Customer not found', 404, customerID)
    except Exception as e:
        return api_reply_util(f'Error retrieving events: {str(e)}', 500, customerID)


@customer_routes.route('/customers/future-events', methods=['GET'])
def get_customers_with_future_events():
    try:
        current_yearweek = datetime.now().isocalendar(
        )[0] * 100 + datetime.now().isocalendar()[1]

        future_events = Events.select().join(
            Customer).where(Events.yweek >= current_yearweek)

        customers_with_future_events = {event.customer.id: model_to_dict(
            event.customer) for event in future_events.distinct()}

        return jsonify(customers_with_future_events), 200

    except Exception as e:
        return api_reply_util('get_customers_with_future_events failure', 404, e)
    

@customer_routes.route('/customers/weight-station', methods=['GET'])
def get_customers_with_near_term_events():
    try:
        # Get the current date
        current_date = datetime.now()

        # Calculate dates for beginning of this week, last week, and next week
        start_of_this_week = current_date - timedelta(days=current_date.weekday())
        start_of_last_week = start_of_this_week - timedelta(weeks=1)
        start_of_next_week = start_of_this_week + timedelta(weeks=1)

        # Convert dates to yearweek format
        last_week_yearweek = start_of_last_week.isocalendar(
        )[0] * 100 + start_of_last_week.isocalendar()[1]
        this_week_yearweek = start_of_this_week.isocalendar(
        )[0] * 100 + start_of_this_week.isocalendar()[1]
        next_week_yearweek = start_of_next_week.isocalendar(
        )[0] * 100 + start_of_next_week.isocalendar()[1]

        # Query for events with a yearweek for last, this, or next week
        near_term_events = (Events.select()
                            .join(Customer)
                            .where(Events.yweek.between(last_week_yearweek, next_week_yearweek)))

        # Extract customers from those events
        customers = [model_to_dict(
            event.customer) for event in near_term_events]

        return jsonify(customers)
    except Exception as e:
        return api_reply_util('get_customers_with_future_events failure', 404, e)
    
    
def api_reply_util(msg, status_code, *args):
    """
     Function to reply to api calls that return JSON. This function is used for testing and debugging. The return value is a JSON object with message and status code
     
     Args:
     	 msg: Message to be printed to console
     	 status_code: Status code of the request. It should be 399 if there is no error
     
     Returns: 
     	 JSON object with message
    """
    message = str(args)
    verbose_print(f"{msg}\n{message}\nCode: {status_code}")
    if status_code > 399:
        return jsonify({'message': f'Invalid return/response\n{message}'}), status_code
    else:
        return jsonify({'message': f'Function successful\n{message}'}), status_code
    """        return jsonify({'message': 'Invalid return/response'}), 400
    return jsonify({'message': 'Customer data updated successfully'}), 200"""

if __name__ == '__main__':
    customer_routes.run(debug=True)
