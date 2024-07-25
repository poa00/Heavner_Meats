import traceback
from os import environ
from time import sleep
import sys

def er(e): 
    """
    Logs the error message to a file and raises an exception with a verbose message.

    Args:
        e (Exception): The exception object to be logged and raised.

    Raises:
        Exception: An exception with a verbose message.

    """
    x = traceback.format_exc(e)
    with open("error_log.txt", "a") as f:
        f.write(x)

    envo()
    raise Exception(verbose_print(f"\nAn error occurred: {x}")) from e

def throw(string):
    try:
        x = 2 / 0 
    except Exception as e:
        x = traceback.format_exc(e)
        er(f"{x}\nstring")
        
        
def verbose_print(error=False, *args):
    """
    Prints the given arguments with a message indicating whether it's an error print or not.

    Args:
        error (bool): Whether the print is an error print or not. Defaults to False.
        *args: Variable length argument list of items to print.

    Returns:
        str: The concatenated string of all the printed items.
    """
    if error:
        msg = "verbose print var: "
    else:
        msg = "error print: "
    line = ""
    for i in args:
        line += f"\n@@@@@@@@@@@@@@@@@@@@@@@\n{msg}: {i}\n@@@@@@@@@@@@@@@@@@@@@@@\n"
    sys.stdout.write(line)
    sys.stdout.flush()
    return line
    
    
def envo():
    verbose_print(str(f"\n\nthe app experienced an error. expect a report in error_log.txt next to this app. \n"))