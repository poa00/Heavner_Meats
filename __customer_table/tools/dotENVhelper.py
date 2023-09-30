import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get the value of DLL_PATH from the environment
dll_path = os.getenv("DLL_PATH")

# Make the relative path absolute
absolute_path = os.path.abspath(dll_path)



secret_key = os.getenv("SECRET_KEY")
database_url = os.getenv("DATABASE_URL")
debug = os.getenv("DEBUG")

print(f"SECRET_KEY: {secret_key}")
print(f"DATABASE_URL: {database_url}")
print(f"DEBUG: {debug}")



# Load environment variables from .env file
load_dotenv()

# Access the environment variables
secret_key = os.getenv("SECRET_KEY")
database_url = os.getenv("DATABASE_URL")
debug = os.getenv("DEBUG")

# Use the environment variables as needed
print(f"SECRET_KEY: {secret_key}")
print(f"DATABASE_URL: {database_url}")
print(f"DEBUG: {debug}")

base_dir = os.environ.get("BASE_DIR")
relative_path = "subdirectory/file.txt"
absolute_path = os.path.join(base_dir, relative_path)

# Now, 'absolute_path' contains the full absolute path to the file you need.


To view a list of all environment variables in a Windows command prompt, you can use the set command:

batch
Copy code
set
