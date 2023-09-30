from flask import Flask, request, jsonify
from functools import wraps
from util.api_constants import data, get_server_ip
from util.key import username, password, base_url
from api_functions import api_crud_handler, route_get_request
from util.trace_error_handling import er, verbose_print
import traceback
import logging
from util.tools import log


################################################
################################################

# line # 151 on addEvent, requests.dll send requests

################################################
################################################

log()

app = Flask(__name__)

# Basic authentication decorator
def requires_auth(f):
    """
     Check authentication before calling the function. This is a wrapper around the function that does the check and returns a JSON response with error message if authentication fails.
     
     @param f - function to call with credentials
     
     @return jsonified response with error message if authentication fails or
    """
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        # Check if the user is valid and if not return 401
        if not auth or not check_auth(auth.username, auth.password):
            return jsonify({'message': 'Authentication failed'}), 401
        return f(*args, **kwargs)
    return decorated


def check_auth(username, password):
    """
     Check authentication for admin. This is a helper function to be used by : py : func : ` get_auth `
     
     @param username - The username of the user
     @param password - The password of the user
     
     @return True if the user is authenticated False if not or if the username and password don't
    """
    return username == username and password == password


@app.route('/api/data', methods=['GET', 'POST', 'PUT', 'DELETE'])
@requires_auth
def handle_request():
    """
     Handles requests. This is the entry point for REST API. It takes care of the following : 1
    """
    print(str(f'{request}, {request.args}'))
    app_name = request.args.get('app')
    operation = request.args.get('operation')
    
    if request.method == 'GET':
        return route_get_request(request)
    
    elif request.method == 'POST':
        verbose_print(request, app_name, operation)
        try:
            return api_crud_handler(request, app_name, operation)
        
        except Exception as e:
            logging.error(f'Exception occurred in handle_crud_event(): {e}')
            traceback.print_exc()  # Print the exception traceback
            er(e)
            return jsonify({'message': f'An error occurred\n'}), 500
    else:
        return jsonify({'message': 'Invalid request method'}), 400



# Route to retrieve the server's IP address
@app.route('/api/server_ip', methods=['GET'])
def server_ip():
    """
     Get the IP of the server. This is used to determine which server is running the web application.
     
     @return JSON with server_ip or 500 if an error
    """
    try:
        ip = get_server_ip()
        return jsonify({'server_ip': "http://localhost:5613"})
    except Exception as e:
        logging.error(f'Exception occurred in handle_request(): {e}')
        traceback.print_exc()  # Print the exception traceback
        er(e)
        return jsonify({'message': 'An error occurred'}), 500

def run_flask_app():
    """
     Run the Flask app on port 5613 and catch any exceptions. This is a convenience function to be used in tests
    """
    print("\n\nRunning API locally...\n\n")
    app.run(port=5613, debug=True)


if __name__ == '__main__':
    while True:
        run_flask_app()
