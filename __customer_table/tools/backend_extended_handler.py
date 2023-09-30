from pewee_sql_handler import update_customer
import logging
from pathlib import Path

def process_pewee_update(form_data):
    try:
        # Get form data
        id = form_data["customerID"]
        update_data = {}
        for key, val in form_data.items():
            if not key.startswith("_"):
                update_data.update({key: val})
    
        updated_customer = update_customer(int(id), update_data)
        
        if updated_customer:
            # Successful update, redirect to another page
            return True
        else:
            # Customer not found, handle the error (e.g., display an error message)
            return "\n\nCustomer not found\n\n"
    except Exception as e:
        # Handle any exceptions (e.g., database errors)
        logging.error(f"Error updating customer: {str(e)}")
        return "\n\nAn error occurred while updating the customer\n\n"
    
    
def style():
    return "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"

def fix_env(runtime, filename, environ, divider):
        
    if runtime.exists() or (filename != "main.py"):
        environ["PYTHONNET_PYDLL"] = str(runtime.resolve())
        environ["BASE_DIR"] = str(Path.cwd().resolve())
        environ["PATH"] = str(Path.cwd().resolve())
        print(f"{divider}!Environ updated :) {divider}")
    else:
        print(f"{divider}!Didn't update environ!{divider}")
    return environ