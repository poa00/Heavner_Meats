import serial
import requests
import time
import retrieve_endpoint
import readCOM
import json

def postSend(decodedStr, url):
    requests.post(f'{url}', json=json.dumps({'data':decodedStr}), 
                  headers={"ngrok-skip-browser-warning":"True"})

if __name__ == "__main__":
    endpointDic = retrieve_endpoint.get_endpoint()
    print(str(endpointDic))
    while True:
        time.sleep(1)
        decodedLine = readCOM.withSerialOpenRead()
        postSend(readCOM.split_weight(decodedLine), endpointDic['url'])
        """ try:
            decodedLine = testReadCOM.withSerialOpenRead()
            postSend(decodedLine, endpointDic['url'], endpointDic['port'])
        except Exception as e:
            print(str(e))
            try:
                endpointDic = retrieve_endpoint.get_endpoint()
            except Exception as e:
                print(str(e))
                continue"""


