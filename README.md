```
from fastapi import FastAPI, HTTPException, Body
from fastapi.responses import JSONResponse
import json as _json
import socket
import uvicorn
import requests

app = FastAPI()

# In Flask, the equivalent would be:
# from flask import Flask, request
# app = Flask(__name__)


def get_public_ip():
    try:
        # Use a service that echoes back the client's public IP address
        response = requests.get('https://api64.ipify.org?format=json')

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response and extract the public IP address
            public_ip = response.json()['ip']
            return public_ip
        else:
            # If the request was not successful, raise an exception
            response.raise_for_status()
    except Exception as e:
        # Handle exceptions (e.g., network issues, invalid response)
        print(f"Error getting public IP: {e}")
        return None


# This endpoint handles POST requests to the root URL ("/").


@app.post("/")
async def read_root(message: str):
    # In Flask, the equivalent would be:
    # message = request.json.get('message')

    # Print the incoming message
    print(f"Incoming Message: {message}")

    # Return a dictionary as the response
    return {"message_received": message}

# If you want to handle different HTTP methods, you can use decorators like in Flask.
# For example, this endpoint handles GET requests to the path "/greet/{name}".


@app.get("/greet/{name}")
async def greet(name: str):
    # In Flask, the equivalent would be:
    # name = request.view_args['name']

    greeting = f"Hello, {name}!"

    # Print the greeting
    print(f"Greeting: {greeting}")

    # Return a dictionary as the response
    return {"greeting": greeting}


# Endpoint to handle JSON data, save it to a log file, and print the IP address
@app.post("/json")
async def json(data: dict = Body(...)):
    try:
        # In Flask, the equivalent would be:
        # data = request.json

        # Print the incoming JSON data
        print("Incoming JSON Data:")
        print(_json.dumps(data, indent=2))

        # Save the JSON data to a local log file
        with open("log_file.txt", "a") as log_file:
            log_file.write(_json.dumps(data) + "\n")

        # Return a JSON response
        return JSONResponse(content={"message": "JSON data processed successfully"})
    except Exception as e:
        # Handle exceptions and return an error response
        return HTTPException(status_code=500, detail=str(e))

```
