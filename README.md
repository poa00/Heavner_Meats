NGROKHOWTO

ngrok

https://gist.github.com/YamiOdymel/d0337a6be3b2f1297c9eeab6c196fcb7

Set and send an `ngrok-skip-browser-warning` request header with any value.

sudo apt-get update
sudo apt-get install unzip wget
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ./ngrok /usr/bin/ngrok
ngrok http 8080
