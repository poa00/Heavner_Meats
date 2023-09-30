from PyInstaller import setup
from PyInstaller.utils.hooks import collect_data_files
from PyInstaller.utils.hooks import collect_submodules
from PyInstaller.utils.hooks import copy_metadata


hidden_imports = [
    'clr_loader',
    'pythonnet',
    'webview',
]

datas = [
    # Include WebBrowserInterop DLLs
    ('C:\\Users\\dow\\Desktop\\test_py_folder\\venv\\Lib\\site-packages\\webview\\lib\\WebBrowserInterop.x64.dll', './'),
    ('C:\\Users\\dow\\Desktop\\test_py_folder\\venv\\Lib\\site-packages\\webview\\lib\\WebBrowserInterop.x86.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\clr_loader\\ffi\\dlls\\amd64', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\webview\\lib\\Microsoft.Web.WebView2.Core.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\webview\\lib\\Microsoft.Web.WebView2.WinForms.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\webview\\lib\\runtimes\\win-x64\\native\\WebView2Loader.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\webview\\lib\\runtimes\\win-armx64\\native\\WebView2Loader.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\webview\\lib\\runtimes\\win-x86\\native\\WebView2Loader.dll', './'),
    ('C:\\Users\\dow\\AppData\\Local\\Programs\\Python\\Python39\\Lib\\site-packages\\pythonnet\\runtime\\Python.Runtime.dll', './'),
    
    # Include templates and static folders
    ('templates', './templates'),
    ('static', './static'),

    # Include required DLLs
    ('C:\\Users\\dow\\Desktop\\test_py_folder\\venv\\Lib\\site-packages\\webview\\lib\\Microsoft.Web.WebView2.Core.dll', './'),
    ('C:\\Users\\dow\\Desktop\\test_py_folder\\venv\\Lib\\site-packages\\webview\\lib\\Microsoft.Web.WebView2.WinForms.dll', './'),

    # Include your database file
    ('mydatabase.db', './'),
]

hiddenimports = [
    'clr_loader',
    'pythonnet',
    'webview',
]

excluded_modules = [
    'tkinter',
]

# You can add more options here as needed

setup(
    name="__TEMeats__",
    version="1.0",
    description="Your application description",
    options={
        'pyinstaller_hooks_contrib': {
            'hiddenimports': hidden_imports,
            'excludedimports': excluded_modules,
            'collect_data_files': collect_data_files,
        }
    },
    executables=[
        Executable('main.py', base=None)
    ]
)