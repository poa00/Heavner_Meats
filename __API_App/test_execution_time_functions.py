def measure_execution_time(function1, function2, num_runs=3):
    def run_function(func):
        execution_times = []

        for _ in range(num_runs):
            start_time = time.time()
            func()
            end_time = time.time()
            execution_time = end_time - start_time
            execution_times.append(execution_time)

        average_execution_time = sum(execution_times) / num_runs
        return execution_times, average_execution_time

    print(f"Running {function1.__name__}...")
    function1_execution_times, function1_average_time = run_function(function1)
    print(f"Running {function2.__name__}...")
    function2_execution_times, function2_average_time = run_function(function2)

    print(f"\nExecution times for {function1.__name__}:")
    for i, time_taken in enumerate(function1_execution_times, start=1):
        print(f"Run {i}: {time_taken:.4f} seconds")
    print(f"Average Execution Time for {function1.__name__}: {function1_average_time:.4f} seconds\n")

    print(f"\nExecution times for {function2.__name__}:")
    for i, time_taken in enumerate(function2_execution_times, start=1):
        print(f"Run {i}: {time_taken:.4f} seconds")
    print(f"Average Execution Time for {function2.__name__}: {function2_average_time:.4f} seconds")

# Example usage:
def function_to_measure1():
    # Replace this with your first function code
    time.sleep(1)  # Simulate some work

def function_to_measure2():
    # Replace this with your second function code
    time.sleep(2)  # Simulate some work

if __name__ == "__main__":
    measure_execution_time(function_to_measure1, function_to_measure2)
