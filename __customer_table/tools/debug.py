from jsons import dumps, loads
from pathlib import Path

def writeDebug():
    debug = {"debug": True}
    with open(Path(Path.cwd() / "debug.json"), "w") as f:
        f.write(dumps(debug))
        
def readDebug():
    try:
        with open("debug.json", "r") as f:
            contents = f.read()
        debug = loads(contents)
        return debug["debug"]
    except Exception as e:
        writeDebug()
        return False
    
if __name__ == "__main__":
    answer = readDebug()
    print(answer)