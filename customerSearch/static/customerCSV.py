import csv
from pathlib import Path


class Customer: 
    def __init__(self, full_name, telephone, fax, mobile, email, billing_address, billing_city, billing_state, billing_zip, billing_country, shipping_address, shipping_city, shipping_state, shipping_zip, customerID):

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
        self.customerID = customerID

    def __str__(self):
        return f"{self.full_name}, {self.telephone}, {self.email}"
    
    
def look_for_csv(cwd):
    for file in cwd.rglob("*"):
        if file.suffix == ".csv":
            if "customer" in file.name:
                return str(file)
def load_customers(cwd):
    """
     Load customers from CSV file. This function is called by the scripting environment to load a list of customers
     @return A list of : class : `list[0].full_name` 
    """
    customers = []
    file = Path(cwd / "customers.csv")
    if not file.exists():
        file = look_for_csv(cwd)
        if not file.exists():
            return customers
    with open(file, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader) # Skip the header row
        # Create a new Customer object from the reader.
        for row in reader:
            customer = Customer(
                full_name=row[0],
                telephone=row[1],
                fax=row[2],
                mobile=row[3],
                email=row[4],
                billing_address=row[5],
                billing_city=row[6],
                billing_state=row[7],
                billing_zip=row[8],
                billing_country=row[9],
                shipping_address=row[10],
                shipping_city=row[11],
                shipping_state=row[12],
                shipping_zip=row[13],
                customerID=row[15]
            )
            customers.append(customer)

    # (self, full_name, telephone, fax, mobile, email, billing_address, billing_city, billing_state, billing_zip.)
    return customers

if __name__ == "__main__":
    customers = load_customers()
    for customer in customers[:5]:
        print(customer.full_name)
    
    