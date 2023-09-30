from jsons import dumps, loads
from pathlib import Path

def writer():
    settings = {"debug": True}
    jdata = dumps(settings)
    with open("debug.json", "w") as f:
        f.write(jdata)
        
def reader(cwd, customerID):
    with open(Path(cwd / "customers.json"), "r") as f:
        jdata = f.read()
    customers = loads(jdata)
    
    print(customers[str(customerID)])

if __name__ == "__main__":
    cwd = Path.cwd()
    reader(cwd)