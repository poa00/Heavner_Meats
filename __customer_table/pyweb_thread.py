# detect where index and template folder is 
import webview
from javascript_api import JavascriptAPIHandler, read_debug_setting
from util.trace_error_handling import er

def pywebview_thread(PORT, WEBVIEW_WIDTH, WEBVIEW_HEIGHT):
    """ * ` read Debug cfg `
        * ` start pywebview window `"""
    global window
    try:
        api = JavascriptAPIHandler(PORT)
        window = webview.create_window('Search Table', f'http://127.0.0.1:{PORT}',  
                                       width=WEBVIEW_WIDTH, height=WEBVIEW_HEIGHT, js_api=api)
        api.set_window(window)
        webview.start()
    except Exception as e:
        print(f"Error while creating webview: {e}")
        er(e)
    return window

if __name__ == "__main__":
    pywebview_thread(PORT=5115, WEBVIEW_WIDTH=1200, WEBVIEW_HEIGHT=900)

