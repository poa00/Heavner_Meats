import serial.tools.list_ports

print(serial.tools.list_ports.main())

"""
nuitka --follow-imports --onefile --windows-icon-from-ico=te.ico getallCOM.py
"""

