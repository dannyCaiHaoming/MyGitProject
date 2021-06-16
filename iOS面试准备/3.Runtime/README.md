## 3. Rumtime


### 3.1 数据结构

#### 3.1.1 `objc_object`
`Objective-C`中面向对象指的是所有内容均是类（排除从C集成过来的结构体和基本数据类型）

`objc_object `结构体主要属性有:

- `isa_t` 实际上是一个共用体，
- `关于isa`操作相关
- `弱引用相关`
- `关联对象相关`
- `内存管理相关`



#### 3.1.2 `objc_class`
OC中用`Class`来表示类对象，而`Class`实际上是`objc_class`,继承于`objc_object`,所以也是一个类对象

`objc_class`结构体主要属性有:

- `Class superClass`指向父类对象
- `cache_t cache`方法缓存的一个结构
- `class_data_bits_t bits`类的主要变量属性方法协议都在这个结构体里面



#### 3.1.3 `isa指针`

- 在64位结构下，`isa`指针分为
	- `指针型isa`
	- `非指针型isa`
- `isa指向`
	- 关于对象，其指向`类对象`
	- 关于类对象，其指向其`元类对象`



#### 3.1.4 `cache_t`

- 用于快速查找方法执行函数
- 是可增量扩展的哈希表结构
- 是`局部性原理`的最佳应用（类比CPU中也是有缓存，将常用的内容缓存起来）

![cache_t结构图](\../images/3/cache_t结构图.png)
`cache_t`的哈希表构造如何处理冲突：**开放地址法**



#### 3.1.5 `class_data_bits_t`

- `class_data_bits_t`主要是对`class_rw_t`的封装
- `class_rw_t`代表类的相关读写信息，还可以在运行时进行修改的
- `class_ro_t`代表类相关的只读信息，在编译时已经确认的



#### 3.1.6 `class_rw_t`
结构体包含的成员有:

- `class_ro_t`
- `protocols`
- `properties`
- `methods`

ps:`properties`,`protocols`,`methodList`在这里是二维数组，会在运行时将先最后编译的分类的内容添加到这个二维数组的前面，最后才将原来类中的`class_ro_t`的内容加上

[具体在2.1.3的分类的原理中有说明](https://github.com/dannyCaiHaoming/MyGitProfject/tree/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/2.OC%E8%AF%AD%E8%A8%80#213-%E5%88%86%E7%B1%BB%E7%9A%84%E5%8E%9F%E7%90%86)




#### 3.1.7 `class_ro_t`
结构体包含的成员有:

- `name`
- `ivars`声明或定义的成员变量
- `properties`属性
- `protocols`
- `methodList`

ps:`properties`,`protocols`,`methodList`是一维数组，在编译期间确认好



#### 3.1.8 `method_t`
函数四要素

- 名称
- 返回值
- 参数
- 函数体（实现）

实际上对应的是`method_t`的结构

- `SEL name`名称
- `const char* types`返回值和参数，使用`Type Encodings`
- `IMP imp`函数体



#### 3.1.9 整体数据结构

![Runtime整体数据结构](\../images/3/Rumtime整体数据结构图.png)



### 3.2 类对象与元类对象

- `类对象`存储实例方法列表等信息
- `元类对象`存储类方法列表等信息

![对象类元类之间关系](\../images/3/对象类元类之间关系.png)


 
### 3.3 消息传递


![消息传递流程](\../images/3/消息传递流程.png)

##### 3.3.1.1 `objc_msgSend `
OC中的函数调用叫做`消息传递`，原因是

    [self class];
    //等同于
    objc_msgSend(self,@selector(class));
    
    
##### 3.3.1.2 `objc_msgSendSuper`

	[super class];
	//等同于
	objc_msgSendSuper(super,@selector(class));
	
##### 3.3.1.3`objc_super`结构体，实际上消息接收者还是调用者本身
	
	stuct objc_super {
	__unsafe_unretained id receiver;//指向调用者本身
	}

#### 3.3.2 方法缓存
方法缓存查找的过程实际是一个`哈希查找`的过程

 - 使用`SEL`方法选择器，使用哈希算法，得出一个哈希值的`key`
 - `key`的值，其实是该方法在`bucket_t`数组中的索引位置

 
#### 3.3.3 当前类中查找

- 对于`已排序好`的列表，采用`二分查找`算法查找方法对应执行函数
- 对于`未排序`的列表，采用`一般遍历`方法查找对应执行函数


#### 3.3.4 当前类的`SuperClass`逐级进行`查找缓存`和`类中查找`

 
 
### 3.5 消息转发
[参考：iOS开发·runtime原理与实践](https://juejin.im/post/5ae96e8c6fb9a07ac85a3860#heading-16)

[参考：深入浅出理解消息的传递和转发机制](https://www.cnblogs.com/zhanggui/p/7731394.html)

![消息转发流程](\../images/3/消息转发流程.pngg)

#### 3.5.1 动态方法解析：Method Resolution
OC运行时调用`+ (BOOL)resolveInstanceMethod:`或者 `+ (BOOL)resolveClassMethod:`，让你有机会提供一个函数实现

#### 3.5.2 快速转发：Fast Forwarding
OC运行时通过调用`- (id)forwardingTargetForSelector:(SEL)aSelector`,允许你替换信息的接收者为其他对象

#### 3.5.3 完整消息转发：Normal Forwarding
- `- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector`先获得一个方法签名
- `- (void)forwardInvocation:(NSInvocation *)invocation `将方法签名传过来的`NSInvocation`进行处理


#### 3.5.4 Fast Forwarding对比Normal Forwarding

- 需要重载的API不同
- 转发的对象个数不一样
	- 前者只能指定一个，后者可以自定义多个



### 3.6 Method-Swizzling（方法混淆）
实际上是修改选择器(`SEL`)对应的方法实现(`IMP`)

![方法混淆](h\../images/3/方法混淆.png)


### 3.7 动态添加方法

	//使用消息转发第一阶段运行时添加方法。
	+ (BOOL)resolveInstanceMethod:(SEL)sel{
		if (){
		  class_addMethod(self,@selector(test),testIMP,"V@:");
		  return YES;
		}
		return [super resolveInstanceMethod:sel];
	}


### 3.8 动态方法解析

**@dynamic**

- 动态运行时语言将函数决议推迟到运行时
- 编译时语言在编译期进行函数决议

### 3.9 load和initialize

#### 3.9.1 load

````
Invoked whenever a class or category is added to the Objective-C runtime; implement this method to perform class-specific behavior upon loading.
````

苹果注释的内容，解释了`load`方法加载的时机，就是在每个类或者分类即将被使用的时候就会调用。<br>
**PS:**这里还有个特殊就是每个类的`load`方法只会在加载的时候调用一次，除非分类也实现了`load`方法，然后会多调用一次，并且会覆盖原来`load`方法。子类复写`load`方法并不会覆盖父类方法，因为`load`方法的调用不会通过`objc_msgSend`到类中逐级查找，而是通过`SEL`地址直接找到方法实现。

#### 3.9.2 initialize

````
Initializes the class before it receives its first message.
````

同样苹果的注释，解释了`initialize`调用的时机是第一次类接收到消息的时候。因此`initialize`方法可能永远不会被调用。并且`initialize`方法调用的顺序和普通方法一样，因此会被子类或者分类覆盖。


#### 3.10 面试题

- 能否像编译后的类中增加实例变量