import sys

def current_line():
    try:
        raise Exception
    except:
        frame = sys.exc_info()[2].tb_frame.f_back
    return frame.f_lineno

def current_file():
    try:
        raise Exception
    except:
        frame = sys.exc_info()[2].tb_frame.f_back
    return frame.f_code.co_filename

if __name__ == "__main__":
    line_number = current_line()
    file_name = current_file()
    print(f"Current line: {line_number} in file: {file_name}")
