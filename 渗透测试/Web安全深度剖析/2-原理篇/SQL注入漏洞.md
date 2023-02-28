## SQL注入漏洞





### 1. 注入原理

白话解释，就是注入语句带进了SQL查询语句处理。

定义就是： **用户输入的数据被SQL 解释器执行**。



### 2. 注入漏洞分类



#### 2.1 数字型注入

当输入的参数为**整型**，如：ID，年龄，页码等，且存在注入漏洞，则认为是存在数字型注入。

一般判断流程：

- 对查询内容加上`'`,因为符号不成对匹配，所以不能正确查询数据，页面也定会报错
- 加上`and 1=1`,如果是数字型则等于直接对查询语句进行拼接，并且是与语句，和原来输入没有差别
- 加上`and 1=2`,页面没有报错，但是条件为假无法查出数据，和原来页面有差别。



强类型和弱类型语言在注入时候区别？



#### 2.2 字符型注入

输入参数为字符串时，称为字符型。

字符型和数字型区别在于，字符型注入一般需要单引号闭合

**字符型注入最关键的是如何闭合SQL语句以及注释多余的代码**



#### 2.3 SQL注入分类

按照对输入数据的分类，那么SQL注入只分为`字符型`和`数字型`，而其他的类似POST注入，盲注，演示注入，也是基于上面两种的不同展现形式和不同位置的展现。

**这里详细展开需要看暗月的SQL注入**





### 3. 常见数据库注入

对于大多数数据库而言，SQL注入的原理基本相似，因为每个数据库都遵循一个SQL语法标准。但是个中也有很多细微差别，包括函数、语法等。因此对于不同的数据库的注入，也不尽相同。

SQL注入利用方式分类：

- 查询数据
- 读写文件
- 执行命令



#### 3.1 SQL Server

##### 1. 利用错误信息提取信息

SQL Server会准备的抛出错误信息。

###### （1）枚举当前表和列

使用`having`字句进行查询。

###### （2）利用数据类型错误提取数据

利用字符串与非字符串比较，或者将字符串转换成另一个不兼容类型时，SQL会抛出异常。

```mysql
select*from users where username='root' and password ='root' and 1> (select top 1 username from users)
```



##### 2. 获取元数据

SQL Server提供了大量视图，便于取得元数据。使用`information_schema.tables`,`informatioin_columns`，表名，列名等。

一些常用的表示图：

- sys.databases: SQL Server中的所有数据库
- sys.sql_logins:SQL Server中所有登录名
- Information_schema.tables:当前数据库中的表
- Information_schema.columns:当前数据库中的列
- sys.all_columns: 用户定义对象和系统对象的所有列的联合
- sys.database_principals:数据库中每个权限或列异常权限
- sys.database_files:存储在数据库中的数据库文件
- Sys objects:数据库中创建的额每个对象



##### 3. Order by字句

`order by` 字句：为SELECT查询的列排序，如果同时指定了`TOP`关键字，则`order by`在视图、内联函数、派生表和子查询中无效。

通常会使用`order by`语句来判断表中列数。

```sql
select id,username,password from users where id = 1
// 按第一列排序
select id,username,password from users where id = 1 order by 1
// 按第二列排序
select id,username,password from users where id = 1 order by 2
// 按第三列排序
select id,username,password from users where id = 1 order by 3
```

如果那行排序抛出错误，那么就是就能得到表列数。



##### 4. Union查询

`Union`关键字将两个或更多个查询结果组合为单个结果集。

###### （1）联合查询探测字段数

```sql
select id,username,password from users where id = 1 union null
union null,null
union null,null,null
```

也可以使用`union 1,2,3`但是这种**可能存在类型兼容问题**。

###### （2）联合查询敏感信息

```sql
// 如果知道列数为3
id = 5 union select 'x',null,null from sysobject where xtype="U"
id = 5 union select null,'x',null from sysobject where xtype="U"
id = 5 union select null,null,'x' from sysobject where xtype="U"
```

如果语句能正常执行，则证明数据类型兼容，就可以把x替换成SQL语句，查询敏感信息。

**这里提供了整型注入变成字符型注入的思路**



##### 5. 无辜的函数

SQL Server提供了非常多的系统函数，利用这些系统函数可以反问SQL Server系统中的信息，而不需要使用SQL语句查询。

SQL Server常用函数表：

|       函数       | 说明                                                     |
| :--------------: | -------------------------------------------------------- |
|      Stuff       | 字符串截取函数                                           |
|      ascii       | 取ASCII码                                                |
|       char       | 根据ACII码取字符                                         |
|     getdate      | 返回日期                                                 |
|      count       | 返回组中总条数                                           |
|       case       | 将一种数据类型的表达式显式转换为另一个种数据类型的表达式 |
|       rand       | 返回随机值                                               |
| is_srvrolemember | 登录名是否为指定服务器角色的成员                         |

|       @@version       | 查看数据库版本                   |
| :-------------------: | -------------------------------- |
|      suser_name       | 返回用户的登录标识名             |
|       user_name       | 基于指定的标识号返回数据库用户名 |
|        db_name        | 返回数据库名称                   |
| is_member('db_owner') | 是否为数据库角色                 |
|   convert(int,'5')    | 数据类型转换                     |
|                       |                                  |
|                       |                                  |
|                       |                                  |



##### 6. 危险的存储过程

存储过程(Stored Procedure)是在大型数据库系统中为了完成特定功能的一组SQL“函数”，如执行系统命令，查看注册表，读取磁盘目录等。



##### 7. 动态执行

SQL Server支持动态执行语句，用户可以提交一个字符串来执行SQL语句。例如：

```sql
exec('select username,password from users')
exec('select' + 't username,password fro' + 'm users')
```

还能通过定义十六进制的SQL语句，使用exec函数执行。



#### 2. MySQL



##### 1. MySQL中的注释

有3种注释风格：

- #：注释从#到行尾
- --：注释从--序列到行位。但是需要在--后面跟一个或多个空格或者tag
- /* */:和c一样

**其中特别注意**

```mysql
select id /*!55555, username*/ from users	
```

注释没有生效，语句被正常执行。这里的`/*!*/`的感叹号是有特殊意义，若MySQL版本号高于或者等于5.55.55语句会被执行。如果感叹号后不加版本号，则直接执行。

##### 2. 获取元数据

MySQL 5.0及其以上版本提供了`information_schema`,`information_schema`是信息数据库。

```mysql
// 查询数据库名称,information_schema.schemata表中找出
select schema_name from information_schema.schemata limit 0,1
// 查询数据库表
select table_name from information_schema.tables where table_schema=database() limit 0,1
// 查询表所有字段
select column_name from information_schema.columns where table_name='' limit 0,1
```

##### 3. Union查询

官方解释Union查询用于把来自许多SELECT语句的结果组合到一个结果集合中，且每列的数据类型必须相同

MySQL中，列类型不确定的时候，也能执行正确？

##### 4. MySQL函数利用

###### （1）load_file()函数读写操作

`load_file`函数能快速读取文件，但是文件位置必须在服务器上，要以绝对路径获取，而且用户要有`FILE`权限，文件容量也必须小于`max_allowed_packet`字节（默认16MB，最大1GB）

```mysql
union select 1,load_file('/etc/passwd'),3 #
// 16进制绕过
union select 1,load_file(0x2F6563742F706173737764),3 #
// 还能使用ascii将数字转回16进制的符号
union select 1,load_file(char(47,101,99,116,47,112,97,115,115,119,100)),3 #
```

###### (2)into outfile 写文件操作

与load_file()一样，需要FILE权限，且必须为绝对路径。

```mysql
select '<?php phpinfo();?>' into outfile 'c:\\wwwroot\1.php'
```

###### (3)连接字符串

MySQL查询中，如果需要一次查询多个数据，可以使用`concat()`,`concat_ws()`，我一般是将多列输出拼接成一列输出。

```mysql
concat(user(),0x2c,database(),0x2c,version())
```

常用MySQL函数：

|         函数         | 说明                                                 |
| :------------------: | ---------------------------------------------------- |
|        length        | 字符串长度                                           |
|      substring       | 截取字符串长度                                       |
|        ascii         | 返回ASCII码                                          |
|         hex          | 字符串转十六进制                                     |
|         now          | 当前系统时间                                         |
|        unhex         | hex反向操作                                          |
|       floor(x)       | 取地板值，                                           |
|         md5          | 返回md5值                                            |
|     group_concat     | 返回来自一个组的连接结果，将几列合并成一列的数据输出 |
|      @@datadir       | 数据库路径                                           |
|      @@basedir       | MySQL安装路径                                        |
| @@Version_compile_os | 操作系统                                             |
|         user         | 用户名                                               |
|     current_user     | 当前用户名                                           |
|     system_user      | 系统用户名                                           |
|       database       | 数据库名                                             |
|       version        | 数据库版本                                           |

##### 5. MySQL显错式注入

**MySQL不能直接使用数据类型转换显错的方式来进行提取敏感信息。**但是又另外的方式。

###### （1）通过updatexml函数

```mysql
and (updatexml(1,concat(0x7e,(select user()),0x7e),1));
```

因为函数插入参数的时候，使用了`~`,`^`的ASCII编码，分别为`0x7e`,`0x5e`，这类特殊字符在使用这些函数的时候都是非法的，因此会产生报错信息。而在报错的是哦户，SQL的解析器会自动解析SQL语句，然后造成SQL语句的执行。

###### (2)通过extractvalue函数

```mysql
and (extractvalue(1,concat(0x7e,(select user()),0x7e)));	
```

第二个参数 xml中的位置是可操作的地方，xml文档中查找字符位置是用 /xxx/xxx/xxx/…这种格式。如果我们写入其他格式，就会报错。并且会返回我们写入的非法格式内容，而这个非法的内容就是我们想要查询的内容。正常查询 第二个参数的位置格式 为 /xxx/xx/xx/xx ,即使查询不到也不会报错。原理和`updatexml`一样。

###### （3）floor函数

```mysql
select * from message where id = 1 union select * from (select count(*),concat(floor(rand(0)*2),(select user()))a from information_schema.tables group by a)b
```

`Duplicate entry '1root@localhost' for key 'group_key'`

但是错误抛出的的貌似是主键重复的错误。这种应该错误信息应该是能分类。

##### 6. 宽字节注入

宽字节注入是由编码不统一造成的，这种注入一般出现在`PHP+MySQL`。

原本的字符串被经过转义，或者拼接后，并且从一种编码格式变成另外的编码格式，最终得到的字符展示转变了。

例如：`%d5'` 在经过转义后变成`%d5\'`，在GBK中，成了`誠'`

##### 7. MySQL长字符截断

`sql_mode`配置为`default`，没有开启`STRICT_ALL_TABLES`，MySQL插入超长的字符，不会报错，只会wanrning。

在插入:

'admin', 'admin    ','admin      '，不同长度字符后，表中展示

输出的内容都是'admin',但是如果输出长度的时候，又是有区别。

当进行表内容查询的时候，长度不同的内容也是能被查询出来。

因此，攻击者只需要创建一个名字长一些的用户名，用自己创建的账号密码，就能登录到其他用户的账户上。

##### 8. 延时注入

当页面无差异，无变化的注入，即是盲注。

延时注入属于盲注的一种，是一种基于时间差异的注入技术。

基本思路是用判断语句，将想要判断的条件为true时，执行延时操作。



#### 3. Oracle

oracle的内容先跳过。数据库间的差异，真的接触到了再搞。





### 4. 注入工具

#### 1. SQLMap

##### 1. 基本用法



##### 2. SQLMap参数





#### 2. Pangolin

是window上的工具，目前可以先跳过。



#### 3. Havij

跟Pangolin类似，边幅也很少，那也跳过。



### 5. 防止SQL注入

SQL注入攻击的问题，最终归于`用户可以控制输入`，SQL注入、XSS、文件包含、命令执行都可归于此。

根据SQL注入的分类，防御主要分为：

- 数据类型判断
- 特殊字符转义



####  1. 严格的数据类型

强类型如Java，C#，在使用值的时候，是会进行类型的判断，因此在转换的时候，会被察觉出是整形还是字符型。

但是类似PHP、ASP，并没有强制处理数据类型，在使用的时候是根据编译器自动识别数据类型，因此可以被输入进行欺骗，然后拼接到SQL查询上，就会出现注入。

对于这类型的数字型注入，**只需要进行严格的数据类型判断即可**。用`is_numeric(),ctype_digit()`.

##### 2. 特殊字符转义

（1）一般对于特殊字符，如`'`进行转义，使用反斜杠`\`进行转义。

（2）对于转义后的特殊字符，也要注意二次注入。具体表现就是，头一次进行一个存在转义字符的输入，在PHP开启`magic_quotes_gpc`，虽然在执行SQL语句的时候会被转义掉，但是存入到数据库中的还是原来的输入。所以在下一次使用这个数据的时候，有可能会将存在注入的数据带到SQL查询中，造成二次注入。

##### 3. 使用预编译语句

Java、C#都提供了预编译语句。

感觉是一些面向类对象编程，提供了一些将SQL语句查询封装起来，直接对需要差值的地方使用setter方法输入，然后在方法里面对参数进行了校验。

##### 4. 框架技术

java后端，`Hibernata`,`MyBatis`,`JORM`等，与数据库打交道的框架，成为`持久层框架`。

##### 5. 存储过程(Stored Procedure)

是在大型数据库系统中，一组为了完成特定功能或经常使用的SQL语句集，经编译后存储在数据库中。

```SQL
create proc findUserId @id varchar(100)
as 
exec('select * from Student where StudentNo= ' +@id);
go
# 改进
create proc findUserId @id varchar(100)
as 
sekect * from Student where StudentNo=@id
go
```

感觉类似宏定义一样。也是基本不要直接使用SQL语句拼接，尽量使用特性将参数赋值过去，使用特性对参数进行校验。





### 6. 上传漏洞







###### 4. 截断上传攻击

某些特殊的字符会将后面的内容截断。如：ASP代码中`xxx%00admin`，会截断成`xxx`。



#### 3. 文本编辑器上传漏洞

常见的文本编辑器有CKEditor、Ewebeditor、UEditor、KindEditor、XHeditor等。

###### 1. FCKeditor敏感信息暴露

###### 2.FCKeditor黑名单策略错误

###### 3.FCKeditor任意文件上传漏洞





#### 4. 修复上传漏洞

形成上传漏洞的主要原因：

- 目录过滤不严，攻击者可能建立畸形目录
- 文件为重命名，攻击者可能利用Web容器解析漏洞。（解析漏洞，截断错误。）

因此可得一般应对方法 ：

- 接受文件及其文件临时路径
- 获取扩展名与白名单作对比
- 对文件进行重命名

此外还得注意服务器配置、Web容器配置。





### 7. XSS跨站脚本漏洞

XSS是指攻击者在网页中嵌入客户端脚本，当用户使用浏览器浏览被嵌入恶意代码的网页时，恶意代码会在用户浏览器上执行。

XSS属于客户端攻击，受害者是用户，但是网站管理者也是用户之一，因此XSS也能攻击“服务器端”。



#### 1. XSS解析原理



#### 2. XSS类型

XSS主要分为：反射型、存储型和DOM型

##### 1. 反射型XSS

反射型XSS也被称为非持久性XSS。

当用户访问一个带有XSS代码的URL请求时，服务器接受数据处理后，然后把带有XSS代码的数据发送给浏览器解析，最终造成XSS漏洞。过程像一个反射。

##### 2. 存储型XSS

存储型XSS也成为持久性XSS。

当攻击者提交一个段XSS代码后，被服务器端接收并且存储，当用户再次访问某个页面时，这段XSS代码被服务器读取出来发送到用户的浏览器上解析。

存储型XSS，不需要像反射型和DOM型，需要依靠用户手动触发。

##### 3.DOM型XSS

DOM称为Document Object Model，即文档对象模型，Dom通常用于代表在HTML，XHTML和XML中的对象。

使用DOM可以允许程序和脚本动态访问和更新文档的内容、结构和样式。

DOM型XSS，是运用操作DOM的代码的漏洞，将一些带有XSS漏洞的代码，插入到网页中，直接让浏览器进行解析。

DOM型XSS是不需要与服务器交互的，只发送在客户端处理数据阶段。



#### 3. 检测XSS

##### 1. 手工检测XSS



##### 2. 全自动检测XSS
