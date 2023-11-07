# 写一个fuzz，跑通sqli-labs？
#
#


# 基本:
# 1. 区分整型还是字符型
# 2. 单引号还是双引号
# 3. 是不是要在后补），还有可能双层
# 4. 末尾截断需要--+ 还是 #


#  盲注： 页面不会返回我注入语句的查询结果，报错也是没有错误信息返回
#  布尔注入，时间注入
#  根据已有成功查询的输入，来构造and型或者or型布尔注入，同理时间注入也可以
#  这种写起来要对每次页面进行筛查。方便写的话，就是每次加入特殊标识，或者自己增加标识库。

#  变形：  就是注入点不在get请求的query或者post请求的body，而是在http的header里面
#  这种只需要将上面基本点，还有盲注的点，换到header的字段里面去发送即可。
#
#


# 特殊：
# 1. 过滤# -- ， 需要考虑后边也要闭合的方式，把前面基本那套闭合考虑在后面
# 2. 过滤and or   ， 尝试大小写，复写，注释，||，&&，还有编码
# 3. union，select， 尝试大小写，复写
# 4. 过滤空格 ， %0a，%a0，替代。 有的能用（）进行代替。没有过滤/*的时候，可以用注释符。
# 5. 服务器两层架构，致使参数过滤绕过，id=1&id=union xxx
# 6. 宽字节，构造\，或者%df，导致\被破坏
# 7. 堆叠注入，使用；分割多条sql语句，注意不同数据库有不一样表现，不是每个都能使用。
# 8. order by，sort。
#    将order by 后面的数字当做布尔注入的条件。根据页面不同的显示来判断。
