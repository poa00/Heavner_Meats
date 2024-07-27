@echo off
for %%f in (*.7z) do (
    "7za.exe" x "%%f" -o"%userprofile%\documents\autohotkey\lib\"
)