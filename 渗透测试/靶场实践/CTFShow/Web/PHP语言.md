#### 代码审核



##### 

##### 888.php中执行命令的方法

1. system 

执行外部程序（命令行），并且显示输出。

2. shell_exec

通过shell环境执行命令

3. exec

执行一个外部程序，返回命令执行结果的最后一行

4. passthru

执行外部程序，并且显示原始输出。

5. echo('ls') , echo ls

6. `<?=`  等价于 `<?php echo`







##### 999. md5绕过



###### 1. 不同的字符串和整形，他们的md5值是可以判断

```php
if(isset($v1) && isset($v2)){
	if(!ctype_alpha($v1)){
      die("v1 error");
  }
  if(!is_numeric($v2)){
    die("v2 error");
  }
  if(md5($v1)==md5($v2)){
    echo $flag;
  }
}
#  我们可以采用科学计数法进行绕过，但一个需要全为数字，一个需要全为字母
# 数字
# 240610708  0e462097431906509019562988736854
# 字母
# QNKCDZO    0e830400451993494058024219903391
```

具体要怎么算？







#### 题目：



###### 1. ctf.show_web11

直接给了源码，就是判断`$_Session['password']=$GET['passwod']`，那就把发送的和session中的都删除掉。



###### 2. ctf.show_web11

需要用到php中特殊的输出字符串方法，筛选当前目录文件，还有打印指定文件。



###### 3. ctf.show_红包题

这道题和大部分人一样，cmd之后，看见密密麻麻的筛选条件，还有爆破目录后无果。

看答案，大致是3个要点：

- php上传文件，就是表单上传必定会有`Content_type:multipart/form-data;`的表头，而php又会将上传文件临时保存起来，保存的目录会在`.php.ini`,linux会默认在`/tmp`下。此外文件的命名格式都有固定`为phpXXXX.tmp（Windows中）、php**.tmp（Linux中）`。
- `即使绝望，还得细心`。观察筛选条件中，上帝往往给你开个小口。剩下`.<>?=/`还有`p`没有防范。
- shell命令中，使用`.`代替`source`命令，执行文件中的命令
- shell命令中，`<?=`  等价于 `<?php echo`
- shell命令中，`+`在url中表示空格，利用`?`通配符去匹配`/tmp/php**.tmp`文件
