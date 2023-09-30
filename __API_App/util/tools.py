import logging

def log():
    return logging.basicConfig(
    level=logging.DEBUG,  # Set the logging level to DEBUG or a level that suits your needs
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(),  # Log to console
        logging.FileHandler("error.log"),  # Log to a file named error.log
    ]
)