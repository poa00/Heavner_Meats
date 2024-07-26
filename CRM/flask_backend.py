from flask import Flask, render_template, request, redirect, url_for, jsonify
import threading
from customerCSV import CustomersJson
from pewee_sql_handler import grab_customers_for_jinja, read_customer, update_customer
from pathlib import Path
from time import sleep
from util._extend_backend import process_pewee_update
import logging
from util.find_temp_static_folder import find_temp_static as find_template_folder
from util._requests import *

temp, static = find_template_folder()
app = Flask(__name__, template_folder=temp, static_folder=static)


def flask_thread(PORT):
    """
    `threading.Thread(flask)` =>
        launch thread for flask app"""
    try:
        t = threading.Thread(target=start_flask, args=[PORT])
        t.daemon = True
        t.start()
    except Exception as e:
        print(f"Error while starting Flask: {e}")

def start_flask(PORT):
    """
    `start_flask(PORT) => app.run(port=PORT)`"""
    app.run(port=PORT)


@app.route('/', methods=['GET', 'POST'])
def index():
    """
    The index page of the application. It is used to display the list of customers and their profile.""" 
    return render_template('index.html', customers=grab_jinja())

@app.route('/newCustomer')
def new_customer():
    return render_template('new_customer.html')

@app.route('/deleteCustomer')
def delete_customer():
    customerID = request.args.get('customerID')
    customer = read_customer(customerID)
    return render_template('confirmDelete.html', customer=customer)


# ==> view ==> edit ==> @ def processUpdate ==> index
@app.route('/profileViewEdit')
def profile_view_edit():
    customerID = request.args.get('customerID')
    customer = post({"customerID":customerID}, "customers", "read")
    return render_template('profileViewEdit.html', customer=customer)


# open calendar app, wait to finish, then return to index
@app.route('/scheduleCustomerPost')
def schedule_customer():
    customerID = request.args.get('customerID')
    customer = read_customer(customerID)
    return render_template('profileViewEdit.html', customer=customer)


@app.route('/result')
def result():
    return render_template('result.html')


@app.route('/processUpdate', methods=['GET', 'POST'])
def process_customer_update():
    try:
        form_data = request.form
        status = process_pewee_update(form_data)
        if status == True:
            return redirect(url_for('index'))
        else:
            print(str(status))
            return redirect(url_for('index'))
    except Exception as e:
        print(str(e))
        return redirect(url_for('index'))