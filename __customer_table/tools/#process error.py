#process error

import subprocess
import time

def run_child_process():
    try:
        # Replace 'child_script.py' with the name of your child script and its arguments
        subprocess.run(['python', 'child_script.py'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Child process exited with an exception: {e}")
        return False
    return True

def main():
    while True:
        print("Starting child process...")
        if run_child_process():
            print("Child process completed successfully.")
        else:
            print("Restarting child process...")
        time.sleep(1)  # Adjust the sleep time as needed

if __name__ == "__main__":
    main()
