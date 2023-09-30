from flask import Flask, render_template, jsonify, request
from jinja2 import ext

from pythonnet import load
load("netfx")

import clr

from pathlib import Path
import webview
from jsons import dumps, loads
import PEWEE_model
from backend import flask_thread
from javascript_api import JavascriptAPIHandler, read_debug_setting
from debug import readDebug

# Constants
PORT = 5151
cwd = Path.cwd()
WEBVIEW_WIDTH = 1500
WEBVIEW_HEIGHT = 950


###############todo####################
"""
write customer to json
load into ahk load

write try catch for flask
"""
###############todo####################


def pywebview_thread():
    """ * ` read Debug cfg `
        * ` start pywebview window `"""
    global window
    try:
        api = JavascriptAPIHandler(PORT)
        window = webview.create_window('Search Table', f'http://127.0.0.1:{PORT}',  
                                       width=WEBVIEW_WIDTH, height=WEBVIEW_HEIGHT, js_api=api)
        api.set_window(window)
    except Exception as e:
        print(f"Error while creating webview: {e}")
    return window

        
def main():
    """Main function calls flask from `backend.py`, and pywebview in this file"""
    global cwd, window
    cwd = Path.cwd()
    flask_thread(PORT)
    window = pywebview_thread()
    webview.start(debug=readDebug())
    
if __name__ == "__main__":
    main()