# animals.py
from flask import jsonify, request, Blueprint
from peewee import DoesNotExist
from flask import Flask
from playhouse.shortcuts import model_to_dict

from util.trace_error_handling import verbose_print, er
from util.PEWEE_model import *

animal_routes = Blueprint('animal_routes', __name__)

@animal_routes.route('/animals/', methods=['POST'])
def create_animal():
    """
     Create animal with data from request. This will return 201 if successful 500 if there is an error
     
     
     Returns: 
     	 JSON with message and
    """
    data = request.json
    try:
        animal_data = {key: data[key]
                       for key in data.keys() if key in Animals._meta.fields}
        animal = Animals.create(**animal_data)
        return jsonify({'message': f'Animal created with ID: {animal.id}'}), 201
    except Exception as e:
        verbose_print(e)
        er(e)
        return jsonify({'message': 'Error creating animal'}), 500


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
        return jsonify({'message': 'Error reading animals'}), 500


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


if __name__ == '__main__':
    app = Flask(__name__)
    app.register_blueprint(animal_routes)
    app.run(debug=True)
