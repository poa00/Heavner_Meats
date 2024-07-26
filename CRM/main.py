from pathlib import Path
from pythonnet import set_runtime
set_runtime("netfx")

from os import environ
from pathlib import Path
from util._extend_backend import style_msg, fix_env

runtime = Path.cwd() / "python310.dll"
environ = fix_env(runtime, Path(__file__).name, environ, style_msg("loading env"))

from util._port import get_available_port
from util.trace_error_handling import er
from flask import Flask, render_template, jsonify, request
from jinja2 import ext
import webview
from jsons import dumps, loads
# import util.PEWEE_model as PEWEE_model
from flask_backend import flask_thread
from javascript_api import JavascriptAPIHandler, read_debug_setting
from util.progress_bar_mang import simple_prog_bar
from pyweb_thread import pywebview_thread

################################################
################################################

# rerun calendar
# copy from profileViewEdit

################################################
################################################

# Constants
PORT = get_available_port()
cwd = Path.cwd()
WEBVIEW_WIDTH = 1500
WEBVIEW_HEIGHT = 950


def main():
    """
    Main function calls flask from `flask_backend.py`, and pywebview in the `pyweb_thread.py` file."""
    global cwd
    cwd = Path.cwd()
    
    flask_thread(PORT)
    
    print(style_msg("starting pywebview"))
    simple_prog_bar("loading flask")
    
    window = pywebview_thread(PORT, WEBVIEW_WIDTH, WEBVIEW_HEIGHT)
    try:
        webview.start()
    except Exception as e:
        er(e)
    
if __name__ == "__main__":
    main()