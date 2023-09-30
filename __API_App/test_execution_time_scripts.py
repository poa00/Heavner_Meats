import time
import subprocess

def run_script(script_path, num_runs=3):
    execution_times = []

    for _ in range(num_runs):
        start_time = time.time()
        subprocess.run(['python', script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        end_time = time.time()
        execution_time = end_time - start_time
        execution_times.append(execution_time)

    average_execution_time = sum(execution_times) / num_runs
    return execution_times, average_execution_time

if __name__ == "__main__":
    script1_path = "script1.py"  # Replace with the path to your first script
    script2_path = "script2.py"  # Replace with the path to your second script

    print("Running Script 1...")
    script1_execution_times, script1_average_time = run_script(script1_path)
    print("Running Script 2...")
    script2_execution_times, script2_average_time = run_script(script2_path)

    print("\nExecution times for Script 1:")
    for i, time_taken in enumerate(script1_execution_times, start=1):
        print(f"Run {i}: {time_taken:.4f} seconds")
    print(f"Average Execution Time for Script 1: {script1_average_time:.4f} seconds\n")

    print("\nExecution times for Script 2:")
    for i, time_taken in enumerate(script2_execution_times, start=1):
        print(f"Run {i}: {time_taken:.4f} seconds")
    print(f"Average Execution Time for Script 2: {script2_average_time:.4f} seconds")


