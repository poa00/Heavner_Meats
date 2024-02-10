from flask import Flask, after_this_request, request
from util.key import port
from util.trace_error_handling import er, verbose_print
from util.tools import log
from routes import _cutsheets, _calendar, _customers, _users, _animals
from util.PEWEE_model import *


######################################
# from pewee_secret_model import db
# Connect to the database once at the beginning of your application
db = sql_connect(force_sqlite=True)
# param=> force_sqlite = True
######################################
db.create_tables([Customer, Events, Cutsheet, Animals, Meat])

log()

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

def run_flask_app():
    """
     Run the Flask app on port 5613 and catch any exceptions. This is a convenience function to be used in tests
    """
    verbose_print("\nRunning TE MeatPI locally...\n")
    app.run(host='0.0.0.0', port=port, threaded=True, debug=True)


if __name__ == '__main__':
    while True:
        run_flask_app()
