from flask import Flask, after_this_request, request, jsonify
import subprocess
import time
import traceback

def print_error(e):
    error_info = traceback.format_exc().splitlines()[-3:]  # Last 3 lines of traceback
    response = jsonify({
        'message': 'An error occurred.',
        'error': str(e),
        'traceback': error_info
    })
    return response, 500

def custom_error_handler(error):
    """
    Custom error handler that includes error message, line number, and traceback.
    """
    error_info = traceback.format_exc()
    response = jsonify({
        'error': str(error),
        'traceback': error_info.splitlines()
    })
    response.status_code = 500
    return response

"""
@app.errorhandler(Exception)
def handle_exception(e):
    return custom_error_handler(e)
"""
"""
    example:

# Example route for demonstration
@app.route('/')
def index():
    raise Exception("This is a test exception.")

"""