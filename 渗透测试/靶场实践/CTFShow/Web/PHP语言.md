#### 代码审核



##### 







##### md5绕过



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