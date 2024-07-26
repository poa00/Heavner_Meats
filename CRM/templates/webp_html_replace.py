from pathlib import Path
import shutil 

lookfor = "href=\"assets/"
replacement = "href=\"/static/assets/"
# "href="assets/"
for file in Path.cwd().iterdir():
  if file.suffix == ".html":
    with open(file, "r", errors="ignore") as f:
      file_contents = f.readlines()
    for line in file_contents:
      if lookfor in line:
        line.replace(lookfor, replacement)