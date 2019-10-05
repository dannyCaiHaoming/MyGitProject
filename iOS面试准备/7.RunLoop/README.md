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

![RunLoop循环流程](~/images/7/Runloop流程图.png)


### 7.5 RunLoop与多线程，RunLoop与AntoReleasePool关系

[参考：RunLoop总结：RunLoop 与GCD 、Autorelease Pool之间的关系](https://cloud.tencent.com/developer/article/1192476)<br>
[参考：带着问题看源码----子线程AutoRelease对象何时释放](https://suhou.github.io/2018/01/21/%E5%B8%A6%E7%9D%80%E9%97%AE%E9%A2%98%E7%9C%8B%E6%BA%90%E7%A0%81----%E5%AD%90%E7%BA%BF%E7%A8%8BAutoRelease%E5%AF%B9%E8%B1%A1%E4%BD%95%E6%97%B6%E9%87%8A%E6%94%BE/)

#### 7.5.1 GCD与RunLoop的关系

- Runloop时间超时的计算是使用GCD中的时钟功能，`dispatch_srouce_t`，更加进准，不受任务繁重影响
- `dispatch_async`的时候，RunLoop往主队列上面获取任务，然后执行



#### 7.5.2 RunLoop与AntoReleasePool关系
- 首先每个新建立的线程，都有自己一个`自动释放池`，这个默认的`自动释放池`是一次性的，会跟随线程退出而清空

- 如果线程启动了`runloop`
	- 有一个最高优先级的监听事件，在进入RunLoop前，回调是创建一个自动释放池，可以保证创建自动释放池在其他回调前
	- 有一个最低优先级的监听事件，在RunLoop休眠前，和RunLoop退出前
		- 休眠前，保证所有回调执行完再进行释放，并且创建新的释放池
		- 退出前，保证所有回调都能执行完
- `@autoreleasePool{}`就是上下文结束就释放，这是手动干预的


#### 7.5.3 事件响应

- 应用启动的时候，主线程默认会有注册一个基于`Source1`用来接收系统事件，回调函数是`__IOHIDEventSystemClientQueueCallback()`。

- 当手机发生触摸，锁屏，摇晃等，会由`IOKit`生成一个`IOHIDEvent`事件，传递给`SpringBoard`，并且随后会用mach port将事件转发给需要的App进程。

- 随后回到每个App主线程注册的`Source1`事件，就会触发回调，并调用 `_UIApplicationHandleEventQueue()` 进行应用内部的分发，这步骤是由于主线程注册了`Source0`的事件回调。

- `_UIApplicationHandleEventQueue() `会将`IOHIDEvent`处理并打包成UIEvent，然后就开始`UIApplication`事件队列的传递


#### 7.5.4  手势识别

- 上面的`_UIApplicationHandleEventQueue() `识别了一个手势时，会先`Cancel`将当前的`touch`系列回调打断，然后将对应的`UIGestureRecognizer `标记为待处理。

- 苹果注册了一个 `Observer` 监测`BeforeWaiting`(Loop即将进入休眠) 事件，这个Observer的回调函数是`_UIGestureRecognizerUpdateObserver()`，其内部会获取所有刚被标记为待处理的 `GestureRecognizer`，并执行`GestureRecognizer`的回调。

 
#### 7.5.5 计时器

- `NSTimer`中计时，是将`timer`作为`source`加入到当前线程的runloop，所以如果线程中的runloop没有启动，则这个`timer`也会无效。
同时，如果计时器运行过程中，runloop的任务繁重，那么这个计时器的计时也会出现不准确。
- `CADisplayLink `跟`NSTimer`一样，只是实现的逻辑不一样，比较接近屏幕刷新率的时间。


#### 7.5.6 界面更新

当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。

苹果注册了一个 Observer 监听 `BeforeWaiting`(即将进入休眠) 和 `Exit `(即将退出Loop) 事件，回调去执行一个很长的函数：
_ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。

````
_ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()
    QuartzCore:CA::Transaction::observer_callback:
        CA::Transaction::commit();
            CA::Context::commit_transaction();
                CA::Layer::layout_and_display_if_needed();
                    CA::Layer::layout_if_needed();
                        [CALayer layoutSublayers];
                            [UIView layoutSubviews];
                    CA::Layer::display_if_needed();
                        [CALayer display];
                            [UIView drawRect];

````

-----
-----
-----
-----
-----
-----
-----
-----
-----