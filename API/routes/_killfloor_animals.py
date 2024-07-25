import sys
from util.trace_error_handling import er, verbose_print
from flask import Flask, request, jsonify, Blueprint
from customer_funcs import *
from peewee import *
from util.PEWEE_model import *
from util.auth import requires_auth

animal_routes = Blueprint('animal_routes', __name__)


@animal_routes.route('/animals/', methods=['POST'])
def create_event():
    """
    Create a new animal event. This is a REST endpoint for creating animal events. 
    The data should be a JSON object with the fields corresponding to the Animals model.
    
    Returns:
        A JSON response with a message indicating whether the event was created or not and an HTTP status code.
    """
    data = request.json
    event_data = {key: data[key]
                  for key in data.keys() if key in Animals._meta.fields}
    with db.atomic():  # Start an atomic transaction
        try:
            event = Animals.create(**event_data)
            return jsonify({'message': f'Animal event created: {event.id}'}), 201
        except IntegrityError as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error creating animal event due to integrity issues'}), 400
        except Exception as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error creating animal event'}), 500


# Route to read all animal animals
@animal_routes.route('/animals/', methods=['GET'])
def read_all_animals():
    """
     Read all animal animals. This is a REST endpoint for reading all animal animals. It returns a JSON response with a list of all animal animals their information and an HTTP status code.
     
     
     Returns: 
     	 A JSON response with a list of all animal animals their information and an HTTP status code. Example request **. : http Example response **
    """
    """
    Read all animal animals.

    Returns:
        tuple: A tuple containing a JSON response with a list of all animal animals and their information, and an HTTP status code.
    """
    animals = Animals.select().order_by(Animals.week)
    if animals:
        storage = [animals.__dict__["__data__"] for animals in animals]
        return jsonify(storage), 201
    return jsonify({'message': 'error reading customer'}), 400


@animal_routes.route('/animals/<event_id>', methods=['PUT'])
def update_event(event_id):
    """
    Update an existing animal event. This will update the properties of an existing animal event with the data provided in the request body.
    
    Args:
        event_id: The ID of the event to update.
    
    Returns: 
        A JSON response with a message indicating whether the event was updated or not and an HTTP status code.
    """
    data = request.json
    with db.atomic():  # Start an atomic transaction
        try:
            event = Animals.get_by_id(event_id)
            for key, value in data.items():
                if key in event._meta.fields:
                    setattr(event, key, value)
            event.save()
            return jsonify({'message': f'Animal event updated: {event.id}'}), 200
        except Animals.DoesNotExist:
            return jsonify({'message': 'Animal event not found'}), 404
        except IntegrityError as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error updating animal event due to integrity issues'}), 400
        except Exception as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error updating animal event'}), 500
        

@animal_routes.route('/animals/<event_id>', methods=['DELETE'])
def delete_event(event_id):
    """
     Delete a animal event by event ID. This endpoint is used by clients to delete animal animals that are associated with a user's animal.
     
     Args:
     	 event_id: The ID of the event to delete.
     
     Returns: 
     	 A JSON response with a message indicating whether the event was deleted or not and an HTTP status code. Example request **. : http Example response **. :
    """

    try:
        event = Animals.get(Animals.id == event_id)
        event.delete_instance()
        return jsonify({'message': f'Animal event deleted: {event_id}'}), 200
    except Animals.DoesNotExist:
        return jsonify({'message': 'Animal event not found'}), 404


if __name__ == '__main__':
    animal_routes.run(debug=True)
