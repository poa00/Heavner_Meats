import re

def process_text(match):
    # Process the text inside quotations
    text_inside_quotes = match.group(1)
    # Remove all caps and make only the first letter capital
    processed_text = text_inside_quotes.lower().capitalize()
    return f'"{processed_text}"'

def parse_and_modify(file_path, file_path2):
    with open(file_path, 'r') as file:
        content = file.read()

    # Use regular expression to find text between quotations
    pattern = re.compile(r'"(.*?)"')
    modified_content = re.sub(pattern, process_text, content)

    # Print the modified content or save it to a new file
    print(modified_content)
    with open(file_path2, "w") as f:
        f.write(modified_content)

# Replace 'your_file.txt' with the actual path to your text file
parse_and_modify('meatParsed2.ahk', 'meatParsed4.ahk')
