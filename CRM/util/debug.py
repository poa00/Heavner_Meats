from jsons import dumps, loads
from pathlib import Path

def writeDebug():
    path = Path(Path.cwd() / "debug.json")
    debug = {"debug": True}
    with open(path, "w") as f:
        f.write(dumps(debug))
        
def readDebug():
    try:
        if Path(Path.cwd() / "debug.json").exists():
            with open("debug.json", "r") as f:
                contents = f.read()
            debug = loads(contents)
            return debug["debug"]
        else:
            return False
    except Exception as e:
        writeDebug()
        return False
    
    

if __name__ == "__main__":
    answer = readDebug()
    print(answer)