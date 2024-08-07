from pewee_sql_handler import create_customer, delete_customer, read_customer
from util.trace_error_handling import er
from util.launch_calendar import launch_calendar
from util._requests import post


class JavascriptAPIHandler:
    """
    Call Python from JavaScript using this handler.
    """
    def __init__(self, port):
        """
        Initialize the JavascriptAPIHandler instance.
        
        Args:
            port (int): The port number to use.
        """
        self.port = port
        self.window = ""
    

    def set_window(self, window):
        """
        Set the window attribute.
        
        Args:
            window (str): The window to set.
        """
        self.window = window
        
        
    def load_page(self, page_name):
        """
        Load a page in the window. http://127.0.0.1:{self.port}/{page_name}
        
        Args:
            page_name (str): The name of the page to load.
        
        """
        self.window.load_url(f'http://127.0.0.1:{self.port}/{page_name}')
    
    
    def submit_new_customer(self, data):
        """
        Submit a new customer record.
        
        Args:
            name (str): Customer's full name.
            email (str): Customer's email address.
            phone (str): Customer's phone number.
            address (str): Customer's billing address.
            details (str): Additional customer details.
        """
        self.requests(data, "customers", "create")
        self.load_page("")
        
        
    def requests(self, jdata, app, operation):
        post(jdata, app, operation)
        return True
    
    def deleteCust(self, jdata, app, operation):
        post(jdata, app, operation)
        self.window.evaluate_js('window.location.reload()')
        return True
        
    def update_customer(self, data, customers, update):
        post(data, customers, update)
        self.load_page("")
    
    
    def send_delete_customer(self, id):
        """
        Send a request to delete a customer by ID.
        
        Args:
            id (int): The customer ID to delete.
        """
        how_to_post = str(f"/deleteCustomer?customerID={id}")
        self.load_page(how_to_post)
        
        
    def profile_view_edit(self, id):
        """
        Send a request to delete a customer by ID.
        ==> view ==> edit ==> @ def processUpdate ==> index

        
        Args:
            id (int): The customer ID to delete.
        """
        how_to_post = str(f"/profileViewEdit?customerID={id}")
        self.load_page(how_to_post)
        
        
    def confirm_delete(self, id):
        """
        Confirm the deletion of a customer by ID.
        
        Args:
            id (int): The customer ID to confirm deletion for.
        """
        delete_customer(id)
        self.load_page("")
        
        
    def schedule_customer(self, id):
        """
        Schedule a customer by ID.
        
        Args:
            id (int): The customer ID to schedule.
        """
        #how_to_post = str(f"/scheduleCustomerPost?customerID={id}")
        #self.load_page(how_to_post)
        customer = post({"customerID":id}, "customers", "read")
        try:
            launch_calendar(customer)
        except Exception as e:
            er(e)
        
        
    def alert_box(self, string):
        self.window.evaluate_js(f'showAlert("{string}")')
        #show_dark_alert(string)
        
        
    def throw(self):
        er("Error thrown from JavascriptAPIHandler")
        

def read_debug_setting(DEBUG_CFG_FILE, API_Settings):
    """
    Read the debug setting from a configuration file.
    
    Args:
        DEBUG_CFG_FILE (Path): The path to the debug configuration file.
        API_Settings: Not defined in the code, assumed to be a parameter.

    Returns:
        bool: True if debug mode is enabled, False otherwise.
    """
    try:
        if DEBUG_CFG_FILE.exists():
            with open(DEBUG_CFG_FILE, "r") as f:
                contents = f.read()
            return contents.split("==")[1].capitalize() == "True"
    except (FileNotFoundError, IndexError):
        return False

def error_handler(e):
    """
    Handle errors and write them to a file.

    Args:
        e: The error message or object to write to the file.
    """
    with open("errors.txt", "a", errors="replace") as f:
        f.write(str(e))
