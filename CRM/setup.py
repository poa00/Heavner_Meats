from cx_Freeze import setup, Executable

# Dependencies are automatically detected, but it might need
# fine tuning.

import sys
base = 'Win32GUI' if sys.platform=='win32' else None

executables = [
    Executable('main.py', base=base, target_name = '__TEMeats.exe')
]

data_files = [
    ("templates", "templates"),
    ("static", "static"),
]

build_options = {'packages': ["os", "sys"],  'excludes': [], "includes": ["tkinter", "pysimplegui"], "include_files": data_files}

setup(name='teMeats',
      version = '1.0',
      description = '',
      options = {'build_exe': build_options},
      executables = executables)
