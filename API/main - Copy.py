import subprocess
import socket
import platform


def add_firewall_rule(port):
    if platform.system().lower() != 'windows':
        print("This script is intended for Windows only.")
        return

    try:
        # Check if the port is already open in the firewall
        result = subprocess.run(['netsh', 'advfirewall', 'firewall',
                                'show', 'rule', f'name=AllowPort{port}'], capture_output=True)
        if 'No rules match the specified criteria.' in result.stdout.decode():
            # Add a new rule to allow traffic on the specified port
            subprocess.run(['netsh', 'advfirewall', 'firewall', 'add', 'rule',
                           f'name=AllowPort{port}', 'dir=in', 'action=allow', f'protocol=TCP', f'localport={port}'])
            print(
                f"Firewall rule added to allow incoming traffic on port {port}.")
        else:
            print(f"Firewall rule for port {port} already exists.")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == '__main__':
    # Specify the port you want to open in the firewall
    target_port = 5163

    # Add firewall rule for the specified port
    add_firewall_rule(target_port)
