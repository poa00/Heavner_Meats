import re


def extract_doc_sections(api_text):
    # This regex matches the URL pattern (https://...) followed by a method name anchor ([method_name()]),
    # then captures the text until the next URL or end of the text.
    section_pattern = re.compile(
        r'\[`[^\`]+\`\]\((https://docs.peewee-orm.com/en/latest/peewee/api.html#(?P<anchor>[^ "\)]+))[^)]*\)'
        r'(?P<content>.*?)(?=\nNote\n|\[`[^\`]+\`\]\(http[s]?://|$\n)', re.DOTALL)


    # Extract sections using a dictionary comprehension
    # Uses a lazy dot-all `.*?` to capture content following the link until just before the next link pattern.
    sections = {
        match.group('anchor'): match.group('content').strip()
        for match in section_pattern.finditer(api_text)
    }

    return sections

with open('output.txt', 'r', encoding='utf-8', errors='replace') as file:
    api_doc_ = file.read()


# Extract documentation sections
doc_sections = extract_doc_sections(api_doc_)

# Testing extraction by printing out the documentation for one of the methods
print("Documentation for Table.select():\n")
print(doc_sections.get('Table.select'))
