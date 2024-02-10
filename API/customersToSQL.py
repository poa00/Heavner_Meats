import csv
import requests

# Example CSV data
with open("customers.csv", "r") as f:
    csv_data = f.read()

# Function to send POST request
def send_customer_data(data):
    url = 'http://127.0.0.1:5613/customers/'
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, json=data, headers=headers)
    return response

# Parse CSV data and make POST requests
csv_reader = csv.DictReader(csv_data.splitlines())
for row in csv_reader:
    customer_data = {
        'full_name': row['Customer full name'],
        'telephone': row['Phone'],
        'company_name': row['Company name'],
        'mobile': row['Mobile'] if row['Mobile'] != '--' else None,
        'email': row['Email'] if row['Email'] != '--' else None,
        'billing_street': row['Billing address'],
        'billing_city': row['Billing city'] if row['Billing city'] != '--' else None,
        'billing_state': row['Billing state'] if row['Billing state'] != '--' else None,
        'billing_zip': row['Billing ZIP code'] if row['Billing ZIP code'] != '--' else None,
        'billing_country': row['Billing country'] if row['Billing country'] != '--' else None,
        'shipping_street': row['Shipping address'],
        'shipping_city': row['Shipping city'] if row['Shipping city'] != '--' else None,
        'shipping_state': row['Shipping state'] if row['Shipping state'] != '--' else None,
        'shipping_zip': row['Shipping ZIP code'] if row['Shipping ZIP code'] != '--' else None,
        'shipping_country': row['Shipping country'] if row['Shipping country'] != '--' else None,
        # Assuming customerID will be auto-generated or managed at the server
        # 'customerID': you need to manage this on your own
    }
    
    # Remove empty fields
    customer_data = {k: v for k, v in customer_data.items() if v is not None}
    
    # Send the POST request
    response = send_customer_data(customer_data)
    print(f'Status Code: {response.status_code}, Response: {response.json()}')
