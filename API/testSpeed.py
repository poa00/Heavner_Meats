import time
import sys
import importlib
from flask import Flask

app = Flask(__name__)

# Dictionary to store timing information
timing_info = {"modules": {}, "functions": {}}

def track_module_import_time(module_name):
    start_time = time.time()
    imported_module = importlib.import_module(module_name)
    end_time = time.time()
    elapsed_time = end_time - start_time
    timing_info["modules"][module_name] = elapsed_time

    # Log module import time to a file
    with open("module_import_times.log", "a") as log_file:
        log_file.write(f"Module '{module_name}' imported in {elapsed_time:.6f} seconds\n")

def track_function_execution_time(func, *args, **kwargs):
    start_time = time.time()
    result = func(*args, **kwargs)
    end_time = time.time()
    elapsed_time = end_time - start_time
    timing_info["functions"][func.__name__] = elapsed_time

    # Log function execution time to a file
    with open("function_execution_times.log", "a") as log_file:
        log_file.write(f"Function '{func.__name__}' executed in {elapsed_time:.6f} seconds\n")

def some_slow_function():
    # Simulate a slow function
    time.sleep(2)

def another_slow_function():
    # Simulate another slow function
    time.sleep(1)

if __name__ == "__main__":
    # Track module import time
    track_module_import_time("flask")
    track_module_import_time("time")

    some_slow_function()
    another_slow_function()

    # Start the Flask app
    app.run()

    # Sort and print timing information
    sorted_modules = sorted(timing_info["modules"].items(), key=lambda x: x[1], reverse=True)
    sorted_functions = sorted(timing_info["functions"].items(), key=lambda x: x[1], reverse=True)

    print("\nModule import times (slowest first):")
    for module, time_taken in sorted_modules:
        print(f"{module}: {time_taken * 1000:.2f} ms")

    print("\nFunction execution times (slowest first):")
    for function, time_taken in sorted_functions:
        print(f"{function}: {time_taken * 1000:.2f} ms")
