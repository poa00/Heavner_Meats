@echo off
SETLOCAL EnableDelayedExpansion

:: Specify URLs for Python and Git
set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe
set autohotkeyV2exe=https://www.autohotkey.com/download/ahk-v2.exe

:: Specify installer file names
set PYTHON_INSTALLER=python_installer.exe
set ahk_INSTALLER=ahk-v2.exe

:: Download Python
echo Downloading Python...
curl -L %PYTHON_URL% -o %PYTHON_INSTALLER%

:: Download Git
echo Downloading Git...
curl -L %autohotkeyV2exe% -o %ahk_INSTALLER%

:: Install Python silently and add to PATH
echo Installing Python...
start /wait "" %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1

:: Install Git silently
echo Installing Git...
start /wait "" %ahk_INSTALLER% /VERYSILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

:: Verify installations
echo Verifying Python installation...
python --version
if %errorlevel% neq 0 (
    echo Python installation failed or not added to PATH.
) else (
    echo Python installed successfully.
)

echo Verifying Git installation...
git --version
if %errorlevel% neq 0 (
    echo Git installation failed or not added to PATH.
) else (
    echo Git installed successfully.
)

:: Cleanup installer files
echo Cleaning up...
del %PYTHON_INSTALLER%
del %ahk_INSTALLER%

echo Installation scripts have finished.
ENDLOCAL