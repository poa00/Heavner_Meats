import csv
from pathlib import Path
from jsons import dumps, loads

cwd = Path.cwd()
custj = cwd / "exported_data.json"

class Customer: 
    last_id = 0
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
        self.customerID = Customer.define_id(customerID)
        
    def __str__(self):
        return f"{self.full_name}, {self.telephone}, {self.email}"
    
    @staticmethod
    def define_id(id):
        return int(id) if id.isdigit() else id
        
    
def csv_exist(file, cwd):
    if not file.exists():
        file = look_for_csv(cwd)
        if not file.exists():
            return False
    return True
    
    
def look_for_csv(cwd):
    for file in cwd.rglob("*"):
        if file.suffix == "csv":
            if "customer" in file.name:
                return file
            
            
def csv_read(file):            
    customers = {}
    with open(file, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader) # Skip the header row
        
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
            customers.update({customer.customerID: customer})
            if type(customer.customerID) == "int":
                Customer.last_id = customer.customerID
    return customers

def load_customers():
    """ Load customers from CSV file. 
        @return A list of : class : `list[0].full_name` """
    
    file = Path(cwd / "customers.csv")
    if not csv_exist(file, cwd):
        return []
    return csv_read(file)


class CustomersJson:
    def __init__(self, cwd):
        self.cwd = cwd
        self.file = Path(custj)
        
    def read_json(self):
        with open(self.file, "r") as f:
            string = f.read()
        return string

    def load_customers(self):
        """ Load customers from json file. 
            @return A dict of : class : `dict[id].telephone` """
        return loads(self.read_json())
    
    def write_csv_to_json(self):
        obj = load_customers()
        jdata = dumps(obj)
        with open(custj, "w") as f:
            f.write(jdata)
            
    def update_customers(self, __id, key, value):
        customerObj = self.load_customers()
        customerObj[str(__id)][str(key)] = value
        jsonString = dumps(customerObj)
        with open(custj, "w") as f:
            f.write(jsonString)
            
    def get_customer(self, dic, __id):
        return dic[str(__id)]

    def remove_customer(self, dic, __id):
        del dic[str(__id)]
        jdata = dumps(dic)
        with open(custj, "w") as f:
            f.write(jdata)


if __name__ == "__main__":
    obj = CustomersJson(cwd)
    # obj.write_csv_to_json()
    
    dic = obj.load_customers()
    id = 10010
    # obj.get_customer(dic, id)
    
    for key, val in dic.items():
        print(f'{key} =>\n{val}\n\n')
    # jsonString = jsons.dumps(customers)
    # with open("customers.json", "w") as f: 
    #     f.write(jsonString)
    
    