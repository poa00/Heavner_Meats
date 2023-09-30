import socket
from pathlib import Path

# Define your API password
PASSWORD = "3213"

# Sample JSON data
data = [
    {
        "cows": "null",
        "customer": "Beth Eavers",
        "customerid": 10027,
        "eventid": 1002,
        "lambs": "null",
        "pigs": 277,
        "week": 37
    },
    # ... (other data entries)
]


# Function to get the server's IP address
def get_server_ip():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    return ip_address


def read_data():
    if Path(__file__).parent / 'events.json'.exists():
        data_file = Path(__file__).parent / 'events.json'
    with open(data_file, 'r') as f:
        data = f.read()