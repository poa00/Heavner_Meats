import socket
import sys
import os

def get_available_port():
  """Gets an available port number."""
  for port in range(5000, 65535):
    try:
      socket.create_server(('', port))
      return port
    except socket.error:
      continue

def clear_port(port):
  """Clears a port by killing any running processes on it."""
  command = f'fuser -k {port}'
  sys.stdout.write(f'Clearing port {port}...\n')
  sys.stdout.flush()
  os.system(command)

def main():
  """The main function."""
  port = get_available_port()
  clear_port(port)
  print(f'Using port {port}.')

if __name__ == '__main__':
  main()