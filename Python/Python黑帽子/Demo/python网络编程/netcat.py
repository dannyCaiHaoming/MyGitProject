import socket
import sys
import argparse
import threading
import subprocess
import shlex
import textwrap


def execute(cmd):
    # 移除字符串头尾指定字符，默认空格和换行
    cmd = cmd.strip()
    if not cmd:
        return
    # 创建命令行界面的程序
    output = subprocess.check_output(shlex.split(cmd), stderr=subprocess.STDOUT)
    return output.decode()


class NetCat:
    def __init__(self, args, buffer=None):
        self.args = args
        self.buffer = buffer
        # 创建socket对象
        self.socket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        # 设置socket重用上一次的连接
        self.socket.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
        
    def run(self):
        if self.args.listen:
            # 如果是接收方，启动监听
            self.listen()
        else:
            self.send()
            
    def send(self):
        # 连接服务器
        self.socket.connect((socket.gethostname(),self.args.port))
        if self.buffer:
            print("buffer")
            print(self.buffer)
            self.socket.send(self.buffer)
        try: 
            while True:
                recv_len = 1
                response = ''
                while recv_len:
                    data = self.socket.recv(4096)
                    recv_len = len(data)
                    response += data.decode()
                    if recv_len < 4096:
                        break
                if response:
                    print(response)
                print('等待输入')
                # 接受用户输入
                buffer = input('>')
                buffer += '\n'
                # 发送到服务端
                print(buffer)
                self.socket.send(buffer.encode())
        except KeyboardInterrupt:
            print('User terminated.')
            self.socket.close()
            sys.exit()
            
    def listen(self):
        print('start listen')
        # 绑定监听
        self.socket.bind((socket.gethostname(),self.args.port))
        # 启动监听
        self.socket.listen(5)
        while True:
            client_socket, _ = self.socket.accept()
            client_thread = threading.Thread(target=self.handle, args=(client_socket,))
            client_thread.start()
            
    def handle(self, client_socket):
        print('start socket listen handle')
        print(client_socket)
        if self.args.execute:
            # 执行命令
            output = execute(self.args.execute)
            client_socket.send(output.encode())
        elif self.args.upload:
            # 文件上传
            file_buffer = b''
            while True:
                data = client_socket.recv(4096)
                if data:
                    file_buffer += data
                else:
                    break
            with open(self.args.upload, 'wb') as f:
                f.write(file_buffer)
            message = f'Saved file {self.args.upload}'
            client_socket.send(message.encode())
        elif self.args.command:
            # 打开shell
            cmd_buffer = b''
            while True:
                try:
                    client_socket.send(b'BHP: #> ')
                    while '\n' not in cmd_buffer.decode():
                        cmd_buffer += client_socket.recv(64)
                    response = execute(cmd_buffer.decode())
                    print(response)
                    if response:
                        client_socket.send(response.encode())
                    cmd_buffer = b''
                except Exception as e:
                    print(f'server kill {e}')
                    self.socket.close()
                    sys.exit()
        
        
            

# 定义main函数入口
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='BHP Net Tool',
                                     formatter_class=argparse.RawDescriptionHelpFormatter,
                                     epilog=textwrap.dedent('''Example:
    netcat.py -t 192.168.1.108 -p 5555 -l -c # command shell
    netcat.py -t 192.168.1.108 -p 5555 -l -u=mytest.txt # upload to file
    netcat.py -t 192.168.1.108 -p 5555 -l -e=\"cat /etc/passwd\" # execute command
    echo 'ABC' | ./netcat.py -t 192.168.1.108 -p 135 # echo text to server port 135
    netcat.py -t 192.168.1.108 -p 5555 # connect to server     
                                                            '''))
    parser.add_argument('-c',
                        '--command',
                        action='store_true',
                        help='command shell')
    parser.add_argument('-e',
                        '--execute',
                        help='execute special command')
    parser.add_argument('-l',
                        '--listen',
                        action='store_true',
                        help='listen')
    parser.add_argument('-p',
                        '--port',
                        type=int,
                        default=44444,
                        help='specified port')
    # parser.add_argument('-t',
    #                     '--target',
    #                     default='192.168.217.156',
    #                     help='specified IP')
    parser.add_argument('-u',
                        '--upload',
                        help='upload file')
    args = parser.parse_args()
    
    print(args)
    
    if args.listen:
        buffer = ''
    else:
        buffer = sys.stdin.read()
    
    print(buffer)
    nc = NetCat(args,buffer.encode())
    nc.run()
