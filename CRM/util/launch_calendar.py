from pathlib import Path
from jsons import dumps
import subprocess
from time import sleep
from util.trace_error_handling import er

def launch_calendar(customer):
    """
    Launch the calendar application and wait for it to finish.
    
    Args:
        customer (Customer): The customer to schedule.
    """    
    
    working_directory = look_for_exe(Path.cwd().parent, "calendarSimple.ahk")
    if working_directory == False:
        working_directory = look_for_exe(Path.cwd().parent.parent, "calendarSimple.ahk")
        
    
    exe_path = working_directory / r'calendarSimple.ahk'
    log_path = working_directory / r'calendar_log.txt'
    data_path = working_directory / r'pendingEvent.json'
    cmd_path = working_directory / r'run.cmd'
    
    with open(data_path, 'w') as f:
        f.write(dumps(customer))
    with open(log_path, 'w') as f:
        f.write('')
    with open(cmd_path, "w") as f:
        f.write(f"{exe_path}\n")

    subprocess.run([cmd_path], cwd=working_directory)
    
    while not log_path.exists():
        # Do something else here, like processing other files or waiting for user input
        sleep(0.1)
        
    log = ""
    while 'true' not in log:
        with open(log_path, 'r') as f:
            log = f.read()
            
        if 'true' in log:
            # found the string 'true' in the log file, so the calendar app was successful
            print('Done!')
            return True
        sleep(0.1)
        
        
def look_for_exe(start_path, file_name):
    for path in start_path.rglob(f"{file_name}"):
        if path.is_file():
            return path.parent
        else:
            return False
