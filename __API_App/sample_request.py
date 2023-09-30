import requests
from time import sleep

from util.key import username, password, base_url

# Function to retrieve the server's IP address
def get_server_ip():
    response = requests.get(f"{base_url}/api/server_ip")
    if response.status_code == 200:
        return response.json()["server_ip"]
    else:
        print(f"Error: Unable to retrieve server IP. Status code: {response.status_code}")
        return None

# Function to retrieve the JSON data
def get_api_data():
    response = requests.get(f"{base_url}/api/data", auth=(username, password))
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: Unable to retrieve API data. Status code: {response.status_code}")
        return None
    
def send_delete_request(new_entry):
    url = f"{base_url}/api/data?operation=delete&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(username, password), headers=headers, json=new_entry)

    if response.status_code == 201:
        print("Data added successfully.")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")
        
            
def request_read_all():
    url = f"{base_url}/api/data?operation=read_all&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(username, password), headers=headers)
    print(str(response))
    if response.status_code == 201:
        print(f"{response.text}")
        print("Data added successfully.")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")
        
            
def request_custome(custID):
    url = f"{base_url}/api/data?operation=read_all&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(username, password), headers=headers)
    print(str(response))
    if response.status_code == 201:
        print(f"{response.text}")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")
        
        
def create_customers(new_entry):
    url = f"{base_url}/api/data?operation=create&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(username, password), headers=headers, json=new_entry)
    if response.status_code == 201:
        print(f"{response.text}")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")
        
        
def send_update_request(new_entry):
    url = f"{base_url}/api/data?operation=update&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, json=new_entry, auth=(username, password), headers=headers)

    if response.status_code == 201:
        print("Data added successfully.")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")


# Example usage
if __name__ == "__main__":
    # server_ip = get_server_ip()
    # if server_ip:
    #     print(f"Server IP: {server_ip}")

    # api_data = get_api_data()
    # if api_data:
    #     print("API Data:")
    #     for entry in api_data:
    #         print(entry)

    ####################################
    
    # Add a new entry
    request_read_all()
    new_entry = {
        "telephone": 1111111150,
        "full_name": "111New Customer",
        "customerID": 40839,
        "email": 11111017,
        "billing_street": 50,
        "billing_state": 200,
        "billing_zip": 40
    }
    # request_read_all()
    send_delete_request({"customerID": 40839})
    # Send the "update" request to add the new data
    # send_update_request(new_entry)
    # create_customers(new_entry)
    sleep(10)
