from flask import jsonify, request, Blueprint
from peewee import DoesNotExist
from flask import Flask, request, jsonify, Blueprint
from peewee import *
from datetime import datetime
from util.trace_error_handling import er, verbose_print
from util.PEWEE_model import *
from playhouse.shortcuts import model_to_dict

cutsheet_routes = Blueprint('cutsheet_routes', __name__)

def get_current_yearweek():
    return datetime.now().isocalendar()[0] * 100 + datetime.now().isocalendar()[1]


@cutsheet_routes.route('/cutsheets/', methods=['POST'])
def create_cutsheet():
    """
    Create a cutsheet.

    This function handles the creation of a cutsheet by extracting the necessary data from the request JSON.
    Only the specified fields are allowed to be used from the request data.
    The cutsheet is then created using the extracted data and returned as a JSON response.

    Returns:
        A JSON response containing the message and ID of the created cutsheet.

    Raises:
        Exception: If there is an error creating the cutsheet.
    """
    data = request.json
    with db.atomic():  # Start an atomic transaction
        try:
            # Only allow specified fields to be used from request data
            cutsheet_data = {key: data[key]
                             for key in data.keys() if key in Cutsheet._meta.fields}
            # Retrieve the recipient if provided and it exists
            if 'recipient' in data:
                recipient_id = data['recipient']
                recipient_ = Customer.get_by_id(recipient_id)
                cutsheet_data['recipient'] = recipient_

            cutsheet = Cutsheet.create(**cutsheet_data)
            return jsonify({'message': 'Cutsheet created successfully', 'id': cutsheet.id}), 201
        except Customer.DoesNotExist:
            return jsonify({'message': 'Recipient not found'}), 404
        except IntegrityError as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error creating cutsheet due to integrity issues'}), 400
        except Exception as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error creating cutsheet'}), 500


@cutsheet_routes.route('/cutsheets/search', methods=['POST'])
def search_cutsheets():
    """
    Search and retrieve cutsheets based on the specified parameters.

    Expected Payload:
    - JSON object with key-value pairs: The key represents the column name, and the value is the filter criteria.

    Returns:
        A JSON response containing the filtered cutsheets data if successful, or an error message if unsuccessful.
    """
    try:
        query = Cutsheet.select()

        # Assuming search parameters are sent as a JSON body in a POST request
        search_parameters = request.json

        # Validate that search_parameters is indeed a dictionary
        if not isinstance(search_parameters, dict):
            return jsonify({'message': 'Invalid search data format. Expected a JSON object.'}), 400

        for key, value in search_parameters.items():
            if hasattr(Cutsheet, key):
                field = getattr(Cutsheet, key)
                query = query.where(field == value)
            else:
                # You can opt to ignore invalid keys or return an error
                return jsonify({'message': f'Invalid search key: {key}'}), 400

        query_result = query.execute()
        cutsheets_data = [model_to_dict(cutsheet) for cutsheet in query_result]

        return jsonify(cutsheets_data), 200
    except DoesNotExist:
        return jsonify({'message': 'No matching cutsheets found'}), 404
    except Exception as e:
        # Rather than printing the error directly, it's often better to log it
        # and sanitize the output to the user.
        verbose_print(e)
        er(e)
        return jsonify({'message': 'An unexpected error occurred during the search'}), 500


@cutsheet_routes.route('/cutsheets/as_producer/<producer_id>', methods=['GET'])
def search_cutsheets_by_producer(producer_id):
    """
    Search and retrieve a maximum of 20 latest cutsheets based on the producer_id.
    
    producer_with_events
    
    Expected Payload:
    - No payload expected as we are using a GET request.

    Returns:
        A JSON response containing the filtered cutsheets data if successful, or an error message if unsuccessful.
    """
    if not producer_id:
        return jsonify({'message': 'Missing producer_id parameter'}), 400

    try:
        if str(producer_id).isnumeric():
            producer_id = int(producer_id)
        # Query Cutsheet objects with the given producer_id, ordered by IDs in descending order, limited to 20 results
        cutsheets_query = (Cutsheet.select()
                            .where(Cutsheet.producer_id == producer_id)
                            .order_by(Cutsheet.id.desc())
                            .limit(20))
        cutsheets_data = [model_to_dict(cutsheet)
                            for cutsheet in cutsheets_query]
        return jsonify(cutsheets_data), 200
    except DoesNotExist:
        return jsonify({'message': 'No matching cutsheets found'}), 404
    except Exception as e:
        # Proper logging is recommended instead of print(e)
        return jsonify({'message': 'An unexpected error occurred during the search'}), 500


@cutsheet_routes.route('/cutsheets/<cutsheet_id>', methods=['GET'])
def read_single_cutsheet(cutsheet_id):
        """
        Retrieve a single cutsheet by its ID.

        Parameters:
        - cutsheet_id (str): The ID of the cutsheet to retrieve.

        Returns:
        - JSON response: The cutsheet data as a JSON object.
            If the cutsheet is not found, a JSON object with a 'message' key will be returned with a 404 status code.
        """
        try:
            if str(cutsheet_id).isnumeric():
                cutsheet_id = int(cutsheet_id)
            cutsheet = Cutsheet.get(Cutsheet.id == cutsheet_id)
            cutsheet_data = model_to_dict(cutsheet)
            return jsonify(cutsheet_data), 200
        except Cutsheet.DoesNotExist:
                return jsonify({'message': 'Cutsheet not found'}), 404


@cutsheet_routes.route('/cutsheets/', methods=['GET'])
def read_all_cutsheets():
    """
    Retrieve all cutsheets from the database.

    Returns:
        A JSON response containing the cutsheets data if successful, or an error message if unsuccessful.
    """
    try:
        cutsheets = Cutsheet.select()
        cutsheets_data = [model_to_dict(cutsheet) for cutsheet in cutsheets]
        return jsonify(cutsheets_data), 200
    except Customer.DoesNotExist as e:
        verbose_print(e)
        er(e)
        return jsonify({'message': 'Error reading cutsheets, customers not found'}), 500


@cutsheet_routes.route('/cutsheets/<cutsheet_id>', methods=['PUT'])
def update_cutsheet(cutsheet_id):
    """
    Update a cutsheet with the given cutsheet_id.

    Args:
        cutsheet_id (str): The ID of the cutsheet to be updated.

    Returns:
        Response: A JSON response indicating the status of the update operation.
    """
    args = request.json

    with db.atomic():  # Start an atomic transaction
        try:
            cutsheet = Cutsheet.get_by_id(cutsheet_id)
            if 'cutsheet' in args:
                # Replace the 'cutsheet' JSON data entirely.
                cutsheet.cutsheet = args['cutsheet']

            # Handle other fields that might be provided, excluding 'cutsheet'.
            other_fields = {k: v for k, v in args.items(
            ) if k in Cutsheet._meta.fields and k != 'cutsheet'}
            for field, value in other_fields.items():
                setattr(cutsheet, field, value)

            cutsheet.save()  # Save the changes to the database.
            return jsonify({'message': f'Cutsheet with ID {cutsheet.id} has been updated.'}), 200
        except Cutsheet.DoesNotExist:
            return jsonify({'message': f'Cutsheet with ID {cutsheet_id} does not exist.'}), 404
        except IntegrityError as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Integrity error during update.'}), 400
        except Exception as e:
            verbose_print(e)
            er(e)
            return jsonify({'message': 'Error updating cutsheet.'}), 500

@cutsheet_routes.route('/cutsheets/<cutsheet_id>', methods=['DELETE'])
def delete_cutsheet(cutsheet_id):
    """
    Delete a cutsheet with the given cutsheet_id.

    Parameters:
    - cutsheet_id (str): The ID of the cutsheet to be deleted.

    Returns:
    - response (json): A JSON response indicating the result of the deletion.
        - If the cutsheet is found and deleted, the response will have a status code of 200 and a message indicating the deletion.
        - If the cutsheet is not found, the response will have a status code of 404 and a message indicating that the cutsheet was not found.
    """
    try:
        if cutsheet_id.isnumeric():
            cutsheet_id = int(cutsheet_id)
        cutsheet = Cutsheet.get(Cutsheet.id == cutsheet_id)
        cutsheet.delete_instance()
        return jsonify({'message': f'Cutsheet deleted: {cutsheet_id}'}), 200
    except Cutsheet.DoesNotExist:
        return jsonify({'message': 'Cutsheet not found'}), 404


@cutsheet_routes.route('/cutsheets/future/<int:customer_id>', methods=['GET'])
def get_future_cutsheets(customer_id):
    current_yearweek = get_current_yearweek()

    # Assuming a cutsheet will have an associated event to determine yearweek
    try:
        query = (Cutsheet
                .select()
                .join(Events)
                .where(
                    (Cutsheet.producer_id == customer_id) &
                        (Events.yweek >= current_yearweek)))

        cutsheets_data = [model_to_dict(cutsheet)
                            for cutsheet in query]
        return jsonify(cutsheets_data)
    except DoesNotExist:
        return jsonify({'message': 'No matching cutsheets found'}), 404
    except Exception as e:
        # Rather than printing the error directly, it's often better to log it
        # and sanitize the output to the user.
        verbose_print(e)
        er(e)
        return jsonify({'message': 'An unexpected error occurred during the search'}), 500


@cutsheet_routes.route('/cutsheets/historic/<int:customer_id>', methods=['GET'])
def get_historic_cutsheets(customer_id):
    try:
        current_yearweek = get_current_yearweek()
        query = (Cutsheet
                .select()
                .join(Events)
                .where((Cutsheet.producer_id == customer_id) &
                        (Events.yweek < current_yearweek))
                .order_by(Events.yweek.desc())
                .limit(20))

        cutsheets_data = [model_to_dict(cutsheet)
                        for cutsheet in query] 
        return jsonify(cutsheets_data)
    except DoesNotExist:
        return jsonify({'message': 'No matching cutsheets found'}), 404
    except Exception as e:
        # Rather than printing the error directly, it's often better to log it
        # and sanitize the output to the user.
        verbose_print(e)
        er(e)
        return jsonify({'message': 'An unexpected error occurred during the search'}), 500



if __name__ == '__main__':
    app = Flask(__name__)
    app.register_blueprint(cutsheet_routes)
    app.run(debug=True)
