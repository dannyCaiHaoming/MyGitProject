## 6 多线程


### 6.1 进程和线程的区别

用工厂车间去进行类比。

- 一个工厂源源不断进行处理产出（类比CPU工作）
- 一个工厂的电能有限，每次只能供一个车间进行工作（类比单核）
- 工厂的不同车间，既单独的运转，又能配合产出产品（进程内存地址独立，但是进程间能通信）
- 车间中的工人，在指定车间进行协同工作（进程可以包括多个线程，进程中的空间是对线程共享的）

其中需要补充的：

- CPU的调度单位是线程，一次只能执行一个线程，即是进程独占某时刻的CPU，但这个时刻的实际是，这个进程中的某个线程被处理了，

### 6.2 线程与队列的关系

- 队列是抽象结构，线程是系统级进行调度的单位
- 并行队列对应多个线程，串行队列对应一个线程（可能唯一，也可能被更换）
- 系统会将任务抽象得放置到队列上，然后要执行的时候， 系统会将这些任务分配到某个线程上执行，因此上层感觉任务是在队列等待，然后线程去执行

 
### 6.1 GCD 

Grand Central Dispatch（GCD） 是 Apple 开发的一个多核编程的较新的解决方法

[参考：iOS线程、同步异步、串行并行队列](https://juejin.im/post/5b28ca5de51d4558e03cc847)

[参考：iOS 多线程：『GCD』详尽总结](https://www.jianshu.com/p/2d57c72016c6)



#### 6.1.1 同步/异步 和 串行和并发

- 同步<br>
	同步不会开启新的线程，按顺序执行，执行完一个再执行下一个
- 异步<br>
	除了主线程异步，其它线程异步都会新开一个线程执行。并不等待原来线程中的任务执行。
- 串行队列<br>
	会对应一个线程，队列中的任务，按顺序被调度，只有前面的任务结束了，才会开始下一个
- 并行队列<br>
	对应多个线程，只要线程有空闲的就会去调用队列中的任务，可能不会等待（线程空闲的时候，可以开成无需等待即可执行）
		

##### 6.1.1.1 ==dispatch_sync==(串行队列，任务)

- `主线程`的同步方式引起的主队列循环等待死锁
- `串行队列`如果嵌套`引用同步执行`任务也是会引起死锁
- ==同步任务需要等待队列的任务执行结束==

##### 6.1.1.2 dispatch_async(串行队列，任务)

- `串行队列`异步执行，会开启新的线程，但是`主队列`不能够开启新的线程（阉割了）
- 由于有可能不需要等待线程空闲，因此任务执行可视为同时执行任务

##### 6.1.1.3 ==dispatch_sync==(并行队列，任务)

- `并行队列`同步执行，则还是在当前线程执行，还是得按照先来后到顺序

##### 6.1.1.4 dispatch_async(并行队列，任务)

- `并行队列`可以对应多个线程，因此同时执行任务数量局限于系统最大并发数

#### 6.1.2 dispatch\_barrier\_async

实现多读单写方案的使用

##### 6.1.2.1 dispatch\_barrier\_async

- 自己创建的并行队列，使用`异步栅栏调用`时，会先等待并发队列中的任务执行完再进行`栅栏调用`，不会阻塞调用`栅栏`的线程
- 使用全局并发队列，相当于是在并发队列异步执行，不会需要等待(按照我理解，就是自己创建的并发队列指定的线程，会先执行`栅栏`前面的内容，但是全局队列指定的线程，会寻找空闲的线程来执行，因此这里会相当于并发异步执行)

##### 6.1.2.2 disaptch\_barrier\_sync

- 自己创建的并行队列，同步提交到异步队列，然后执行`同步栅栏调用`时阻塞调用`栅栏的线程`
- 使用全局并发队列，相当于使用串行队列同步执行

**ps:**二者执行差异，就是`sync`和`async`的差异


#### 6.1.3 dispatch_group

实现A，B，C并发，完成后执行任务D

- 使用`dispatch_group`创建组
- 使用`dispatch_group_async`异步分派任务到并发队列
- 使用`dispatch_group_notify`当组中所有任务执行完将会调用这个回调


#### 6.1.4 dispatch_semaphore 信号量

A，B,C任务并发，且内部异步返回的时候，可以使用信号量，控制所有返回同时返回的时候，再继续执行后面的操作。


### 6.2 NSOperation

是基于 GCD 更高一层的封装，完全面向对象。但是比 GCD 更简单易用、代码可读性也更高。

需要和`NSOperationQueue`配合使用来实现多线程方案

- 添加任务依赖
- ==任务执行状态控制==
- 最大并发量

#### 6.2.1 任务执行状态(可以KVO监听)

- isReady
- isExecuting
- isFinished
- isCancelled

#### 6.2.2 自定义NSOperation

- 非并发的`NSOperation`：只需要实现`main`方法，在里面实现任务的开始和结束的逻辑就ok了，其它的状态，系统的`start`方法里面默认实现了

- 并发的`NSOperation`：需要实现`start`方法，所以不仅要实现任务的逻辑，而且还要手动使用`KVO`管理其它状态，并且这些状态对依赖的任务有影响




### 6.3 NSThread

![NSThread启动流程](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/6/NSThread%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B.png)

- 调用`pthread_create`函数创建一个`pthread`线程
- 调用`main`函数
- 通过`KVO`的方式告诉系统当先线程已经启动
- 调用`performSelector: withObject:`来执行我们创建线程时指定的`target`
- 调用`exit`退出线程。

**Q:实现常驻线程?**


### 6.3 锁
- NSRecursiveLock<br>
	可以==重入==加锁
- NSLock<br>
	不能重入加锁处理
- dispatch\_semaphore\_t 信号量<br>
	
- @synchoronized<br>
	一般在创建单例对象的时候使用
- atomic<br>
	修饰属性的关键字<br>
	只保证创建的时候线程安全
- OSSPinLock 自旋锁<br>
	==循环等待==询问，不释放当前资源<br>
	用于轻量级数据访问
	

