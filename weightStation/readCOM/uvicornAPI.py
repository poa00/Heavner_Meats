# main.py
import json as _json
import uvicorn
from fastapi import HTTPException
from fastAPI import app
import fasterAPI
import requests

def get_public_ip():
    try:
        response = requests.get('https://api64.ipify.org?format=json')
        if response.status_code == 200:
            public_ip = response.json()['ip']
            return public_ip
        else:
            response.raise_for_status()
    except Exception as e:
        print(f"Error getting public IP: {e}")
        return None


def serve():
    uvicorn.run(app, host="0.0.0.0", port=5614)


if __name__ == "__main__":
    line = "@@@@@@@@@@@@@@@@@@@@@@\n" + get_public_ip() + "\n@@@@@@@@@@@@@@@@@@@@@@"
    print(line)
    serve()
