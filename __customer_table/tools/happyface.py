import requests
from time import sleep

API_URL = "https://api-inference.huggingface.co/models/WizardLM/WizardLM-70B-V1.0"
headers = {"Authorization": "Bearer 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"}

def query(question):
	payload = {
		"inputs": question}
	response = requests.post(API_URL, headers=headers, json=payload)
	return response.json()
	



if __name__ == "__main__":

	output = query("whats the weather like in fiji?")

	print(str(output))
	sleep(10)