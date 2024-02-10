import requests

# Define the base URL of your Flask app
base_url = 'http://localhost:5613'  # Replace with the actual URL of your Flask app

# Test POST request to create a calendar event
def test_create_event():
    data = {
        "customer": 32405,
        "week": 50,
        "cows": 0,
        "pigs": 5,
        "lambs": 5
    }
    response = requests.post(f"{base_url}/events/", json=data)

    if response.status_code == 201:
        print("Calendar event created successfully.")
        print(response.json())
    else:
        print("Failed to create a calendar event.")
        print(response.status_code, response.json())

# Test GET request to read all calendar events
def test_read_all_events():
    response = requests.get(f"{base_url}/events/")

    if response.status_code == 200:
        print("All calendar events retrieved successfully.")
        print(response.json())
    else:
        print("Failed to retrieve calendar events.")
        print(response.status_code, response.json())

# Call the test functions
if __name__ == '__main__':
    test_create_event()
    test_read_all_events()
