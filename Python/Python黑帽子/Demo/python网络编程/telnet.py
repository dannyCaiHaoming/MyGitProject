import telnetlib

try:
    tn = telnetlib.Telnet('192.168.217.156', 33333)
    print("Connection successful!")
except ConnectionRefusedError:
    print("Connection refused!")