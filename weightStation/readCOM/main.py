from flask import Flask, request
from flask_restful import Resource, Api
import datetime
import json
import requests


app = Flask(__name__)
api = Api(app)

todos = {}


def get_public_ip():
    try:
        # Use a service that echoes the client's IP address
        response = requests.get('https://api64.ipify.org?format=json')
        data = response.json()
        public_ip = data['ip']
        return public_ip
    except Exception as e:
        return f"Error: {e}"
    

class addResources(Resource):
    def post(self):
        try:
            data = request.get_json()

            if data:
                timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                ip_address = get_public_ip()

                todo_item = {
                    'data': data,
                    'timestamp': timestamp,
                    'ip_address': ip_address
                }

                todos.append(todo_item)

                with open('log.txt', 'a') as log_file:
                    log_file.write(json.dumps(todo_item) + '\n')

                return {'message': 'Data saved successfully'}, 201
            else:
                return {'error': 'No JSON data provided'}, 400

        except Exception as e:
            return {'error': f'An error occurred: {str(e)}'}, 500


class HelloWorld(Resource):
    def get(self):
        return {'hello': 'nicks Mom'}


api.add_resource(addResources, '/json')
api.add_resource(HelloWorld, '/')


if __name__ == '__main__':
    print(get_public_ip())
    print("npx localtunnel --port 8080")
    app.run(host='localhost', port='8080')
