import os
import subprocess
import getpass
from OpenSSL import crypto

def generate_private_certificate(cert_path, key_path, common_name, validity_days=365):
    key = crypto.PKey()
    key.generate_key(crypto.TYPE_RSA, 2048)

    cert = crypto.X509()
    cert.get_subject().CN = common_name
    cert.set_serial_number(1000)
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(validity_days * 24 * 60 * 60)
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(key)
    cert.sign(key, 'sha256')

    with open(cert_path, 'wb') as cert_file:
        cert_file.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
    
    with open(key_path, 'wb') as key_file:
        key_file.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, key))

def sign_exe(exe_path, certificate_path, certificate_password):
    signtool_path = "C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.19041.0\\x64\\signtool.exe"  # Update this path to your signtool executable location
    if not os.path.exists(signtool_path):
        print("Signtool not found. Make sure you have the Windows SDK installed.")
        return
    
    # Construct the command for signtool with the /t option
    cmd = [
        signtool_path,
        "sign",
        "/f", certificate_path,
        "/p", certificate_password,
        "/t", "http://timestamp.digicert.com",  # Use a timestamp server for a trusted signature
        exe_path,
    ]
    
    try:
        subprocess.check_call(cmd)
        print(f"Successfully signed {exe_path} using the generated private certificate.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    exe_name = input("Enter the name of the EXE file to generate (without the .exe extension): ")
    common_name = "My Organization"  # Replace with your organization's name

    # Generate private certificate and key
    certificate_path = "private_certificate.pem"
    key_path = "private_key.pem"
    generate_private_certificate(certificate_path, key_path, common_name)

    # Generate the Python script to EXE
    script_to_convert = input("Enter the Python script file (e.g., script.py): ")
    exe_path = f"{exe_name}.exe"

    # Sign the EXE with the generated certificate
    certificate_password = getpass.getpass("Enter the password for the private certificate: ")
    sign_exe(exe_path, certificate_path, certificate_password)

    print(f"Generated EXE file: {exe_path}")
