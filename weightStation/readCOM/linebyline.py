def process_script_file(input_filename, output_filename):
    with open(input_filename, 'r') as file:
        lines = file.readlines()

    output_lines = []
    variable_name = ""
    for line in lines:
        if "myCtrls." in line and ":= myGui.Add(" in line:
            # Extracting variable name from myCtrls
            variable_name = line.split(".")[1].split(" :=")[0].strip()
            line = f"\t\tmyCtrls.{variable_name} := " + \
                r"{}" + f", {line.strip()}\n"
        output_lines.append(line)

    with open(output_filename, 'w') as file:
        file.writelines(output_lines) 
        
# Example usage
input_file = 'toreplace.txt'
output_file = 'replaced.txt'
process_script_file(input_file, output_file)