import os
import re

def extract_class_docs(file_path, class_name):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    start_index = -1
    end_index = -1
    inside_class = False

    for i, line in enumerate(lines):
        if f".. py:class:: {class_name}" in line:
            start_index = i
            inside_class = True

        if inside_class and line.strip() == '"""':
            end_index = i
            break

    if start_index != -1 and end_index != -1:
        class_docs = lines[start_index:end_index + 1]
        return class_docs
    else:
        return None

def extract_method_docs(file_path, method_name):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    start_index = -1
    end_index = -1
    inside_method = False

    for i, line in enumerate(lines):
        if f".. py:method:: {method_name}" in line:
            start_index = i
            inside_method = True

        if inside_method and line.strip() == '"""':
            end_index = i
            break

    if start_index != -1 and end_index != -1:
        method_docs = lines[start_index:end_index + 1]
        return method_docs
    else:
        return None

def insert_comments(file_path, class_name, comments):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if f".. py:class:: {class_name}" in line:
            lines.insert(i + 1, ''.join(comments))
            break

    with open(file_path, 'w') as file:
        file.writelines(lines)

def process_api_references(api_reference_file, peewee_file):
    with open(api_reference_file, 'r') as file:
        api_lines = file.readlines()

    current_class = None

    for line in api_lines:
        if line.startswith('.. py:class::'):
            current_class = line.split(' ')[-1].strip()
            current_class = re.sub(r'\([^)]*\)', '', current_class)  # Remove anything inside parentheses

        if current_class:
            method_match = re.match(r'\s*.. py:method:: (\w+)', line)
            if method_match:
                method_name = method_match.group(1)
                method_docs = extract_method_docs(peewee_file, method_name)

                if method_docs:
                    insert_comments(peewee_file, current_class, method_docs)
                    print(f"Comments inserted for {current_class}.{method_name}")

if __name__ == "__main__":
    api_reference_file = "api.rst"
    peewee_file = "peewee.py"

    process_api_references(api_reference_file, peewee_file)
