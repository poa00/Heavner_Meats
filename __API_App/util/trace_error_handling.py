import traceback
from os import environ
from time import sleep

def envo():
    print("dumping, there was an error:")
    print(str(f"\n\nyou're seeing an error. expect a report in 10 seconds\n"))
    for i in range(10):
        sleep(1)
    

def er(e): 
    """
    param example:
    try:
        x = 2 / 0
    except Exception as e:
        er(e)"""
    msg = f"\nAn error occurred: {e}"  
    with open("error_log.txt", "a") as f:
        f.write(str(e))
    envo()
    raise Exception(msg) from e

def throw(string):
    try:
        x = 2 / 0 
    except Exception as e:
        er(f"{e}\nstring")
        
        
def verbose_print(error=False, *args):
    if error:
        msg = "no-error print"
    else:
        msg = "error print"
    for i in args:
        print(f"\n{msg}: {i}\n\n")