from pathlib import Path
import shutil 

lookfor = "href=\"assets/"
jslookfor = "src=\"assets"
replacement = "href=\"/static/assets/"
jsreplacement = "src=\"/static/assets/"
# "href="assets/"
for file in Path.cwd().rglob("*"):
  if file.suffix == ".html":
    with open(file, "r", errors="ignore") as f:
      file_contents = f.readlines()
    new_file_contents = []
    for line in file_contents:
      if lookfor in line:
        line = line.replace(lookfor, replacement)
      if jslookfor in line:
        line = line.replace(jslookfor, jsreplacement)
      new_file_contents.append(line)
    with open(file, "w", errors="ignore") as f:
      f.write("".join(new_file_contents))