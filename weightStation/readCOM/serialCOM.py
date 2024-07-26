import requests
from your_serial_module import SerialBase  # Replace 'your_serial_module' with the actual module name

# Replace these values with your actual serial port settings and API endpoint
serial_port_settings = {
    'port': 'COM1',  # Change this to your actual port name
    'baudrate': 9600,
    'timeout': 1,  # Adjust as needed
}

api_endpoint = 'https://your.api.endpoint/data'

def read_serial_data(serial):
    while True:
        try:
            # Read data from the serial port
            data = serial.read_until()  # You may need to adjust this based on your data format
            if data:
                post_data_to_api(data)
        except Exception as e:
            print(f"Error reading from serial port: {e}")

def post_data_to_api(data):
    try:
        # Post data to the API endpoint
        response = requests.post(api_endpoint, data={'data': data.decode('utf-8')})
        if response.status_code == 200:
            print(f"Data posted to API successfully: {data}")
        else:
            print(f"Failed to post data to API. Status code: {response.status_code}")
    except Exception as e:
        print(f"Error posting data to API: {e}")

if __name__ == "__main__":
    try:
        # Create and open the serial port
        serial_port = SerialBase(**serial_port_settings)
        serial_port.open()

        # Start reading and posting data
        read_serial_data(serial_port)
    except KeyboardInterrupt:
        print("Script terminated by user.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if serial_port.is_open:
            serial_port.close()
