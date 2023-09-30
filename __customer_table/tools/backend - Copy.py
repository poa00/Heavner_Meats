from time import sleep
from pathlib import Path

c = Path.cwd() / "python310.dll"

print(str(c.resolve()))

sleep(10)