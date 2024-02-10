from flask import Flask, request, jsonify, Blueprint
from peewee import Model, CharField, SqliteDatabase
import jsons
from util.auth import requires_auth
from pathlib import Path
from util.PEWEE_model import *
from util.trace_error_handling import verbose_print

# Create a blueprint for user routes
user_routes = Blueprint('user_routes', __name__)
JSON_FILE = Path.cwd() / 'users.json'


@user_routes.route('/users/', methods=['POST'])
def create_user():
    """
    Create a new user.

    Returns:
        tuple: A tuple containing a JSON response with a message indicating whether the user was created or not, and an HTTP status code.
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


@user_routes.route('/users/<username>', methods=['GET'])
def read_user(username):
    """
    Read a user by username.

    Args:
        username (str): The username of the user to read.

    Returns:
        tuple: A tuple containing a JSON response with the user's information, and an HTTP status code.
    """
    verbose_print(str(request))
    jdata = request.json
    for username, userinfo in load_users_from_json():
        if username == jdata['username']:
            return jsonify(userinfo), 201
    return jsonify({'message': 'error reading user'}), 400


@user_routes.route('/users/<username>', methods=['PUT'])
def update_user(username):
    """
    Update an existing user's PIN and tier.

    Args:
        username (str): The username of the user to update.

    Returns:
        tuple: A tuple containing a JSON response with a message indicating whether the user was updated or not, and an HTTP status code.
    """
    data = request.json
    users = load_users_from_json()

    if username in users:
        user = users[username]
        user['pin'] = data.get('pin', user['pin'])
        user['tier'] = data.get('tier', user['tier'])
        save_users_to_json(users)
        return jsonify({'message': f'User updated: {username}'}), 200
    else:
        return jsonify({'message': 'User not found'}), 404


@user_routes.route('/users/<username>', methods=['DELETE'])
def delete_user(username):
    """
    Delete a user by username.

    Args:
        username (str): The username of the user to delete.

    Returns:
        tuple: A tuple containing a JSON response with a message indicating whether the user was deleted or not, and an HTTP status code.
    """
    users = load_users_from_json()
    if username in users:
        del users[username]
        save_users_to_json(users)
        return jsonify({'message': f'User data removed: {username}'}), 201
    else:
        return jsonify({'message': f'User not found: {username}'}), 404

""" 
    # backup 

    jdata = request.json
    users = load_users_from_json()
    for username, userInfo in users.items():
        if username in str(jdata['username']):
            users.pop(username)
            save_users_to_json(users)
            return jsonify({'message': f'user data removed: {username}'}), 201
    return jsonify({'message': f'error reading user\n{users}'}), 400"""


@user_routes.route('/users/', methods=['GET'])
def list_users():
    """
    List all users.

    Returns:
        tuple: A tuple containing a JSON response with a list of all users and their information, and an HTTP status code.
    """
    try:
        return load_users_from_json(), 201
    except Exception as e:
        return jsonify({'message': f'error reading user\n{e}'}), 400
    
    
def api_reply_util(msg, status_code, *args):
    message = "\n".join(args)
    verbose_print(f"{msg}\n{message}\nCode: {status_code}")
    if status_code > 399:
        return jsonify({'message': f'Invalid return/response\n{message}'}), status_code
    else:
        return jsonify({'message': f'Function successful\n{message}'}), status_code
    pass
    """        return jsonify({'message': 'Invalid return/response'}), 400
    return jsonify({'message': 'Customer data updated successfully'}), 200"""
 
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


if __name__ == '__main__':
    user_routes.run(debug=True)
