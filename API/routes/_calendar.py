import sys
from util.trace_error_handling import er, verbose_print
from flask import Flask, request, jsonify, Blueprint
from customer_funcs import *
from peewee import *
from util.PEWEE_model import *
from util.auth import requires_auth
from datetime import datetime
from playhouse.shortcuts import model_to_dict

calendar_routes = Blueprint('calendar_routes', __name__)

@calendar_routes.route('/events/', methods=['POST'])
def create_event():
    """
     Create a new calendar event. This is a REST endpoint for creating calendar events. The data should be a JSON object with the following fields : message : A JSON response with a message indicating whether the event was created or not.
     
     Returns: 
     	 A JSON response with a message indicating whether the event was created or not and an HTTP status code. Example request **. : http Example response **
    """
    data = request.json
    customer_id = data.get('customerID')
    if customer_id is None:
        return jsonify({'message': 'Customer ID is required in the event data'}), 400

    try:
        event_data = {key: data[key]
                      for key in data.keys() if key in Events._meta.fields and key != 'customer_id'}

        # Retrieve the customer using customer_id
        customer = read_customer(customer_id)
    
        # Update event_data with the customer instance
        event_data['customer'] = customer
        
        event = Events.create(**event_data)
        return jsonify({'message': f'Calendar event created: {event.id}'}), 201
    except Exception as e:
        verbose_print(e)
        er(e)
        return jsonify({'message': 'Error creating calendar event'}), 500


@calendar_routes.route('/events/<event_id>', methods=['GET'])
def read_single_event(event_id):
    """
    Read a single calendar event by event ID.

    Args:
        event_id: The ID of the event to read.

    Returns:
        A JSON response with the calendar event information and an HTTP status code.
    """
    try:
        if str(event_id).isnumeric():
            event_id = int(event_id)
        event = Events.get(Events.id == event_id)
        event_data = event.__dict__["__data__"]
        return jsonify(event_data), 200
    except Events.DoesNotExist:
        return jsonify({'message': 'Calendar event not found'}), 404


@calendar_routes.route('/events/<int:event_id>/cutsheets', methods=['GET'])
def get_event_cutsheets(event_id):
    """
    Retrieve the cutsheets associated with a specific event.

    Parameters:
    - event_id (int): The ID of the event.

    Returns:
    - JSON response: A JSON response containing the cutsheets data.

    Raises:
    - Events.DoesNotExist: If the event with the specified ID does not exist.
    """
    try:
        event = Events.get(Events.id == event_id)
        # Limit the number of cutsheets to a maximum of 20
        cutsheets = event.cutsheets.limit(20)
        cutsheets_data = [
            {'id': cutsheet.id, 'cutsheet': cutsheet.cutsheet} for cutsheet in cutsheets
        ]
        return jsonify(cutsheets_data)
    except Events.DoesNotExist:
        return jsonify({'error': 'Event not found'}), 404


# Route to read all calendar events
@calendar_routes.route('/events/', methods=['GET'])
def read_all_events():
    """
     Read all calendar events. This is a REST endpoint for reading all calendar events. It returns a JSON response with a list of all calendar events their information and an HTTP status code.
     
     Returns: 
     	 A JSON response with a list of all calendar events their information and an HTTP status code. Example request **. : http Example response **
    """
    events = Events.select().order_by(Events.yweek)
    if events:
        storage = [events.__dict__["__data__"] for events in events]
        return jsonify(storage), 201
    return jsonify({'message': 'error reading customer'}), 400


@calendar_routes.route('/events/<int:customer_id>/future-events', methods=['GET'])
def get_customer_future_events(customer_id):
    try:
        # Get the current yearweek
        current_yearweek = datetime.now().isocalendar(
        )[0] * 100 + datetime.now().isocalendar()[1]

        # Query for the specific customer
        customer = Customer.get_by_id(customer_id)

        # Query for future events related to this customer
        future_events_query = Events.select().where(
            (Events.customer == customer) &
            (Events.yweek >= current_yearweek)
        )

        # Prepare the list of future events for JSON response
        future_events = [model_to_dict(event)
                         for event in future_events_query]

        return jsonify(future_events)
    except Customer.DoesNotExist:
        # If the customer does not exist, return a 404 error
        return jsonify({'message': 'Calendar event not found'}), 404
    except Exception as e:
        # If there is any other error, return a 500 error
        return jsonify({'message': 'Unknown error, check code on both ends.'}), 500

# Route to update a calendar event by event ID
@calendar_routes.route('/events/<event_id>', methods=['PUT'])
def update_event(event_id):
    """
     Update an existing calendar event. This will update the properties of an existing calendar event with the data provided in the request body.
     
     Args:
     	 event_id: The ID of the event to update.
     
     Returns: 
     	 A JSON response with a message indicating whether the event was updated or not and an HTTP status code. Example request **. : http Example response **. :
    """
    data = request.json
    try:
        if str(event_id).isnumeric():
            event_id = int(event_id)
        event = Events.get(Events.id == event_id)
        for key, value in data.items():
            setattr(event, key, value)
        event.save()
        return jsonify({'message': f'Calendar event updated: {event.id}'}), 200
    except Events.DoesNotExist:
        return jsonify({'message': 'Calendar event not found'}), 404


@calendar_routes.route('/events/<event_id>', methods=['DELETE'])
def delete_event(event_id):
    """
     Delete a calendar event by event ID. This endpoint is used by clients to delete calendar events that are associated with a user's calendar.
     
     Args:
     	 event_id: The ID of the event to delete.
     
     Returns: 
     	 A JSON response with a message indicating whether the event was deleted or not and an HTTP status code. Example request **. : http Example response **. :
    """

    try:
        if str(event_id).isnumeric():
            event_id = int(event_id)
        event = Events.get(Events.id == event_id)
        event.delete_instance()
        return jsonify({'message': f'Calendar event deleted: {event_id}'}), 200
    except Events.DoesNotExist:
        return jsonify({'message': 'Calendar event not found'}), 404


if __name__ == '__main__':
    calendar_routes.run(debug=True)
