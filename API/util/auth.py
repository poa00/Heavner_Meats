from user_functions import load_users_from_json
from functools import wraps
from flask import Flask, request, jsonify, Blueprint, abort
from pathlib import Path
import jsons

users = load_users_from_json()

def requires_auth(f):
    """
    A decorator function that checks if the request is authenticated.
    If the request is not authenticated, it returns a 401 Unauthorized response.
    If the request is authenticated, it calls the decorated function with the user's tier as the first argument.

    Args:
        f (function): The function to be decorated.

    Returns:
        function: The decorated function.
    """
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return jsonify({'message': f'Authentication failed\n{auth}'}), 401
        
        user = users.get(auth.username)
        if user:
            return f(user['tier'], *args, **kwargs)
        return jsonify({'message': 'User not found'}), 401
    return decorated


def check_auth(username, pin):
    """
    Check if the given username and pin match a user in the users dictionary.

    Args:
        username (str): The username to check.
        pin (str): The pin to check.

    Returns:
        bool: True if the username and pin match a user in the users dictionary, False otherwise.
    """
    user = users.get(username)
    if user and str(user["pin"]) == pin:
        return True
    return False


