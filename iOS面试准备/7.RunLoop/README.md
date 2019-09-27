## 7 RunLoop


### 7.1 概念

#### 7.1.1 什么是RunLoop？

`RunLoop`是通过内部维护的**事件循环**来对**事件/消息进行管理**的一个对象.

#### 7.1.2 Event Loop

- 没有消息需要处理时，休眠以避免资源占用
	- 用户态 -> 内核态
- 有消息需要处理时，立刻被唤醒
	- 用户态 <- 内核态


面试题：main函数为什么能保持不退出？

main函数中调用`UIAplicationMain`函数中，会启动主线程中使用RunLoop，RunLoop是一种对事件循环的维护机制，在有事做的时候去做事，没有事的时候，可以对用户态到内核态进行切换，从而避免资源占用，使得线程休眠。

### 7.2 应用场景

[更多请参考：RunLoop总结：RunLoop的应用场景（n）](https://cloud.tencent.com/developer/article/1192474)

#### 7.2.1 常驻线程

创建一个线程，然后在线程获取RunLoop，并且往RunLoop添加source去运行，可以保持RunLoop存活，也能让线程保持不销毁，在一些短时间密集使用线程工作的情况下，可以降低建立销毁线程的消耗

#### 7.2.2 `NSTimer`和`UIScrollView`在RunLoop下mode的优先级竞争

在设置了一个`NSTimer`计时使用中，如果对`UIScrollView`进行滑动，这时候`timer`会停止更新动作，`scrollView`会优先。原因是主线程中的RunLoop的mode会发生切换。解决办法：

- 将timer添加到主线程的commondModes中，其实就是将timer同时都添加到两个mode中
- 使用另外的线程去运行timer计时

#### 7.2.3 UITableView加载优化

- 一般情况下,怎样保证子线程数据回来更新UI的时候不打断用户滑动<br>
可以将子线程数据回来这部分逻辑添加到主线程RunLoop的DefaultMode下，等UI更新完，重新回到DefaultMode的时候，再更新

- 从上面第二点知道，`UIScrollView`滑动的`UITrackingRunLoopMode`优先级更高，但是如果当前执行的mode还没有完成，那么这时候`UIScrollView`的滑动就会出现卡顿。这里的解决思路就是，监听主线程的RunLoop什么时候准备进入休眠，这个时候手动将大工作量的加载任务分次单个给主线程处理（私下让主线程偷偷干活），以此来避免滑动卡顿


#### 7.2.4 卡顿检测

从RunLoop一个循环周期可以知道，RunLoop主要的工作时间都是发出开始工作的通知后<->发出休眠通知以前。因此可以新添加一个线程，添加一个`observer`监听这两个时间点，并且通过一个计时器，在主线程开始工作之后，每隔`n`秒进行一次判断，看主线程是否还在工作，从而得出主线程是否出现了卡顿。


### 7.3 数据结构

`NSRunLoop`是`CFRunLoop`的封装，提供了面向对象的API。


#### 7.3.1 `CFRunLoop`

- `pthread`说明RunLoop与线程相关
- `currentMode`
- `modes`是当前线程能进行切换的mode集合
- `commonModes`集合，
	- 通常将source运行在`commonModes`下，即会把source添加到`commonModesItems`，提供所有mode使用
	- `CommonModes`不是实际存在的一种Mode，是同步Source/Timer/Observer到多个Mode中的一种技术方案
- `commonModeItems`

#### 7.3.2 `CFRunLoopMode`

- `name`
- `source0`手动唤醒线程
- `source1`具备唤醒线程
- `observer`
	- `kCFRunLoopEntry` 进入RunLoop
	- `kCFRunLoopBeforeTimers` 即将处理timer内容
	- `kCFRunLoopBeforeSources` 即将处理sources
	- `kCFRunLoopBeforeWaiting`即将进入休眠
	- `kCFRunLoopAfterWaiting`从休眠唤醒
	- `kCFRunLoopExit`即将推出RunLoop
- `timers`

#### 7.3.3 `Source/Timer/Observer`

- RunLoop 可以对应多个Model
- Model分别可以对应多个Source，Timer，Observer
- 如果在一个RunLoop下有多个Mode的时候，如果只运行在Mode A的时候，会屏蔽其它Mode。


### 7.4 事件循环机制

![RunLoop循环流程](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/7/RunLoop%E5%BE%AA%E7%8E%AF%E6%B5%81%E7%A8%8B.png)


### 7.5 RunLoop与多线程，RunLoop与AntoReleasePool关系

[参考：RunLoop总结：RunLoop 与GCD 、Autorelease Pool之间的关系](https://cloud.tencent.com/developer/article/1192476)

#### 7.5.1 GCD与RunLoop的关系

- `dispatch_srouce_t`关于超时时间，这个不太理解没什么关系，后面再补这个
- 底层上，主线程的RunLoop上，开了一个`port`给主队列进行传输，用于`dispatch_async`的时候，RunLoop往主队列上面获取任务，然后执行


#### 7.5.2 RunLoop与AntoReleasePool关系

- 有一个最高优先级的监听事件，在进入RunLoop前，回调是创建一个自动释放池，可以保证创建自动释放池在其他回调前
- 有一个最低优先级的监听事件，在RunLoop休眠前，和RunLoop退出前
	- 休眠前，保证所有回调执行完再进行释放，并且创建新的释放池
	- 退出前，保证所有回调都能执行完
 


-----
-----
-----
-----
-----
-----
-----
-----
-----