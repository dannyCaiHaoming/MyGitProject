12 第三方开源库


### 12.1 界面流畅相关

阻塞主线程的任务，主要分为

- 文本和布局的计算
- 渲染
- 解码
- 绘制

这几种都可以通过各种方式在子线程进行异步执行，`UIKit`和`Core Animation`相关操作必须在主线程。

#### 12.1.1 AsyncDispalyKit
自定义一套代替`UIKit`的架构，围绕`ASDisplayNode`对`View`和`layer`进行子线程调度。

核心就是将cpu耗时工作，例如：对象创建，文本绘制，图片解码，元素绘制等能从主线程执行的操作脱离，对一些只能在主线程完成的任务，使用Runloop的机制，在准备休眠或者休眠唤醒的时候执行。

![ASDK框架基本概念]()

- `UIView`和`CALayer`<br>
	在创建`UIView`的时候，提供了一个方法判断是否需要使用`UIView`的特性，如果没有，则会直接使用`CALayer`进行渲染，绕过了`UIView`，节省了大量渲染时间和内存占用。
	
- 视图层级<br>
	- `_ASDisplayView`和`_ASDisplayLayer`的对应关系跟`UIView`和`CALayer`完全相同。<br>
	- setNeedsDisplay<br>
		- 当`ASDisplayNode`在主线程调用的时候，则进入UIKit的更新<br>
		- 若在子线程，则进行异步渲染流程，监听主线程runloop将要休眠再进行绘制
	- willMoveToWindow视图层次变化<br>
		- 会使用光栅化对图层进行合并
		- 判断`content`是否为空，调用`[CALayer setNeedsDisplay]`方法标记，等待重绘




#### 12.1.2 YYKit


​		
### 12.2 内存泄漏检测

#### 12.2.1 MLeaksFinder 检查没有释放对象

原理就是在页面消息前`viewDidDisappear`，hook的方法里面添加一个`willDealloc`的方法，就是实现一个`dispatch_async_after`持有一个当前viewControlelr的`weak`指针，然后执行一个打印也好，弹框也好，断言也好，的方法，如果viewcontroller没有释放，那么这个方法就会执行。

#### 12.2.2 FBRetainCycleDetector 查找循环引用

- 通过有向图的DFS查找，找出对象是否有循环引用
- 使用对象的`Ivar Layout`查找到对象中的强引用
	
	
	​	
	
	
	





