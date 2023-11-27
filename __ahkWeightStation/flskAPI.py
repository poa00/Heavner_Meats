from flask import Flask, request, jsonify

app = Flask(__name__)

# Sample in-memory data store (replace with a database in a real application)
data_store = []

# Log file path
log_file_path = 'api_log.txt'

# Endpoint to handle POST requests
@app.route('/', methods=['POST'])
def post_data():
    try:
        # Get JSON data from the request
        json_data = request.get_json()

        # Log the JSON data to a file
        with open(log_file_path, 'a') as log_file:
            log_file.write(str(json_data) + '\n')

        # Add data to the in-memory data store (replace with database interaction)
        data_store.append(json_data)

        return jsonify({"message": "Data received successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Endpoint to handle GET requests
@app.route('/api/data', methods=['GET'])
def get_data():
    try:
        return jsonify(data_store), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
