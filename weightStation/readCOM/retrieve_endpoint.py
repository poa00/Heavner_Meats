# https://raw.githubusercontent.com/samfisherirl/Heavner_Meats/main/__API_App/util/url.json
import requests
import subprocess
import os
url = "https://raw.githubusercontent.com/samfisherirl/Heavner_Meats/main/__API_App/deets.json"


def get_endpoint():
    """
     Get endpoint from API. This is used to connect to the API. The URL is returned as a dictionary with keys : url and port
     
     
     @return False if there was an
    """
    try:
        response = requests.get(url)
        return {'url': response.json()["url"], 'port': response.json()["port"]}
    except Exception as e:
        print(str(e))
        return False
    

def run_windows_terminal_cmd(command):
    """
     Runs a command on Windows terminals. This is a workaround for Windows bug #4293.
     
     @param command - The command to run on Windows terminals. Example :
    """
    try:
        subprocess.Popen(["cmd.exe", "/c", command], shell=True,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except Exception as e:
        print(f"Error: {e}")


def close_terminal():
    """
     Kill the command prompt and close the terminal. This is used in conjunction with close_shell () to clean up
    """
    try:
        # Kill the command prompt process
        os.system("taskkill /f /im cmd.exe")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    #ngrok http 8080
    endpoint = get_endpoint()
    # Run ngrok http on the endpoint if endpoint is not False or empty
    if endpoint != False or endpoint != "":
        run_windows_terminal_cmd(f"ngrok http {endpoint['port']}")
    