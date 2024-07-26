import serial
import subprocess
import os


def withSerialOpenRead(comport='COM5', baudrate=9600, timeout=1):
    """
     Open serial connection read a line and return it. This is useful for debugging and to see what's going on on the serial connection
     
     @param comport - serial port to use default COM5
     @param baudrate - baudrate to use default 9600
     @param timeout - timeout in seconds default 1 million seconds
     
     @return line read from serial ( utf - 8 encoded ) default'\ n'if timeout is 0 or
    """
    print("trying serial")
    with serial.Serial(comport, baudrate, bytesize=8, stopbits=1, timeout=1) as ser:
        line = ser.readline()   # read a '\n' terminated line
    return line.decode("utf-8")

def split_weight(string):
    for string in string.split(" "):
        if "LG" in string:
            string = string.replace("LG", "").strip()
            print(f"LG is in string: weight is {string}")
            return string
    return string

if __name__  == "__main__":
    # This function is used to read from serial port
    while True:
        try:
            withSerialOpenRead()
        except Exception as e:
            print(str(e))