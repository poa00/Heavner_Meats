import subprocess

# Define a list of commands you want to run
commands = [
    "dir",
    "echo Command 1 has finished",
    "ipconfig /all",  # Example with a network-related command
    "echo Command 2 has finished",
]

# Iterate through the list of commands and run each one
for cmd in commands:
    print(f"Running command: {cmd}")
    
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()  # Wait for the command to finish
    
    # Print the output and error, if any, from the command
    print(f"Output:\n{stdout.decode('utf-8')}")
    print(f"Error:\n{stderr.decode('utf-8')}")
    
    print(f"Command finished: {cmd}\n")
