import ipaddress
import os
import socket
import struct
import sys


class IP:
    def __init__(self, buff=None):
        # 小端解析，地址从低到高解析的时候，低位放的还是低位的地址头，和实际高低反过来
        header = struct.unpack('<BBHHHBBH4s4s', buff)
        # 版本
        self.ver = header[0] >> 4
        # 头长度
        self.ihl = header[0] & 0xF
        # 服务类型
        self.tos = header[1] 
        # 总长度
        self.len = header[2]
        # 标识
        self.id = header[3]
        # 段偏移
        self.offset = header[4]
        # 生存时间
        self.ttl = header[5]
        # 协议
        self.protocol_num = header[6]
        # 头校验和
        self.sum = header[7]
        #
        self.src = header[8]
        # 
        self.dst = header[9]
        
        # ip地址转换成可读形式
        self.src_address = ipaddress.ip_address(self.src)
        self.dst_address = ipaddress.ip_address(self.dst)
        
        self.protocol_map = {1: "ICMP", 6: "TCP", 17: "UDP"}
        
        try:
            self.protocol = self.protocol_map[self.protocol_num]
        except Exception as e:
            print("%s No protocol for %s" % (e, self.protocol_num))
            self.protocol = str(self.protocol_num)
            
            
            
class ICMP:
    def __init__(self, buff):
        header = struct.unpack('<BBHHH',buff)
        #
        self.type = header[0]
        #
        self.code = header[1]
        #
        self.sum = header[2]
        #
        self.id = header[3]
        #
        self.seq = header[4]
        

def sniff(host):
    if os.name == 'nt':
        socket_protocol = socket.IPPROTO_IP
    else:
        socket_protocol = socket.IPPROTO_ICMP
    
    sniffer = socket.socket(socket.AF_INET,socket.SOCK_RAW,socket_protocol)
    sniffer.bind((host,0))
    sniffer.setsockopt(socket.IPPROTO_IP,socket.IP_HDRINCL,1)
    
    if os.name == 'nt':
        sniffer.ioctl(socket.SIO_RCVALL, socket.RCVALL_ON)
        
    try:
        while True:
            #
            raw_buffer = sniffer.recvfrom(65535)[0]
            #
            ip_header = IP(raw_buffer[0:20])
            if ip_header.protocol == 'ICMP':
                print("Protocol: %s %s -> %s" % (ip_header.protocol, ip_header.src_address, ip_header.dst_address))
                print(f'Version: {ip_header.ver}')
                print(f'Header Length: {ip_header.ihl} TTL: {ip_header.ttl}')
                
                #
                offset = ip_header.ihl * 4
                buf = raw_buffer[offset:offset+8]
                
                icmp_header = ICMP(buf)
                print("ICMP -> Type: %s Code: %s\n" % (icmp_header.type, icmp_header.code))
    except KeyboardInterrupt:
        if os.name == 'nt':
            sniffer.ioctl(socket.SIO_RCVALL, socket.RCVALL_OFF)
            sys.exit()
            
            
    
if __name__ == "__main__":
    if len(sys.argv) == 2:
        host = sys.argv[1]
    else:
        host = "192.168.217.156"
        sniff(host)