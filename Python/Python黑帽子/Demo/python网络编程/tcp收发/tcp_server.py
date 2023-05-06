import socket
import threading


host = '192.168.217.156'
port = 44444


def start():
    server = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    server.bind((host,port))
    server.listen(5)
    server.listen(5)
    print(f'[*] listening on {host}:{port}')
    
    while True:
        client,address = server.accept()
        server.accept()
        print(f'[*] Accepted connection from {address[0]}:{address[1]}')
        client_handler = threading.Thread(target=handle,args=(client,))
        client_handler.start()
    
        
def handle(client_socket):
    with client_socket as client:
        request = client.recv(1024)
        print(f'[*] Received: {request.decode()}')
        client.send(b'ACK')
        
        
if __name__ == '__main__':
    start()