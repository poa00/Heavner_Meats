# Import necessary modules
from flask import Flask
from werkzeug.serving import WSGIRequestHandler
import socket
import requests

# Function to check if a port is open on a given host
def is_port_open(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex((host, port))
    sock.close()
    return result == 0

# Function to check if the Flask API is accessible from another computer
def test_api_accessibility(api_url):
    try:
        response = requests.get(api_url)
        if response.status_code == 200:
            return True, "API is accessible."
        else:
            return False, f"API returned status code: {response.status_code}"
    except requests.ConnectionError:
        return False, "Failed to connect to the API."

# Function to run a diagnostic test for Flask API accessibility
def run_diagnostics():
    # Flask app
    app = Flask(__name__)

    # Endpoint for testing purposes
    @app.route('/')
    def hello():
        return "Hello, World!"

    # Set host to '0.0.0.0' to make the server externally accessible
    host = '0.0.0.0'
    port = 5000

    # Run Flask app with the diagnostic server
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(host=host, port=port, debug=False, threaded=True)

if __name__ == '__main__':
    # Set the API URL based on the Flask app's host and port
    api_url = 'http://localhost:5000/'

    # Check if the API port is open
    if is_port_open('0.0.0.0', 5000):
        print("Port 5000 is open.")
    else:
        print("Port 5000 is not open. Check firewall settings and network configurations.")

    # Run the Flask API diagnostics
    print("\nRunning Flask API diagnostics:")
    run_diagnostics()

    # Test the API accessibility
    success, message = test_api_accessibility(api_url)
    print(f"\nAPI Accessibility Test: {'Success' if success else 'Failure'} - {message}")
