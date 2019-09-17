## 5 Block

[参考：iOS底层原理总结 ](https://juejin.im/post/5b0181e15188254270643e88#heading-22)

### 5.1 Block介绍

Block是将`函数`及其`执行上下文`封装起来的`对象`

#### 5.1.1 Block描述结构体`__block_impl`

	__block_impl结构
	{
		void *isa;block是对象的标志
		int Flags;
		int Reserved;
		void *FuncPtr;函数指针
	}

#### 5.1.2 什么是Block的调用

即是`函数`的调用

### 5.2 截获变量

#### 5.2.1 变量类型

- 局部变量
 - 基本数据类型
 - 对象类型
- 静态局部变量
- 全局变量
- 静态全局变量

#### 5.2.2

- 对于`基本类型的局部变量`，截获其`值`
- 对于`对象类型的局部变量`，连同所有权`修饰符`一起截获
- 以指针形式截获`局部静态变量`
- 不截获全局变量，静态全局静态变量


### 5.3 __block修饰符

- 一般情况下，对被截获变量进行==赋值==操作则需要添加`__block`修饰符

#### 5.3.1 __block修饰符使用时机

- 局部变量进行修改，==需要==使用`__block`
	- 基本数据类型
	- 对象类型

- ==不需要==使用`__block`
	- 静态局部变量
	- 全局变量
	- 静态全局变量

	
#### 5.3.2 __block修饰的变量变成了`对象`

![block变量变成对象的结构图](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/5/block%E5%8F%98%E9%87%8F%E5%8F%98%E6%88%90%E5%AF%B9%E8%B1%A1%E7%9A%84%E7%BB%93%E6%9E%84.png)


#### 5.3.3 MRC和ARC中的区别(原来所有情况都是考虑`block`在堆上，或者`block`跟对象相互持有的情况，网上的资料hhhhhhhhhhh)

- MRC中，由于没有所谓`强引用`和`弱引用`，只有`retainCount=0`回收跟`retainCount!=0`再让你高兴一会的情况，因此其实原先用不用`__block`真的问题不大，因为当你初始化完这个`block`，你都要考虑手动调用`release`。若然你把`block`复制到了堆上，如果你不调用这个`release`，那么这个`block`则一直得不到回收；若然只是在栈上调用了这个`block`，即使`block`引用了这个对象，但是只要这个作用域过去了，栈自然销毁`block`也不会存在循环引用。

- ARC中，是否使用`__block`都会引用循环引用。因为`block`本身截获变量就是引用该对象指针，当使用`__block`的时候，就是新建一个`block`对象引用该对象，`block`对象还是持有着该对象的指针



### 5.4 Block的内存管理

#### 5.4.1 Block分类

![Block分类](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/5/Block%E7%B1%BB%E5%9E%8B)

- 全局Block ---`__NSGlobalBlock__`
	- 没有访问任何外部变量
- 栈Block ---`__NSStackBlock__`
	- 访问了外部变量
- 堆Block ---`__NSMallocBlock__`
	- 使用了`copy`

**PS:** ARC中，==block默认是直接分配到堆中的，如果用`weak`修饰，就不会进行copy操作，仍然会在栈中==。如果作为==参数传递给函数==，那么如果这个==函数中没有使用到copy==，这个block还是会存在于栈中， 当函数结束后，这个block就会被释放，因此不需要使用weak。

**面试题:**  为什么block需要使用copy修饰符：
	由于在函数中使用block，如果block使用了外部变量，但如果此时block使用的是assign，在函数调用结束时，由于block和外部变量均是在栈中，在函数执行期间，可能存在提前释放外部变量的情况，导致引用错误。如果使用了copy，就会将block以及变量复制到堆中，就不会出现内存被回收引起异常。


#### 5.4.2 Block的copy操作

- 栈上的block会复制到堆上
- 堆上的block会增加引用计数
- 全局的block什么也不做

#### 5.4.3 `__forwarding`指针

保证无论`block`是在堆，还是栈上,`__forwarding`指针都能指向正确截获变量的地址

- 如果block在堆上，会指向堆上block的变量
- 如果block在栈上，会指向复制到堆中block的变量，该堆中的`__forwarding`指针遵循上一条



### 5.5 Block的循环引用

#### 5.5.1  MRC下


#### 5.5.2 ARC下

----
----
----
----
----
----
----
----
----
----
----
----