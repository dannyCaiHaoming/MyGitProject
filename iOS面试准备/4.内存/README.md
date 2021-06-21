## 4 内存


### 4.1 内存布局

[参考：程序内存布局](https://cloud.tencent.com/developer/article/1177538)

![内存布局图示1](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80%E5%9B%BE%E7%A4%BA.png)

从低地址往高地址：

- `.text(代码段)`：存放的是成程序编译好的代码段
- `.data(已初始化数据段)`：存放已经初始化的全局变量或者静态变量
- `.bss(未初始化数据段)`：存放未初始化的全局变量或静态变量
- `堆`：用于程序执行中，分配和销毁空间，用于存放程序执行中的变量，是`不连续的内存区域`
- `栈`：存储方法调用过程中的上下文，还有方法中的内部临时变量，程序在调用函数时，系统会自动调用压栈和弹栈完成保存函数现场的操作。栈是一块`连续的内存区域`

### 4.2 内存管理方法

#### 4.2.1 `TaggedPointer`

专门用于存储小对象的，例如`NSNumber`和`NSDate`，存储的不是对象，而是直接是值

#### 4.2.2 ==NONPOINTER_ISA==

![ISA指针数据结构1](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/ISA%E6%8C%87%E9%92%88%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%841.png)
![ISA指针数据结构2](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/ISA%E6%8C%87%E9%92%88%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%842.png)

- 在`arm64`架构下
	- 第1位，表示是否是指针型的`isa`指针，如果是非指针型的`isa`
	- 第2位，表示是否存在关联对象
	- 第3位，表示使用使用c++的内容
	- 接着后面33位，`shiftcls`，表示类对象地址
	- 有个不重要的magic
	- 标识是否存在弱引用指针
	- 是否正在进行`deallocating`
	- 是否使用额外的引用数表
	- 剩下的是引用计数值


#### 4.2.3 ==散列表==

- `SideTables()`结构
	- 包含64个`SideTable`，其实每一个都是一个`哈希表`

- `SideTable`结构
	- ==spinlock_t==自选锁
	- ==RefcountMap==引用计数表
	- ==weak\_table\_t==弱引用表

为什么不是使用一个`SideTable`:由于需要保证线程安全，那么当对这个`SideTable`操作的时候，就需要进行上锁处理，如果需要操作这个表的对象多的时候，就会陷入大部分时间都在等待锁。

- ==分离锁==

	`引用计数表`中引入了`分离锁`的概念，将一张表分拆成多个部分，对他们分别加锁，可以实现并发操作，提升执行效率
	- 每个`SideTable`中有一个`引用计数表`,在同一组中的8个`引用计数表`可以并发操作，若是分成8个锁，就需要串行进行处理。


- 如何快速根据一个对象查找对应`SideTable`----`哈希查找`
	- 根据`对象指针`，使用`Hash`函数，生成一个`key`,是`SideTables`中的数组下标


##### 4.2.3.1 Spinlock_t

- ==Spinlock\_t==是“忙等”的锁，如果这个锁被其他线程锁上了，当前线程会一直尝试获取，一直占有运行。
- 适用于轻量访问

#### 4.2.3.2 ==引用计数表==

- 使用`对象地址`进行`哈希算法`得到`key`，在`引用计数表`中查询得出`size_t`，进行获取和插入

- `size_t`,`unsign long`,实际是引用计数值

![引用计数表数据结构](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/%E5%BC%B1%E5%BC%95%E7%94%A8%E8%AE%A1%E6%95%B0%E8%A1%A8%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84.png)


#### 4.2.3.3 ==弱引用表==

- 使用`对象地址`进行`哈希算法`得到`key`，在`弱引用表中`可以查询出==weak\_entry\_t==

- `weak_entry_t`实际是一个数组，存储着指向该对象的`弱引用指针`


### 4.3 MRC & ARC

#### 4.3.1 MRC ---- 手动引用计数

- `alloc`
- `dealloc`
- ==retain==
- ==release==
- ==retainCount==
- ==autorelease==

#### 4.3.2 ARC ---- 自动引用计数

- ARC是==LLVM==和==Runtime==协作的结果
- ARC中禁止手动调用上面特殊标记的关键字
- ARC中新增==weak==,==strong==关键字



### 4.4 引用计数管理

#### 4.4.1 实现分析

- `alloc`
	- 只是调用C函数的`calloc`
	- 此时并没有对引用计数设置为1


- `retain`
	- 先在`SideTables`中查找到`SideTable`
	- 获取`SideTable`中`引用计数表`属性
	- 在`引用计数表`中，使用`哈希查找`到`size_t`，进行`+1`操作

			-(void)setName:(NSString *)name{
    		//如果不判断，可能会把原来对象释放
              if (_name != name) {
               [_name release];
               _name = [name retain];
            	}
            }

**PS**:由于`引用计数值`是从`第3位`开始，因此`+1`操作等于`+0x4`,获取引用计数值也需要先`右移2位`


- `release`
	- 跟上面前两步一样，最后一步做`-1`操作


- `retainCount`
	- 显示通过`哈希算法`在`SideTables`中查找到`SideTable`
	- 然后会有一个`refcnt_result=1`的局部变量
	- 然后会到`引用计数表`中查询**是否存在表示引用计数值**
	- 最终结果是将这个`引用计数值`加上`refcnt_result`

**PS**:因此，一开始这个对象在刚创建且没有被引用时，返回的值其实是默认的`refcnt_result`的局部变量值（默认值），没有设置到`引用计数表`中的值。


- `dealloc`

![dealloc实现流程](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/dealloc%E5%AE%9E%E7%8E%B0%E6%B5%81%E7%A8%8B.png)


### 4.5 弱引用管理

- 添加weak变量：weak指针，以及weak指针指向的对象地址
		根据对象地址，使用哈希算法在SideTables找到SideTable，并且根据对象地址找到`weak_table_t`，以对象地址使用哈希查找找到`weak_entry_t`，将weak指针地址存储到这个类似数组的`weak_entry_t`结构中

- weak指向的对象被销毁时，指向该对象的weak指针自动置为nil
		跟上面类似，会根据对象地址使用哈希算法寻找到`weak_entry_t`,然后将这个弱引用指针数组全部置为nil


### 4.6 自动释放池(在内存堆中创建，低地址往高地址)

[参考：自动释放池的前世今生](https://draveness.me/autoreleasepool)

- 是以==栈==为节点，通过==双向链表==的形式结合而成
- 是和==线程==一一对应

#### 4.6.1 `AutoreleasePool`的实现原理是怎样？

![AutoreleasePoolPage实现结构](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/AutoreleasePool%E5%AE%9E%E7%8E%B0%E7%BB%93%E6%9E%84.png)

#### 4.6.2 `AutoreleasePool`为何可以嵌套使用？


- 在当次`runloop`将要结束的时候调用`AutoreleasePoolPage::pop()`
- 多层嵌套就是多次插入`哨兵对象`
- 在for循环中alloc图片数据等内存消耗较大场景手动插入`autoreleasepool`


### 4.7 循环引用


#### 4.7.1 循环引用分类
	
- 自循环引用
对象跟成员对象之间
- 相互循环引用
对象A的成员是对象B，对象B的成员是对象A
- 多循环引用

#### 4.7.2 如何破除循环引用？

- 避免产生循环引用
	- `__weak`
	- `__block`

- 合适时机手动断环


#### 4.7.3 NSTimer的循环引用问题

![NSTimer循环引用问题图示](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/4/NSTimer%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8%E9%97%AE%E9%A2%98%E5%9B%BE%E7%A4%BA.png)

- 增加中间对象
- 在timer回调中销毁timer


### 4.8 内存对齐

#### 4.8.1 什么是内存对齐
就是数据不是散散，空间剩多少都能按百分比装进去，而是剩余空间要么能装进，不能就另外开辟空间放进去。因此这个也会产生一个结构布局的优化问题。例如两个`int`,一个`char`，不同顺序的话，占用的内存空间也是不一样的，这个就是内存对齐导致的。

```
struct s1{
	char y1;
    int x;
    char y2;
};

struct s2{
	char y1;
	char y2;
    int x;
};

int main()
{
    printf("%d\n",sizeof(s1);  // 输出12
	printf("%d\n",sizeof(s2);  // 输出8
    return 0;
}
```

#### 4.8.2  为什么要内存对齐
反例就是：一个`int`数据的4个字节可以随意存放，就变成需要读取多次不同的块，浪费大量内存读写和传输，浪费很多时间和空间。

#### 4.8.3 内存对齐规则（重要的一笔）
- `数据成员对齐规则`:结构体第一个成员的`偏移量`为0，以后每个数据成员的对齐按照`#pragma pack指定的数值`和`这个数据成员自身长度`中，比较小的那个进行。
- `结构(或联合)的整体对齐规则`:在数据成员完成各自对齐后，结构体本身也要进行对齐，对齐将按照`#pragma pack指定的数值`或`结构<最大数据成员长度中，比较小的那个>`
- 结构体总大小为`结构体最宽基本成员大小的整倍数`

#### 4.8.4 结构体中的内存对齐 （用一个个集装箱来类比块）
**结构内对齐大小，还会选择`#pragma pack`和较大的成员中较小的一个**
1. 第一个成员`偏移量`为0，然后比较当前成员的大小和`#pragma pack`指定大小，用最小的那个作为单位，若一个装不完则需要多开一个。
2. 第二个成员会从上一个成员用剩的箱子开始，如果剩下的空间装不下，则需要再另外开一个。然后重复第一步。

#### 4.8.5 `NSObject`内部默认对齐大小为8个字节。
即不会应用`选择pragma pack和较大的成员中较小的一个`这个规则
```
#pragma pack(push,2)
@interface Axxxx : NSObject {
    struct xxxx3 x3; // 为5个字节的内容
    void *p;
    char c;
}
@end
#pragma pack(pop)
// 最终输出是32. 一个isa指针，一个5字节内容，一个isa指针，一个1字节的char
// 如果是放到结构体中，则是16
```

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
----
----
----
----
----
----
----
----
