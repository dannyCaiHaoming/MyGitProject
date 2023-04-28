import socket


host = '192.168.217.156'
port = 44444

client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

client.connect((host,port))

client.send(b'ABCDEFG')

response = client.recv(4096)

print(response.decode())

client.close()