import subprocess
import time

def close_connection():
    """
    Closes the TCP connections on specified ports.

    This function checks for open TCP connections on the specified ports and terminates the associated processes.

    Args:
        None

    Returns:
        None

    Raises:
        None
    """
    ports_to_close = [5613]
    print(f'{ports_to_close}')
    for port in ports_to_close:
        try:
            output = subprocess.check_output(["netstat", "-ano", "-p", "TCP"], universal_newlines=True)
            print(f'output:{output}')
            lines = output.splitlines()
            for line in lines:
                if f":{port}" in line:
                    process_id = line.split()[-1]
                    try:
                        subprocess.check_call(["taskkill", "/F", "/PID", process_id])
                        print(f"Closed port {port} (Process ID: {process_id})")
                        time.sleep(1)  # Wait for 1 second to ensure the process is terminated
                    except subprocess.CalledProcessError as e:
                        print(f"Failed to kill process {process_id} on port {port}: {e}")
        except subprocess.CalledProcessError:
            print(f"Error checking port {port}")
    time.sleep(1)
if __name__ == '__main__':
    try:
        close_connection()
    except Exception as e:
        time.sleep(1)
        print(f"An error occurred: {e}")
        time.sleep(10)
        raise e