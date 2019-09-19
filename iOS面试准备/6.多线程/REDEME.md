## 6 多线程

 
### 6.1 GCD

#### 6.1.1 同步/异步 和 串行和并发

##### 6.1.1.1 ==dispatch_sync==(串行队列，任务)

##### 6.1.1.2 dispatch_async(串行队列，任务)

##### 6.1.1.3 ==dispatch_sync==(并行队列，任务)

##### 6.1.1.4 dispatch_async(并行队列，任务)

#### 6.1.2 dispatch\_barrier\_async

实现多读单写方案的使用


#### 6.1.3 dispatch_group


### 6.2 NSOperation

需要和`NSOperationQueue`配合使用来实现多线程方案

- 添加任务依赖
- ==任务执行状态控制==
- 最大并发量

#### 6.2.1 任务执行状态

- isReady
- isExecuting
- isFinished
- isCancelled




### 6.3 NSThread

实现常驻线程


### 6.3 锁
- NSRecursiveLock
- NSLock
- dispatch_semaphore_t
- @synchoronized
- atomic
- OSSPinLock

