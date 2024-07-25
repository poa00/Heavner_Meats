import sys
from util.trace_error_handling import er, verbose_print
from flask import Flask, request, jsonify, Blueprint
from customer_funcs import *
from peewee import *
from util.PEWEE_model import *
from util.auth import requires_auth
from datetime import datetime, timedelta
from playhouse.shortcuts import model_to_dict
from routes.shareable_functions import print_error

calendar_routes = Blueprint('calendar_routes', __name__)


@calendar_routes.route('/events/', methods=['POST'])
def create_event():
    """
    Create a new calendar event. This is a REST endpoint for creating calendar events. The data should 
    be a JSON object with the following fields : message : A JSON response with a message indicating 
    whether the event was created or not.
    
    Returns: 
        A JSON response with a message indicating whether the event was created or not and an HTTP 
        status code. Example request **. : http Example response **
    """
    data = request.json
    customer_id = data.get('customerID')
    if customer_id is None:
        return jsonify({'message': 'Customer ID is required in the event data'}), 400

    with db.atomic():  # Start an atomic transaction
        try:
            event_data = {key: data[key]
                          for key in data.keys() if key in Events._meta.fields and key != 'customer_id'}

            # Retrieve the customer using customer_id
            customer = read_customer(customer_id)

            if customer is None:
                return jsonify({'message': 'Customer not found'}), 404

            # Update event_data with the customer instance
            event_data['customer'] = customer

            event = Events.create(**event_data)
            return jsonify({'message': f'Calendar event created: {event.id}'}), 201
        except IntegrityError as e:
            verbose_print(e)
            er(e)
            return print_error(e)
        except Exception as e:
            verbose_print(e)
            er(e)
            return print_error(e)


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
        return print_error(e)


@calendar_routes.route('/events/by-week/<int:yweek>', methods=['GET'])
def get_events_by_yearweek(yweek):
    try:
        # Query for events in the given yearweek that includes related customer data using an explicit join
        events_query = (
            Events
            .select(
                Events,  # Select all fields from Events.
                # Alias the customer id for convenience in JSON response.
                Customer.id,
                Customer.full_name,
                Customer.billing_city
            )
            # The join is now more specific, using the foreign key relation.
            .join(Customer)
            .where(Events.yweek == yweek)
        )


        events_data = [model_to_dict(event)
                          for event in events_query]
        return jsonify(events_data)
    except Exception as e:
        # If there is an error, return a 500 error with the exception message
        return print_error(e)

@calendar_routes.route('/events/<event_id>', methods=['PUT'])
def update_event(event_id):
    """
    Update an existing calendar event. This will update the properties of an existing calendar event with the data provided in the request body.
    
    Args:
        event_id: The ID of the event to update.
    
    Returns: 
        A JSON response with a message indicating whether the event was updated or not and an HTTP status code.
    """
    data = request.json
    with db.atomic():  # Start an atomic transaction
        try:
            if str(event_id).isnumeric():
                event_id = int(event_id)
            # Use get_by_id for a cleaner approach
            event = Events.get_by_id(event_id)
            for key, value in data.items():
                if key in event._meta.fields:  # Only update if key is a valid field
                    setattr(event, key, value)
            event.save()  # The changes are saved within the transaction
            return jsonify({'message': f'Calendar event updated: {event.id}'}), 200
        except Events.DoesNotExist:
            return jsonify({'message': 'Calendar event not found'}), 404
        except IntegrityError as e:
            # This block will catch any database errors such as constraint violations
            return print_error(e)
        except Exception as e:
            # Catch other unexpected exceptions
            return print_error(e)

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


@calendar_routes.route('/events/with-animals', methods=['GET'])
def get_events_with_animals():
    """
    Fetches last week's and all future events with associated animals.
    
    It calculates the current week number and filters events from the last week onwards.
    Each event includes the customer's full name, the number of animals associated with the event,
    and the event's 'yweek'.
    
    Returns:
        A JSON object where each key is an event ID and its value contains the customer's full name,
        the number of animals associated with the event, and the event 'yweek'.
    """
  
    try:
        # Calculate current yweek and last week's yweek
        current_date = datetime.now()
        current_year, current_week, _ = current_date.isocalendar()
        current_yweek = int(f"{current_year}{current_week:02}")

        # Subtract one week to get last week's yweek
        last_week_date = current_date - timedelta(weeks=1)
        last_year, last_week, _ = last_week_date.isocalendar()
        last_yweek = int(f"{last_year}{last_week:02}")

        # Query filtering events from last week onwards
        query = (Events
                 .select(Events.id, Customer.full_name, fn.COUNT(Animals.id).alias('number_of_animals'), Events.yweek)
                 .join(Animals)
                 .switch(Events)
                 .join(Customer)
                 .where(Events.yweek >= last_yweek)
                 .group_by(Events.id, Customer.full_name, Events.yweek)
                 .dicts())

        events_summary = {}
        for event in query:
            event_id = event['id']
            events_summary[event_id] = {
                'event_id': event['id'],  # Add event ID to the details
                'customer_full_name': event['full_name'],
                'number_of_animals_associated_with_event': event['number_of_animals'],
                'event_yweek': event['yweek']
            }
        # Change here for consumer's convenience
        return jsonify(list(events_summary.values())), 200
    except Exception as e:
        print(e)  # For debugging, consider logging this instead of printing
        return print_error(e)

@calendar_routes.route('/events/animals/<int:event_id>', methods=['GET'])
def get_event_details(event_id):
    try:
        # Fetch all animals associated with the event
        animals_query = (Animals.select().where(Animals.event_id == event_id))

        animals_data = []
        for animal in animals_query:
            try:
                animal_dict = model_to_dict(animal)
                animals_data.append(animal_dict)
            except DoesNotExist:
                # Handle missing related records (e.g., missing Cutsheet)
                pass  # or log error, or append error info to animals_data

        # Fetch all cutsheets associated with the event
        cutsheets_query = Cutsheet.select().where(Cutsheet.event_id == event_id)

        cutsheets_data = []
        for cutsheet in cutsheets_query:
            try:
                cutsheet_dict = model_to_dict(cutsheet)
                cutsheets_data.append(cutsheet_dict)
            except DoesNotExist:
                # Handle missing related records similarly
                pass  # or log error, or append error info to cutsheets_data

        response_data = {
            'animals': animals_data,
            'cutsheets': cutsheets_data
        }

        return jsonify(response_data), 200
    except Exception as e:
        # Generic exception handling (optional, consider more specific handling)
        return jsonify({'error': str(e)}), 500


def generate_error_response(e):
    import traceback
    # Last 3 lines of traceback
    error_info = traceback.format_exc().splitlines()[-3:]
    response = jsonify({
        'message': 'An error occurred.',
        'error': str(e),
        'traceback': error_info
    })
    return response, 500


if __name__ == '__main__':
    calendar_routes.run(debug=True)
