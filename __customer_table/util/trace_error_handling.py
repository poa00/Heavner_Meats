import traceback
from os import environ
from time import sleep
from util.progress_bar_mang import ProgressBarManager as b

def envo():
    msg = environ["PYTHONNET_PYDLL"]
    print("dumping, there was an error:")
    for key, val in environ.items():
        msg += f"\n{key} \t=> \t{val}"
    print(f"\n\nthis is the environ =>{msg}\n\n")
    print(f"\n\nthis is the environ =>{msg}\n\n")
    with open("environ.txt", "w") as f:
        f.write(msg)
        
    print(str(f"\n\nyou're seeing an error. expect a report in 10 seconds\n"))
    pg = b("error", max=10)
    pg.start()
    for i in range(10):
        sleep(1)
        pg.next()
    

def er(e): 
    msg = f"An error occurred: {e}"  
    envo()
    raise Exception(msg) from e

def throw(string):
    try:
        x = 2 / 0 
    except Exception as e:
        er(f"{e}\nstring")