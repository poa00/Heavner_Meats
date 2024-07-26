import requests

base_url = "http://localhost:5613"

user = "admin"
password = "3213"

def post(jdata, app, operation):
    """
     Add data to application. This is a helper function for add_data and add_data_as_application
     
     Args:
     	 jdata: JSON data to be added
     	 app: Name of application to add data to. Can be any application
     	 operation: Operation to be performed on data
     
     Returns: 
     	 response from API
    """
    url = f"{base_url}/api/data?operation={operation}&app={app}"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(user, password), headers=headers, json=jdata)
    
    # This method is called when the response is 201.
    if response.status_code == 201:
        print("Data handled successfully.")
    else:
        print(f"Error: Unable to add data. Status code: {response.status_code}")
    print(response.text)
    return response.json()

def grab_jinja():
    url = f"{base_url}/api/data?operation=read_all&app=customers"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, auth=(user, password), headers=headers)
    return response.json()
    