import sys
from util.trace_error_handling import er, verbose_print
from flask import *
from peewee import *
import jsons
from util.PEWEE_model import *
from peewee import Model, CharField, SqliteDatabase

# Define the JSON file to store user data
JSON_FILE = Path.cwd() / 'users.json'
user_routes = Flask(__name__)

# db = SqliteDatabase('users.db')

# Define the User model
# class User(Model):
#     username = CharField(unique=True)
#     pin = CharField()
#     tier = CharField()

#     class Meta:
#         database = db
        
# db.connect()
# db.create_tables([User], safe=True)



def user_post_route(operation, request, tier=2):
    """
     Route to user function based on operation. This is used to route requests that are sent to the user server to create or update users
     
     Args:
         operation: operation that should be performed
         request: request object that contains request parameters and other data
         tier: the authorization tier (default: 2)
     
     Returns: 
         json response with status code and message of the route
    """
    match_found = False
    for function_name in user_functions(tier):
        if operation == function_name:
            verbose_print("user function found")
            match_found = True
            route_function = getattr(sys.modules[__name__], f'_{operation}_user')
            return route_function(request)
            
    if not match_found:
        verbose_print(route_function, "user function not found")
        return jsonify({'message': f'error running application function, please see log'}), 500

        
def user_functions(tier):
    """
     List of user functions. This is a list of function names that are used to create / update / delete users.
     
     Args:
         tier: the authorization tier
     
     Returns: 
         a list of user functions based on the specified tier
    """
    function_dictionary = {}
    function_dictionary['1'] = [ "read",  "read_all", "update", "delete", "create" ]
    function_dictionary['2'] = [""]
    return function_dictionary[str(tier).strip()]



def _read_user(request):
    """
    Reads user information from a JSON file and returns it as a JSON response.

    Args:
        request: A Flask request object containing a JSON payload with a 'username' key.

    Returns:
        A Flask JSON response containing the user information for the specified username, or an error message and status code if the user could not be found.
    """
    jdata = request.json
    for username, userinfo in load_users_from_json():
        if username == jdata['username']:
            return jsonify(userinfo), 201
    return jsonify({'message': 'error reading user'}), 400


def create_user():
    """
    Creates a new user with the given username, pin, and tier.

    Args:
        request: A Flask request object containing the user data in JSON format.

    Returns:
        A Flask response object with a JSON message indicating whether the user was successfully created or not.
    """
    jdata = request.json
    user = {
        'username': jdata['username'],
        'pin': jdata['pin'],
        'tier': jdata['tier']
    }
    users = load_users_from_json()
    users[jdata['username']] = user
    save_users_to_json(users)
    
    if user:
        return jsonify({'message': f'user created: {user}'}), 201 
    return jsonify({'message': f'Invalid return/response: user = {user}'}), 400


def _read_all_user(request):
    """
     Read all users from the database. This is a helper method for viewing user data.
     
     Args:
     	 request: The request to the API. It should contain the user's id.
     
     Returns: 
     	 The JSON response with the created user's id
    """
    try:
        return load_users_from_json(), 201
    except Exception as e:
        return jsonify({'message': f'error reading user\n{e}'}), 400
    
    
def _delete_user(request):
    """
    Deletes a user from the users dictionary based on the username provided in the request's JSON data.

    Args:
        request: A Flask request object containing JSON data with a 'username' key.

    Returns:
        A Flask response object with a JSON message indicating whether the user was successfully deleted or if there was an error.
    """
    jdata = request.json
    users = load_users_from_json()
    for username, userInfo in users.items():
        if username in str(jdata['username']):
            users.pop(username)
            save_users_to_json(users)
            return jsonify({'message': f'user data removed: {username}'}), 201
    return jsonify({'message': f'error reading user\n{users}'}), 400


def list_users():
    return users


def load_users_from_json():
    """
    Loads user data from a JSON file and returns it as a dictionary.

    Returns:
    dict: A dictionary containing user data.
    """
    with open(JSON_FILE, 'r') as file:
        global users
        jdata = file.read()
        users = jsons.loads(jdata)
        return users

def save_users_to_json(users):
    """Save users to the JSON file"""
    with open(JSON_FILE, 'w') as file:
        file.write(jsons.dumps(users))