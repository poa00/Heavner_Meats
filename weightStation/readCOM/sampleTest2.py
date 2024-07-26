import requests
import json

# Replace this URL with the actual URL of your FastAPI server
url = "http://204.111.39.93:5614/json"

# JSON data to be sent in the request body
data = {"message": "Hello, FastAPI!"}

# Set the headers to indicate that the content type is JSON
headers = {"Content-Type": "application/json"}

try:
    # Make a POST request to the FastAPI server
    response = requests.post(url, data=json.dumps(data), headers=headers)

    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Print the response from the server
        print("Response from Server:")
        print(response.json())
    else:
        # If the request was not successful, print the error message
        print(f"Error: {response.status_code} - {response.text}")

except requests.RequestException as e:
    # Handle exceptions (e.g., network issues, invalid response)
    print(f"Error making request: {e}")
