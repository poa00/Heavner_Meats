from flask import jsonify, request, Blueprint
from peewee import DoesNotExist, IntegrityError
from flask import Flask
from playhouse.shortcuts import model_to_dict
from datetime import datetime
from util.trace_error_handling import verbose_print, er
from util.PEWEE_model import *
from routes.shareable_functions import print_error

animal_routes = Blueprint('animal_routes', __name__)
'''
@animal_routes.route('/animals/<int:eventid>/', methods=['POST'])
def create_animal(eventid):
    """
    Create animal with data from request and event ID. This will return 201 if successful, 500 if there is an error.
    
    Args:
        eventid (int): The ID of the event to associate with the animal.
    
    Returns: 
        JSON with message and status code.
    """
    data = request.json
    with db.atomic():  # Start an atomic transaction
        try:
            # Get the customer ID associated with the event ID
            customer_id = Events.get(Events.id == eventid).customer.id
            
            # Include customer_id in the animal data
            animal_data = {key: data[key]
                           for key in data.keys() if key in Animals._meta.fields}
            # Set the customer foreign key
            animal_data['customer'] = customer_id
            animal_data['event_id'] = eventid
            # Create the animal record
            animal = Animals.create(**animal_data)
            return jsonify({'message': f'Animal created with ID: {animal.id}'}), 201
        except Events.DoesNotExist:
            return jsonify({'message': 'Event not found'}), 404
        except IntegrityError as e:
            er(e)
            return jsonify({'message': 'Error creating animal due to integrity issues'}), 400
        except Exception as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error creating animal'}), 500
'''

"""
import requests
import json

url = "http://localhost:5000/animals/1/"  # Assuming event ID 1, adjust the URL accordingly

data = {
    "species": "Cow",
    "gender": "Male",
    "is_over_30_months": True,
    "organs": "Complete",
    "comments": "No comments",
    "cutsheet": "Sample cutsheet data",
    "live_weight": 1500,
    "manual_entry_weight": 1400,
    "ear_tag": "ETAG123"
}

response = requests.post(url, json=data)

print(response.json())
"""


@animal_routes.route('/animals/<int:eventid>/', methods=['POST'])
def create_animal(eventid):
    """
    Updated to create the correct species based animal record from the input.

    Args:
        eventid (int): The ID of the event to be associated with the animal.

    Returns:
        JSON with a message and status code.
    """
    data = request.json
    with db.atomic():  # Start an atomic transaction
        try:
            # Retrieve associated customer ID with event ID
            customer_id = Events.get(Events.id == eventid).customer.id

            animal_data = {key: data[key] for key in (
                'gender', 'is_over_30_months', 'organs', 'comments') if key in data}
            animal_data.update({
                'species': data['species'],
                'event': eventid,
                'customer': customer_id,
                'cutsheet': data.get('cutsheet')
            })

            # Crete the generic animal record
            animal = Animals.create(**animal_data)

            # Species-specific handling
            species = data['species'].lower()
            if species == 'cow':
                Cow.create(animal=animal.id, **{key: data[key] for key in (
                    'live_weight', 'manual_entry_weight', 'ear_tag') if key in data})
            elif species == 'pig':
                Pig.create(animal=animal.id, **
                           {key: data[key] for key in ('gender',) if key in data})
            elif species == 'lamb':
                Lamb.create(animal=animal.id, **
                            {key: data[key] for key in ('gender',) if key in data})

            return jsonify({'message': f'{species.capitalize()} created with ID: {animal.id}'}), 201
        except Events.DoesNotExist:
            return jsonify({'message': 'Event not found'}), 404
        except IntegrityError as e:
            return print_error(e)
        except Exception as e:
            return print_error(e)


@animal_routes.route('/animals/event/<int:eventid>/total_remaining/', methods=['GET'])
def event_animals_total_remaining(eventid):
    """
    Returns the total number of animals remaining for a given event ID,
    subtracting those already instantiated per species.
    """
    try:
        event = Events.get_by_id(eventid)
        instantiated_counts = Animals.select(
            Animals.species,
            fn.COUNT(Animals.species).alias('instantiated')
        ).where(Animals.event == eventid).group_by(Animals.species)

        instantiated_dict = {animal.species.lower(
        ): animal.instantiated for animal in instantiated_counts}

        total_cows_remaining = event.cows - instantiated_dict.get('cow', 0)
        total_pigs_remaining = event.pigs - instantiated_dict.get('pig', 0)
        total_lambs_remaining = event.lambs - instantiated_dict.get('lamb', 0)

        total_remaining = total_cows_remaining + \
            total_pigs_remaining + total_lambs_remaining

        return jsonify({
            'event_id': eventid,
            'total_remaining': total_remaining,
            'details': {
                'cows': {
                    'total': event.cows,
                    'remaining': total_cows_remaining
                },
                'pigs': {
                    'total': event.pigs,
                    'remaining': total_pigs_remaining
                },
                'lambs': {
                    'total': event.lambs,
                    'remaining': total_lambs_remaining
                }

            }
        }), 200
    except Events.DoesNotExist:
        return jsonify({'message': 'Event not found'}), 404
    except Exception as e:
        return print_error(e)


@animal_routes.route('/animals/', methods=['GET'])
def read_all_animals():
    """
     Read all animals from database. This is used to read all animals that have been added to the database.


     Returns: 
         JSON with list of animals in dict format and status code 200 if everything worked. 500 if there was an error
    """
    try:
        animals = Animals.select()
        animals_data = [model_to_dict(animal) for animal in animals]
        return jsonify(animals_data), 200
    except DoesNotExist as e:
        verbose_print(e)
        er(e)
        return print_error(e)


@animal_routes.route('/animals/event/<int:eventid>/details/', methods=['GET'])
def get_all_animals_with_details_for_event(eventid):
    """
    Get all animals and their species-specific details for a given event ID.
    """
    try:
        query = Animals.select(Animals, Cow, Pig, Lamb).join(Cow, JOIN.LEFT_OUTER, on=(Animals.id == Cow.animal_id)).switch(Animals).join(Pig, JOIN.LEFT_OUTER, on=(
            Animals.id == Pig.animal_id)).switch(Animals).join(Lamb, JOIN.LEFT_OUTER, on=(Animals.id == Lamb.animal_id)).where(Animals.event_id == eventid)

        animals_details = []

        for animal in query:
            details = {
                'species': animal.species,
                'gender': animal.gender,
                'organs': animal.organs,
                'comments': animal.comments,
                'created_on': animal.created_on
            }
            if animal.species.lower() == 'cow' and hasattr(animal, 'cows'):
                details.update({
                    'live_weight': animal.cows.live_weight,
                    'manual_entry_weight': animal.cows.manual_entry_weight,
                    'ear_tag': animal.cows.ear_tag,
                    'teid': animal.cows.teid,
                    'is_over_30_months': animal.cows.is_over_30_months
                })
            elif animal.species.lower() == 'pig' and hasattr(animal, 'pigs'):
                details.update({
                    'weight': animal.pigs.weight
                })
            elif animal.species.lower() == 'lamb' and hasattr(animal, 'lambs'):
                details.update({
                    'weight': animal.lambs.weight
                })

            animals_details.append(details)

        return jsonify(animals_details), 200
    except Exception as e:
        return jsonify({'message': 'Error retrieving animals with details for event', 'error': str(e)}), 500


@animal_routes.route('/animals/details/', methods=['GET'])
def get_all_animals_with_details():
    """
    Get all animals and their species-specific details.
    """
    try:
        query = Animals.select(Animals, Cow, Pig, Lamb).join(Cow, JOIN.LEFT_OUTER, on=(Animals.id == Cow.animal_id)).switch(Animals).join(
            Pig, JOIN.LEFT_OUTER, on=(Animals.id == Pig.animal_id)).switch(Animals).join(Lamb, JOIN.LEFT_OUTER, on=(Animals.id == Lamb.animal_id))

        animals_details = []

        for animal in query:
            details = {
                'species': animal.species,
                'gender': animal.gender,
                'organs': animal.organs,
                'comments': animal.comments,
                'created_on': animal.created_on
            }
            if animal.species.lower() == 'cow' and hasattr(animal, 'cows'):
                details.update({
                    'live_weight': animal.cows.live_weight,
                    'manual_entry_weight': animal.cows.manual_entry_weight,
                    'ear_tag': animal.cows.ear_tag,
                    'teid': animal.cows.teid,
                    'is_over_30_months': animal.cows.is_over_30_months
                })
            elif animal.species.lower() == 'pig' and hasattr(animal, 'pigs'):
                details.update({
                    'weight': animal.pigs.weight
                })
            elif animal.species.lower() == 'lamb' and hasattr(animal, 'lambs'):
                details.update({
                    'weight': animal.lambs.weight
                })

            animals_details.append(details)

        return jsonify(animals_details), 200
    except Exception as e:
        return jsonify({'message': 'Error retrieving animals with details', 'error': str(e)}), 500


@animal_routes.route('/animals/<animal_id>', methods=['GET'])
def read_single_animal(animal_id):
    """
     Read a single animal from the database. This is a view to allow a user to read data from a single animal

     Args:
         animal_id: id of the animal to read

     Returns: 
         jsonified data of the animal or 404 if not found or error in json. : quickref : Animals ; read_single_animal
    """
    try:
        animal = Animals.get_by_id(animal_id)
        animal_data = model_to_dict(animal)
        return jsonify(animal_data), 200
    except Animals.DoesNotExist:
        return jsonify({'message': 'Animal not found'}), 404


@animal_routes.route('/animals/<animal_id>', methods=['PUT'])
def update_animal(animal_id):
    """
     Update animal with given ID. This will take a JSON object and update all fields that are in the fields list.

     Args:
         animal_id: ID of the animal to update

     Returns: 
         JSON with message and
    """
    try:
        animal = Animals.get_by_id(animal_id)
    except Animals.DoesNotExist:
        return jsonify({'message': f'Animal with ID {animal_id} does not exist.'}), 404

    args = request.json
    updated_fields = {k: v for k,
                      v in args.items() if k in Animals._meta.fields}
    for field, value in updated_fields.items():
        setattr(animal, field, value)

    animal.save()
    return jsonify({'message': f'Animal with ID {animal.id} has been updated.'}), 200


@animal_routes.route('/animals/<animal_id>', methods=['DELETE'])
def delete_animal(animal_id):
    """
     Delete animal from the database. This will delete the animal and all related data for it.

     Args:
         animal_id: id of the animal to delete

     Returns: 
         a json with the message of the deletion and the status of the deletion. Example request **. : http Example response **. : http HTTP / 1. 1 200 OK Content - Type : application /
    """
    try:
        animal = Animals.get_by_id(animal_id)
        animal.delete_instance()
        return jsonify({'message': f'Animal deleted: {animal_id}'}), 200
    except Animals.DoesNotExist:
        return jsonify({'message': 'Animal not found'}), 404


def get_animal_teid(animal_id):
    """
    Retrieves the TEID for a given animal by its ID.

    :param animal_id: The ID of the animal.
    :return: The TEID of the animal or None if not found.
    """
    animal_instance = Animals.get_or_none(Animals.id == animal_id)
    if animal_instance:
        return animal_instance.teid
    else:
        return None


@animal_routes.route('/animals/teid/', methods=['GET'])
def get_teid():
    """
    Returns a TEID for the given event ID.

    Args:
        eventid (int): The ID of the event for which the TEID is being requested.

    Returns:
        JSON with TEID or an error message.
    """
    teid = calculate_and_assign_teid()
    if teid:
        return jsonify({'TEID': teid}), 200
    else:
        return jsonify({'message': 'Event not found'}), 404


@animal_routes.route('/animals/associate_cutsheets', methods=['POST'])
def associate_animals_with_cutsheets():
    data = request.get_json()
    if not data:
        return jsonify({'message': 'Invalid JSON data provided.'}), 400

    for animal_id, cutsheet_id in data.items():
        try:
            animal = Animals.get_by_id(animal_id)
            cutsheet = Cutsheet.get_by_id(cutsheet_id)
        except Animals.DoesNotExist:
            return jsonify({'message': f'Animal with ID {animal_id} does not exist.'}), 404
        except Cutsheet.DoesNotExist:
            return jsonify({'message': f'Cutsheet with ID {cutsheet_id} does not exist.'}), 404

        animal.cutsheet = cutsheet
        animal.save()

    return jsonify({'message': 'Animals associated with cutsheets successfully.'}), 200


def calculate_and_assign_teid():
    """
    Assigns a TEID to an animal instance based on current date and its sequence number for the day.

    :param animal_instance: Instance of the Animals model to which the TEID is to be assigned.
    """
    # Get today's date
    today = datetime.now().date()

    # Count how many animals have been registered today for generating a sequence number
    # Note: Make sure the created_on field uses the same date format as datetime.now().date()
    today_count = Animals.select().where(Animals.created_on == today).count()

    # Construct TEID: Month (2 digits), Day (2 digits), Sequence (incremental number of animals today)
    teid_number = int(f"{today.month:02}{today.day:02}{today_count + 1:03}")
    return teid_number


if __name__ == '__main__':
    app = Flask(__name__)
    app.register_blueprint(animal_routes)
    app.run(debug=True)
