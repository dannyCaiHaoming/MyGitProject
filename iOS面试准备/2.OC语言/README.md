## 2 OC语言

### 2.1 分类(Category)

#### 2.1.1 使用分类完成过哪些事情

- 声明私有方法
- 分解体积庞大的类(将不同的功能组织到不同的分类中)
- Framework的私有方法公开
- 模拟`多继承`

#### 2.1.2 分类的特性

- 运行时决议，因为在编译时该对象的内存布局已经确认，~~是已经编译好放在的内存的代码区~~，因此苹果的分类结构以及类合并分类的过程中，也没有提供插入成员变量的实现。毕竟这是很危险的操作。
- 分类只能添加属性（声明`setter`和`getter`方法），并不能添加实例变量。实例变量需要满足以下条件：
	- 声明了一个成员变量
	- 并且实现了`setter`和`getter`方法
- 分类会`覆盖`原类的方法，也会`覆盖`比它**先编译**的分类的方法

#### 2.1.3 分类的原理
[参考：深入理解 Objective-C](https://tech.meituan.com/2015/03/03/diveintocategory.html)

分类实际上也是通过结构体实现---`Category_t`

- 这里需要先补`Runtime`的知识，了解`Class`的内部结构
- 后来想，运行时怎么去查找这个类的分类信息？
	- 其实这个类的一些分类信息，在编译期间已经添加到类的结构上，因此其实不用导入头，也可以使用`perform`直接指定方法去发送，只不过具体函数内容，就得运行时才能知道是哪个了
- 在运行时，`类对象`会调用`attachCategories`函数去把类中的分类拼接上
- `倒序遍历`，将每个分类中的`方法`,`属性`,`协议`各自生成一个二维数组
	- `method_list_t **mlists`
	- `property_list_t **proplists`
	- `protocol_list_t **protolist`
- `attachLists`实现类的内容及所有分类内容的拼接（新数组大小=原来类的内容+所有分类内容），将原数组复制到新内容数组的最后一位，然后将倒序排序的分类数组内容按顺序在新数组的首位开始放置

![类拼接分类方法示例](\../images/2/分类扩展新旧数组拼接原理.png)

#### 2.1.4 使用关联对象为分类添加属性
主要使用到两个方法：

- `objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
                         id _Nullable value, objc_AssociationPolicy policy)`
- `objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)`

#### 2.1.5 关联对象的本质
`AssocationsManger`维护了一个`spinlock_t`，保证关联对象修改属性的时候是线程安全。

![关联对象底层实现](\../images/2/分类底层实现.png)


### 2.2 扩展(Extension)----分类和扩展最好还是对比的来记

#### 2.2.1 扩展的用途
用于隐藏类的私有信息，但是必须能查看并修改到这个类的`.m`文件。

- 声明私有属性
- 声明私有方法
- 声明私有变量

#### 2.2.2 扩展的特性

- 编译时决议
- 一般在`.m`文件中声明并且实现


### 2.3 代理---和block的区别

- 一对一，只能返回一个变量，swift中可以用元组返回多个
- 使用的时候要分开`委托方`和`代理方`
- delegate的运行成本较低，不需要将上下文数据进行出栈入栈等操作
- 设置了`weak`就能避免循环引用
- 代理注重过程，通常去到每一步都会有一个delegate回调。当需要注册的事件较多的时候选用delegate
- block注重结果，返回的结果也比较单一

### 2.4 通知

#### 2.4.1 通知和代理及block的比较
- 基于`观察者模式`，多用于`跨层` `一对多`进行消息传递

#### 2.4.2 通知的实现原理

![通知实现原理](\../images/2/通知实现原理.png)

##### 从怎么发送一个`NSNotification`说起。
1. 如果我们使用`addObserver:selector:name:object:`方法注册
2. 会根据`name`,生成一个哈希表，`key`是这个`name`,`value`是一个哈希表
   1. 这个哈希表`key`是这个`object`,而`value`是一个链表结构相连的`notification`对象
   2. `notification`对象存有`info`,`selector`,`observer`
3. 如果没有传入`name`，那么就会在一个`nameless`的哈希表中查找`object`对应的`notification`，其实就是少了第一级根据`name`查找哈希表的过程
4. 如果`name`,`object`都为空，那么就会在一个`wildcard`(通配符的意思)的链表中查找`notification`

##### `NSNotification与多线程`
1. 线程安全的，接受消息很发送消息是同一个线程。但是可能会出现消息返回的时候，`observer`对象已经销毁的情况。`[weak self]`能解决
2. 通知的执行是`同步`的，即通知`post`方法需要等到`observer`处理完才能继续下文
3. 线程`重定向`的思维扩展
   1. 使用一个队列维护需要处理的`Notification`
   2. 当消息回来的时候，判断当前的线程是否是目标线程
   3. （需要锁的操作，保证线程安全）如果不是，则将这个消息放进队列里面，并且触发`runloop`发送消息，如果是则执行
   4. 在`runloop`触发的时候，（需要锁的操作，保证线程安全）从队列中取出消息执行


### 2.5 KVO

#### 2.5.1 KVO使用

- 注册成为观察者:
	- `addObserver:forKeyPath:options:context`
- 设置需要观察对象的属性,(如果是成员变量需要手动设定KVO，因为系统不会自动生成setter方法和getter):
	- object.property = XXX
	- [object setValue forKey]
- 在回调方法中处理变更通知
	- `observeValueForKeyPath:ofObject:change:context:`
- 在不再使用的时候移除观察者
	- `removeObserver: forKeyPath:`

#### 2.5.2 KVO设置兼职观察依赖健
例如一个对象的A属性依赖于B，C。
可以手动实现A属性的setter和getter方法，并且实现

- `keyPathsForValueAffecting属性A名字`或者
- `keyPathsForValuesAffectinValueForKey:`告诉系统属性A依赖于B，C。

#### 2.5.3 KVO实现原理

- 当某个类的对象第一次被观察时，系统会为该类派生一个子类，然后在该子类中会重写被观察的属性的`setter`方法。
- 会在setter方法中添加`willChangeValueForKey:`,`didChangeValueForKey:`
- 除此之外，系统还重写了Class的方法，让开发者误以为还是调用原来的类，这个对象的`isa指针`会指向新的派生类。


### 2.6 KVC--键值编码
是`NSObject`类别的`NSKeyValueCoding`的非正式协议。

#### 2.6.1 KVC的实现原理
其实就是搜索键的过程，然后赋值。在搜索成员变量的时候，先搜索`_`(带下划线)的。

##### 2.6.1.1 `setValue:forKey:`方法的搜索过程

- 先查询`setter`方法，`set<key>`,`_set<key>`
- 检查`accessInstanceVariablesDirectly`是否为真
- 查询实例变量`_key`,`_isKey`,`key`,`isKey`
- 属性`setter`或实例变量都没查找出来，则调用`setValue:forUndefineKey:`

##### 2.6.1.2 `valueForKey:`方法的搜索过程

- 先检查`getter`方法，`get<key>`,`<key>`,`is<key>`
- 然后检索`NSArray`的检索方法
- 然后检索`NSSet`的检索方法
- 检查`accessInstanceVariablesDirectly`是否为真
- 查找实例变量`_key`,`_isKey`,`key`,`isKey`
- 如果都没有，则调用`valueForUndefinedKey:`


### 2.7 属性关键字(加粗的是默认关键字)

#### 2.7.1 读写

- `readonly`
- **`readwrite`**


#### 2.7.2 原子

- **`atomic`**
- `nonatonmic`

##### 2.7.2.1 atomic的实现及是否线程安全
问题1： 旧版是用自旋锁实现，新版是用互斥锁实现。
原因是自旋锁当一个低优先级的线程得到锁，高优先级的线程就会处于忙等且一直获得CPU的时间片，低优先级的线程一直无法完成任务。
问题2： atomic底层实现只能保证读写的时候安全，及两个线程同时读取之后，分别进行其他运算操作之后，这时候就无法保证这两个运算操作的先后顺序，即有可能对同一个数值进行了同样的操作。


#### 2.7.3 引用计数

##### 对象

- `retain`
- **`strong`**

##### 避免循环引用

- `weak`
- `copy`
- `unsafe_unretained`


##### C语言基础类型及一些基础数类型

- **`assign`**



#### 2.7.4 `浅拷贝`是指针复制，`深拷贝`是内容复制
Q：**用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？**

- 使用`strong`进行指针赋值操作的时候，会简单的进行指针赋值，如果这个时候，本来希望这个`NSArray`是不可变的话，但是赋值一方传入了`NSMutableArray`对象，(NSArray有可变子类NSMutableArray)并且在其他地方进行了修改，那么`self.array`就可能被修改了

Q: **NSMutable对象，经常使用strong关键字，为什么**

- 原因是如果使用copy对象，那么无论使用何种方式进行赋值，那么这个`self.mArray`都是得到一个不可变对象，如果在后续代码相对此可变数组进行操作，那么就会出现不可变数组找不到可变数组的方法。


#### 2.7.5 Copy和MutableCopy
	 
    NSArray *arr1 = [NSArray arrayWithObject:@"arr1"];
	NSMutableArray *mArr1 = [NSMutableArray arrayWithObject:@"mArr1"];
	
	NSLog(@"inArray copy---%@",[[arr1 copy] class]);
	NSLog(@"inArray mutableCopy---%@",[[arr1 mutableCopy] class]);
	
	NSLog(@"mArray copy---%@",[[mArr1 copy] class]);
	NSLog(@"mArray mutableCopy---%@",[[mArr1 mutableCopy] class]);
	 
	 
	inArray copy---__NSSingleObjectArrayI
 	inArray mutableCopy---__NSArrayM
	mArray copy---__NSSingleObjectArrayI
	mArray mutableCopy---__NSArrayM
	
**结论：**

- `copy` 浅复制，都是得到不可变对象
- `mutableCopy`深复制，都是可变对象


**补充一些内容**

- `atomic`的实现机制，为什么不能保证绝对线程安全
- `isMemberOfClass`相关的一些方法
- 

-----
-----
-----
-----
-----
-----
-----

