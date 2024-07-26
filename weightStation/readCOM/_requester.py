import requests
import retrieve_endpoint
import json

# def ssl_handler():
#     """
#      Create a PoolManager that uses SSL for requests. This is useful for development and to use the SSLv3 protocol in the URL.
     
     
#      @return A : class : ` urllib3. PoolManager ` with SSL enabled and a custom SSL context. : 0.
#     """
#     # Create a custom SSL context with SSL 1.0
#     ssl_context = ssl.SSLContext(ssl.PROTOCOL_SSLv3)

#     # Disable SSL/TLS warnings (not recommended for production)
#     urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

#     return urllib3.PoolManager(ssl_context=ssl_context)
#     # Create a custom PoolManager with the specified SSL context
     


def postSend(decodedStr, url, port):
    """
     Send a string to a URL. This is a convenience function to use in tests that want to send data to an HTTP server that doesn't support HTTP POST.
     
     @param decodedStr - The string to send. Should be utf - 8 encoded
     @param url - The URL to send the data to.
     @param port - The port to send the data to. If this is 0 it will use the default port
    """
    print(json.dumps({'data':decodedStr}))
    return requests.post(f'{url}', json=json.dumps({'data':decodedStr}))


if __name__ == "__main__":
    # This is a test function. It will send a string to the URL specified in the command line arguments.'
    endpointDic = retrieve_endpoint.get_endpoint()
    print(postSend("decodedLine", endpointDic['url'], endpointDic['port']))
    
