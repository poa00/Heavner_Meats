
from pythonnet import set_runtime
set_runtime("netfx")
from os import environ
from pathlib import Path
runtim = Path.cwd() / "python310.dll"

if runtim.exists():
    environ["PYTHONNET_PYDLL"] = str(runtim.resolve())
    environ["BASE_DIR"] = str(Path.cwd().resolve())


import webview
from time import sleep
# Get all environment variables as a dictionary


def third_window():
    # Create a new window after the loop started
    third_window = webview.create_window('Window #3', html='<h1>Third Window</h1>')


if __name__ == '__main__':
    # Master window
    master_window = webview.create_window('Window #1', html='<h1>First window</h1>')
    second_window = webview.create_window('Window #2', html='<h1>Second window</h1>')
    webview.start(third_window)
