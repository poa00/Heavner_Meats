import requests

# Define the base URL of your Flask application
base_url = "http://localhost:5613"  # Replace with your actual server URL

# Authentication credentials
auth = ('sam fisher', '3213')  # Replace with actual credentials

# Create a new user
user_data = {
    "username": "new_user",
    "pin": "1234",
    "tier": "standard"
}
create_user_url = f"{base_url}/users/"
response = requests.post(create_user_url, json=user_data, auth=auth)
print(f"Create User Response: {response.status_code}")
print(response.json())

# Read a user
read_user_username = "new_user"  # Replace with the username you want to read
read_user_url = f"{base_url}/users/{read_user_username}"
response = requests.get(read_user_url, auth=auth)
print(f"Read User Response: {response.status_code}")
print(response.json())

# Update a user
updated_user_data = {
    "pin": "5678",
    "tier": "premium"
}
update_user_url = f"{base_url}/users/{read_user_username}"
response = requests.put(update_user_url, json=updated_user_data, auth=auth)
print(f"Update User Response: {response.status_code}")
print(response.json())

# Delete a user
delete_user_url = f"{base_url}/users/{read_user_username}"
response = requests.delete(delete_user_url, auth=auth)
print(f"Delete User Response: {response.status_code}")
print(response.json())
