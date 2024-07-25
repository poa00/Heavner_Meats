from flask import Flask, after_this_request, request
from util.key import port
from util.trace_error_handling import er, verbose_print
from util.tools import log
from routes import _cutsheets, _calendar, _customers, _users, _animals
from util.PEWEE_model import *
import subprocess
import time

######################################
# from pewee_secret_model import db
# Connect to the database once at the beginning of your application
db = sql_connect(force_sqlite=True)
# param=> force_sqlite = True
######################################
db.create_tables([Customer, Events, Cutsheet, Animals, Meat])

log()
RAN = False

app = Flask(__name__)
app.register_blueprint(_users.user_routes)
app.register_blueprint(_animals.animal_routes)
app.register_blueprint(_calendar.calendar_routes)
app.register_blueprint(_customers.customer_routes)
app.register_blueprint(_cutsheets.cutsheet_routes)


@app.after_request
def after_request(response):
    # Check if the response is indeed a JSON response
    print(verbose_print())
    if response.mimetype == 'application/json':
        original_data = response.get_data(as_text=True)

        # Ensure the response is not longer than 1000 characters
        if len(original_data) > 1000:
            data_to_display = original_data[:1000]
        else:
            data_to_display = original_data

        # Limit the number of lines to 25
        lines = data_to_display.split('\n')
        if len(lines) > 25:
            lines = lines[:25]
            data_to_display = '\n'.join(lines)
        print(data_to_display)
    print(verbose_print())
    # Note: For real use, you might need to set the data like below instead of printing it
    # response.set_data(data_to_display)
    # You must return the response object at the end
    return response


def close_connection():
    ports_to_close = [5613]
    for port in ports_to_close:
        try:
            output = subprocess.check_output(
                ["netstat", "-ano", "-p", "TCP"], universal_newlines=True)
            lines = output.splitlines()
            for line in lines:
                if f":{port}" in line:
                    process_id = line.split()[-1]
                    try:
                        subprocess.check_call(
                            ["taskkill", "/F", "/PID", process_id])
                        print(f"Closed port {port} (Process ID: {process_id})")
                        # Wait for 1 second to ensure the process is terminated
                        time.sleep(1)
                    except subprocess.CalledProcessError as e:
                        print(
                            f"Failed to kill process {process_id} on port {port}: {e}")
        except subprocess.CalledProcessError:
            print(f"Error checking port {port}")


def run_flask_app(port):
    """
    Run the Flask app on the specified port and catch any exceptions.
    This is a function to be used in tests.
    """

    try:
        print("\nRunning Flask app locally...\n")
        app.run(host='0.0.0.0', port=port, threaded=True, debug=True)
    except Exception as e:
        print(f"Failed to run Flask app: {e}")
        close_connection()
        run_flask_app(port)


if __name__ == '__main__':
    # close_connection()
    run_flask_app(5613)
