## 8 网络


### 8.1 HTTP协议 -- 超文本传输协议

- 请求、响应报文
- 连接建立流程
- HTTP的特点


#### 8.1.1 请求、响应报文

##### 8.1.1.1 请求报文 

- 请求行[方法  URL  协议版本  ] 
- 请求头[首部字段名：值]
- 请求主体

![请求报文图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/%E8%AF%B7%E6%B1%82%E6%8A%A5%E6%96%87%E5%9B%BE%E7%A4%BA.png)

##### 8.1.1.2 响应报文

- 响应行[版本 状态码  短语]
- 响应头[首部字段名：值]
- 响应主体

![响应报文图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/%E5%93%8D%E5%BA%94%E6%8A%A5%E6%96%87%E5%9B%BE%E7%A4%BA.png)

##### 8.1.1.3 HTTP请求方式

- GET
- POST
- HEAD
- PUT
- DELETE
- OPTIONS

##### 8.1.1.4 请求状态码

- `1XX` 通知
- `2XX`响应成功
- `3XX`网络重定向
- `4XX`客户端发起请求有问题
- `5XX`Server端有异常

#### 8.1.2 连接建立流程(这里的建立流程跟HTTP没关系，实际只是TCP层，只是HTTP连接的前提)

##### 8.1.2.1 三次握手

![三次握手图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/%E4%B8%89%E6%AC%A1%E6%8F%A1%E6%89%8B%E5%9B%BE%E7%A4%BA.png)

- 客户端发送`SYN`和`X`作为同步报文发送给Server端
- Server端收到同步报文后，也发送一个`SYN`+`Y`和`ACK`+`X+1`，来作为同步报文和确认同步
- 客户端收到Server端的同步和确认之后，发送一个`ACK`+`Y+1`作为确认报文返回Server
- 然后就可以进行客户端<->的http请求响应

##### 8.1.2.2 四次挥手

![四次挥手图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/%E5%9B%9B%E6%AC%A1%E6%8C%A5%E6%89%8B%E5%9B%BE%E7%A4%BA.png)

- 客户端发起`FIN`和`X`作为连接结束的报文发给Server端
- Server收到客户端的连接结束消息后，回一个`ACK`和`X+1`的确认收到报文给客户端
- HTTP连接进入半中断状态，客户端不能继续发信息，Server能继续发一些东西
- 待Server端的内容发完之后，Server端会发起连接结束`FIN`和`Y`作为连接结束报文给客户端
- 客户端收到服务器的连接结束消息后，回一个`ACK`和`Y+1`作为确认收到报文给Server端
- HTTP进入TIME_WAIT状态，等待两个最大报文段生存时间后，HTTP连接才正式中断（这里防止确认报文发送失败，然后重传一次）


#### 8.1.3 HTTP的特点

##### 8.1.3.1 无连接
- 持久连接
	- 头部字段
		- Connection:Keep-alive
		- time:20
		- max:10（最多可以发生多少HTTP请求）
	- 怎样判断一个请求是否结束？
		- **Content-length:**1024 是否到达长度
		- **chunked**块传输，最后有一个空的chunked


##### 8.1.3.2 无状态 `Cookie/Session`




面试题：<br>
**1.`GET`和`POST`方式的区别？** <br>
**从语义的角度来回答**实际是协议定义规则<br>

- GET:获取资源
	- `安全的` `幂等的` `可缓存的`
- POST:处理资源
	- `非安全的` `非幂等的`  `不可缓存的`

- `安全性`
	不该引起Server端的任何状态变化
	GET,HEAD,OPTIONS
	
- `幂等性`
	同一个请求方法执行多次和一次的效果完全相同
	PUT，DELETE
	
- `可缓存性`
	请求是否可以缓存（可能被代理服务器将结果缓存起来）

2.Charles抓包原理是怎样的？ **中间人攻击**

- 正常是客户端<->Server端
- 客户端<->中间人<->Server端
- 中间人可以篡改客户端发起的请求，也可以篡改Server端返回的响应


### 8.2 HTTPS与网络安全

#### 8.2.1 HTTPS和HTTP的区别？
`HTTPS` = `HTTP` +`SSL/TLS`

- `HTTPS`就是安全的`HTTP`，靠的是`SSL/TLS`
- `SSL/TLS`是在应用层之下，传输层（TCP）之上


#### 8.2.2 HTTPS建立流程（HTTPS安全是如何保障的）

![HTTPS连接建立](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/HTTPS%E5%BB%BA%E7%AB%8B%E6%B5%81%E7%A8%8B.png)


##### 8.2.2.1 HTTPS使用了哪些加密手段？为什么？

- 连接建立过程中使用了`非对称加密`，非对称加密很耗时
- 数据传输使用`对称加密`


面试题：<br>
1.Charles捕获HTTPS的原理是什么？
[参考：图解 HTTPS：Charles 捕获 HTTPS 的原理](https://github.com/youngwind/blog/issues/108)

![Charles捕获HTTPS原理](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/Charles%E6%8D%95%E8%8E%B7HTTPS%E5%8E%9F%E7%90%86.png)


### 8.3 TCP、UDP

#### 8.3.1 UDP 用户数据报协议
- 特点：
	- `无连接`
	- `尽最大努力交付` 
	- `面向报文`
		- 既不合并，也不拆分
- 功能：
	- 复用???
	- 分用???
	- 差错检测(IM功能！！！消息传递保证！！)???

![复用分用功能图示]()

#### 8.3.2 TCP 传输控制协议
- 特点
	- `面向连接`
	- `可靠传输`，无差错，不丢失，无重复，按序到达
		- 停止等待协议
			- 无差错情况，按序发送，收到一个序号再发送下一个序号
			- 超时重传
			- 确认丢失
			- 确认迟到
	- `面向字节流`
	- `流量控制`
	- `拥塞控制`


面试题：<br>

1.为什么需要进行三次握手？
主要考虑同步请求报文同步超时，可能会建立多个连接。


2.为什么需要四次挥手？
`全双工`：一条通道，双方都可以发送接收。





### 8.4 DNS解析

#### 8.4.1 DNS解析概念
域名到IP地址的映射，DNS解析请求采用UDP数据报，且明文

![DNS解析图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/DNS%E8%A7%A3%E6%9E%90%E5%9B%BE%E7%A4%BA.png)

#### 8.4.2 DNS解析查询方式


- 递归查询 --- "我去给你问一下"

![DNS递归查询图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/DNS%E9%80%92%E5%BD%92%E6%9F%A5%E8%AF%A2%E5%9B%BE%E7%A4%BA.png)

- 迭代查询 --- "我告诉你谁可能知道"

![DNS迭代查询图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/DNS%E8%BF%AD%E4%BB%A3%E6%9F%A5%E8%AF%A2%E5%9B%BE%E7%A4%BA.png)

#### 8.4.3 DNS解析存在的问题

- DNS劫持问题

![DNS劫持图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/DNS%E5%8A%AB%E6%8C%81%E5%9B%BE%E7%A4%BA.png)

- DNS解析转发问题

![DNS解析转发引起效率问题图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/DNS%E8%A7%A3%E6%9E%90%E8%BD%AC%E5%8F%91%E5%BC%95%E8%B5%B7%E6%95%88%E7%8E%87%E9%97%AE%E9%A2%98%E5%9B%BE%E7%A4%BA.png)

面试题：<br>
1.DNS劫持与HTTP的关系？
- 没有关系。
- DNS解析是发生在建立HTTP建立之前的
- DNS解析请求使用UDP数据报，端口53

2.怎样解决DNS劫持？

- **httpDNS**
	
![httpDNS图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/httpDNS%E5%9B%BE%E7%A4%BA.png)
	
- 长连接

![长连接解决DNS劫持图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/%E9%95%BF%E8%BF%9E%E6%8E%A5%E8%A7%A3%E5%86%B3DNS%E5%8A%AB%E6%8C%81%E5%9B%BE%E7%A4%BA.png)


### 8.5 Session、Cookie
HTTP协议无状态特点的补偿


#### 8.5.1 Cookie
Cookie主要用来记录用户状态，区分用户；**状态保存在客户端**

![Cookie图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/Cookie%E5%9B%BE%E7%A4%BA.png)

- 客户端发送的cookie在http请求报文的`Cookie`首部字段中
- 服务器设置http响应报文的`Set-Cookie`首部字段

##### 8.5.1.1 如何修改Cookie？

- 新Cookie覆盖旧Cookie
- 覆盖规则：`name`,`domain`,`path`需要都一致

##### 8.5.1.2 删除Cookie？

- 新Cookie覆盖旧Cookie
- 覆盖规则：`name`,`domain`,`path`需要都一致
- 设置cookie的`express=过去一个时间点`或者`maxAge=0`

##### 8.5.1.3 怎样保证Cookie安全？

- 对Cookie进行加密处理
- 只在https上携带Cookie
- 设置Cookie为httpOnly，放置跨站脚本攻击

#### 8.5.2 Session
Session也是用来记录用户状态，区分用户；**状态是存在服务器端**

![Session流程图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/8/Session%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B.png)

##### 8.5.2.1 Session和Cookie的关系？

Session需要依赖Cookie机制。


### 8.6 Socket(套接字)




-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
-----
