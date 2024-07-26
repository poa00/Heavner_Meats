import zipfile

# Define the path to the ZIP file and the extraction directory
zip_file_path = 'slim.zip'
extracted_dir = 'path/folder'

# Open the ZIP file for reading
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    # Extract all files in the ZIP archive to the specified directory
    zip_ref.extractall(extracted_dir)

print(f"Extracted files to: {extracted_dir}")
