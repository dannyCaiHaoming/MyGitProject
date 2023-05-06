import os.path
import paramiko
import threading
import sys
import socket

# 配合ssh_rcmd客户端程序，将ssh连接构造完成后，服务器端输入的内容，将发送到客户端，然后客户端将执行完的内容反射回客户端输出
# 使用socket监听端口，将socket连接作为ssh的传输通道，来构造ssh服务器
#

CWD = os.path.dirname(os.path.realpath(__file__))
HOSTKEY = paramiko.RSAKey(filename=os.path.join(CWD,'test_rsa.key'))

class Server(paramiko.ServerInterface):
    def _init_(self):
        self.event = threading.Event()
        
    def check_channel_request(self, kind, chanid):
        if kind == 'session':
            return paramiko.OPEN_SUCCEEDED
        return paramiko.OPEN_FAILED_ADMINISTRATIVELY_PROHIBITED
    
    def check_auth_password(self,username,password):
        if username == 'danny' and password == 'danny':
            return paramiko.AUTH_SUCCESSFUL
    
    
if __name__ == '__main__':
    server = '127.0.0.1'
    ssh_port = 2222
    
    try:
        sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
        
        sock.bind((server,ssh_port))
        sock.listen(100)
        print('[+] Listening for connection ...')
        client, addr = sock.accept()
    except Exception as e:
        print('[-] Listen failed: ' + str(e))
        sys.exit(1)
    else:
        print('[+] Got a connection!', client, addr)
        
    # 设置权限认证
    bhSession = paramiko.Transport(client)
    bhSession.add_server_key(HOSTKEY)
    server = Server()
    bhSession.start_server(server=server)
    
    chan = bhSession.accept(20)
    if chan is None:
        print("*** No channel.")
        sys.exit(1)
    
    print('[+] Authenticated!')
    print(chan.recv(1024))
    chan.send('Welcome to bh_ssh')
    
    try:
        while True:
            command = input("Enter Command:")
            if command != 'exit':
                chan.send(command)
                r = chan.recv(8192)
                print(r.decode())
            else:
                chan.send('exit')
                print('exiting')
                bhSession.close()
                break
    except KeyboardInterrupt:
        bhSession.close()