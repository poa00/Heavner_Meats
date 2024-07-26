import requests
import json

url = "http://127.0.0.1:5613/animals/27/"  # Assuming event ID 1, adjust the URL accordingly

data = {
    "species": "Cow",
    "gender": "Male",
    "is_over_30_months": True,
    "organs": "Complete",
    "comments": "No comments",
    "cutsheet": "Sample cutsheet data",
    "live_weight": 1500,
    "manual_entry_weight": 1400,
    "ear_tag": "ETAG123"
}

response = requests.post(url, json=data)

print(response.json())