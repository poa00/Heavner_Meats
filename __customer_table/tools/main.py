from pathlib import Path
from pythonnet import set_runtime
set_runtime("netfx")

from os import environ
from pathlib import Path
from backend_extended_handler import style, fix_env

runtime = Path.cwd() / "python310.dll"
filename = Path(__file__).name
environ = fix_env(runtime, filename, environ, style())

from util.trace_error_handling import er
from flask import Flask, render_template, jsonify, request
from jinja2 import ext
from time import sleep
import webview
from jsons import dumps, loads
import PEWEE_model
from backend import flask_thread
from javascript_api import JavascriptAPIHandler, read_debug_setting
from util.debug import readDebug
from util.progress_bar_mang import simple_ten

# Constants
PORT = 5753
cwd = Path.cwd()
WEBVIEW_WIDTH = 1500
WEBVIEW_HEIGHT = 950



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
    divider = style()
    print(f"\n\n{divider}loading library, please chill{divider}")
    simple_ten()
    window = pywebview_thread()
    try:
        webview.start(gui='gtk')
    except Exception as e:
        er(e)
    
if __name__ == "__main__":
    main()