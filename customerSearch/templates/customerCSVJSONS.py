import csv
from pathlib import Path

class Customer: 
    def __init__(self, full_name, telephone, fax, mobile, email, billing_address, billing_city, billing_state, 
                 billing_zip, billing_country, shipping_address, shipping_city, shipping_state, shipping_zip, customerID):
        self.full_name = full_name
        self.telephone = telephone
        self.fax = fax
        self.mobile = mobile
        self.email = email
        self.billing_address = billing_address
        self.billing_city = billing_city
        self.billing_state = billing_state
        self.billing_zip = billing_zip
        self.billing_country = billing_country
        self.shipping_address = shipping_address
        self.shipping_city = shipping_city
        self.shipping_state = shipping_state
        self.shipping_zip = shipping_zip
        self.customerID = int(customerID) if customerID.isdigit() else customerID

    def __str__(self):
        return f"{self.full_name}, {self.telephone}, {self.email}"
    
    
def csv_exist(file):
    if not file.exists():
        file = look_for_csv(cwd)
        if not file.exists():
            return False
    return True
    
    
def look_for_csv(cwd):
    """iterate through all files recursively in cwd, find customers.csv"""
    for file in cwd.rglob("*.csv"):
        if "customer" in file.name:
            return Path(str(file))
            

def load_customers(cwd):
    """Load customers from CSV file. This function is called by the scripting environment to load a list of customers
        @return A list of : class : `list[0].full_name`"""
    customers = []
    customersJson = {}
    file = Path(cwd / "customers.csv")
    if not csv_exist(file):
        return customers
    with open(file, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader) # Skip the header row
        
        for row in reader:
            customer = Customer(*row[:14], row[15])
            customers.append(customer)
            customersJson[customer.customerID] = customer
    with open("customers.json", "w", errors="replace", newline='') as f:
        fieldnames = ["full_name", "telephone", "fax", "mobile", "email", "billing_address", "billing_city",
                      "billing_state", "billing_zip", "billing_country", "shipping_address", "shipping_city",
                      "shipping_state", "shipping_zip", "customerID"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(customersJson.values())

    return customers

if __name__ == "__main__":
    cwd = Path.cwd()
    customers = load_customers(cwd)
    for customer in customers[:5]:
        print(customer.customerID)

    