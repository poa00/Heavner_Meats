import requests

r = requests.get('https://786c-45-14-195-179.ngrok-free.app/',
                 headers={'ngrok-skip-browser-warning': 'true'})
print(str(r.text))