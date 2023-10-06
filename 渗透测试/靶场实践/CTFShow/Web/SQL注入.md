

#### SQL绕过方式：



###### 1. 一般语法绕过

1. 过滤了union，尝试布尔
2. 过滤了逗号，使用mid(username from 1 for 1)代替mid(username,1,1)
使用limit 1 offset 1代替limit 1,1
3. 过滤空格使用/**/绕过
4. 过滤带引号，使用`ord()`将待检测字符转换为ascii比较。



###### 2. 绕过`information_schema`

利用mysql5.7新增的`sys.schema_auto_increment_columns`





###### 100. 绕过waf

绕过waf会有sqlmap里面有各种bypass waf tamper。

waf绕过内容有点多，另外开`waf bypass`



###### 888. sql读写文件的语法

1. load_file

应该是要看是否有权限，然后读取文件，跟shell命令cat一样了。



###### 999. with rolllup

`group by`能对指定列名进行分组查重的意思。例如`age`列下有1,1,2,3四个数字，当使用`group by age`只有，就只会出现1,2,3三列数据。

| age  | count(*) |
| ---- | -------- |
| 1    | 2        |
| 2    | 1        |
| 3    | 1        |

当使用`select age,count(*) group by age with roolup`，`count`列就会多出一行汇总数据。最后一行数据就会

| Age  | count(*) |
| ---- | -------- |
| 1    | 2        |
| 2    | 1        |
| 3    | 1        |
| NULL | 4        |



### 题目

###### 1. ctf.show_web5

找到`get`方法中的`id`字段是注入点。尝试了基本的注入命令，报错。

猜测可能过滤了关键字，那双写试试，or中间插个空格，还是不行。

那就减少输入，一个个试试。

or输入。可以，那'符号呢，也可以。那' or呢，不行，那所以是过滤了空格。

那好处理。直接翻出一些绕过的字符。这里用了`/*%00*/`当做空格。



###### 2.  ctf.show_web8

试了基本的，用了'符号报错。然后尝试上面的空格替换法。能得到结果。

果然。筛选了`union`但是可以用`select`，查一下怎么绕过union.

看开头的总结。



###### 3. ctf.show_web9

应该是and和or的优先级顺序问题。

原来不是，做不出来的直接扫目录好了。

```php
<?php
        $flag="";
		$password=$_POST['password'];
		if(strlen($password)>10){
			die("password error");
		}
		$sql="select * from user where username ='admin' and password ='".md5($password,true)."'";
		$result=mysqli_query($con,$sql);
			if(mysqli_num_rows($result)>0){
					while($row=mysqli_fetch_assoc($result)){
						 echo "登陆成功<br>";
						 echo $flag;
					 }
			}
    ?>
```

这题即使拿到源码，也要知道什么字符串的md5能构造出绕过的的字符串。

`ffifdyop` 要记住？



###### 4. ctf.show_web10

输入`,符号`,`and`,`union`,` 空格`均报错，那就是筛查了，但是为啥or没有报错。

无解偏门`group by xx with rollup`语法，记下来学习就好。

不是很明白，为什么我输入的内容要直接在请求体用没有转码的字符串，如果写在了检查器右边输入框中，好像字符串会变转码，导致失败。



###### 5. web14

难。

首先是php的switch语法的校验。这个可以复习`PHP记录`。

找到下一步是一个SQL注入的源码。能看见使用了筛选条件。

```php
<!--
	if(preg_match('/information_schema\.tables|information_schema\.columns|linestring| |polygon/is', $_GET['query'])){
		die('@A@');
	}
-->
```

然后去查怎么绕过`information_schema`的判断。

查到上面使用`sys.scheme_auto_increate_columns`，尝试无果。

原来可以使用``反引号`绕过。66666~

绕过了之后，查看库名，表名，列名，爆破。

`adminflag is not here!,2gtf1ywow,you can really dance,3Wowtell you a secret,secret has a secret...`

囧囧囧囧囧囧囧囧囧，又宕机了。。。。

看别人答案，根据这个secret提示，用了`load_file`去查看了一开始的`secret.php`,然后里面又提示让你去看`/real_flag_is_here`



###### 6. CTFshow web1

不太一样的sql注入题目。

基本流程尝试了一遍，有登录页，注册页，还是登录后跳转的详情页。

拿到手没什么思路的题目，先爆破一下路径。找到一个压缩包，所有页面的源码都有了。

看见数据库的账号密码，还以为可以直接登录搞掂。

没办法，所有注入的位置，都被管的死死的。

看了一眼答案。原来是在详情页下功夫。写python去遍历破解。

主要的思想就是，每次注册一个`CurrentStr`的字符串，每轮就是`CurrentStr`拼上所有需要遍历字符串作为账号和密码，然后在详情页，用账号密码`pwd`去排序，只要找到含有`flag@ctf.show`的行数，对应上一行的字符，就是对应这轮遍历要拼上的结果字符。



###### 7. web15 Fishman

页面打开是一个登录页面，点击了页面的按钮，会跳转到qq空间。这。。肯定是不可能搞成鹅厂的网页。那实际能让我看只有这个登录页，看了F12，也没有注释提示。那直接上扫描。看见`www.zip`备份包，下载看源码。

源码有点多，主要分`admin`,`include`和网站首页。

源码里面能找到一些配置信息，还有是默认的账号密码信息，尝试用`admin`去登录后，能看见还是跳转到qq空间。

然后去看`admin`文件夹，也有一个`login.php`,然后使用`admin`去尝试登录，发现能进去到一个展示登录记录的后台中心。然后观察了`admin`文件夹剩余的文件，就是用来增删改查这个用户登录信息表的。

这时候我猜想应该是根据sql注入来展示表中的信息。

一开始看见主页登录，会把消息记录进去，然后我看字段除了用户名和密码，其他没有进行输入筛查，然后一个个字段试了一下，无果。

然后去`admin/export.php`尝试修改查询语句，尝试在导出信息的时候，尝试联合查询查询别的字段信息。

**这道题可以看出我对php中，一些防止sql的手段，还有能引起sql注入的语法都不是很熟悉。**

- `preg_replace_callback`，能对输入进行筛查
- 联合查询的函数是`multi_query`

而实际存在sql注入的地方，是我没怎么在意的`include`文件夹，我以为都是一些base方法。。。

**要点，通过sql语句查询，是否能产生差异化返回。**

观察需要构造`islogin`,`login_data`的cookie字典。其中`login_data`需要构造json，里面需要有`admin_user`字段，注入点实际在这个字段。

剩下就是布尔注入。还有个点就是，会有`waf`.而`json_decode`是能够识别到`Unicode`编码，因此可以将一些被过滤的字符，改成`Unicode`编码进行绕过

