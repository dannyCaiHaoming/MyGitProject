## UI视图相关

### 1 UITableView相关

#### 1.1 重用机制
就是TableView会使用一个叫`重用池`，当屏幕显示`TableViewCell`的时候，会去这个`重用池`去拿，如果`重用池`没有的时候，就会新建一个`TableViewCell`；当这个`TableViewCell`移出屏幕，当前不显示的时候，就会被放入`重用池`，等待下次有需要使用的时候，直接从`重用池`去拿，减少创建的消耗。

#### 1.2 数据源同步问题
实际场景，就是当进行网络操作`LoadMore`的过程中，进行了一些删除的操作，就需要进行数据源同步的处理。

- 1.并发访问、数据拷贝
  - 会把进行在`子线程`进行网络请求前的数据进行一份`拷贝`，用于在请求异步过程中记录在`主线程`对数据做的一些增删改查操作。然后在网络请求回来之后，对比两份数据，然后也将记录的操作在拷贝的数据上进行，然后再做UI更新的操作。
	
- 2.串行访问
  - 使用一个`串行队列`，将`主线程`中的操作，以及`子线程`中的网络请求，都放入`串行队列`中。`串行队列`的任务会依据先来先执行的规则。但是由于是在`串行队列`中，如果有占用时长大的任务，会造成数据返回到`主线程`更新有延迟。


### 1.2 UIView和CALayer
[参考：《iOS三问》 -- CALayer基础](https://luochenxun.com/ios-calayer-overview/)

简单来说，应用`单一职责`的设计原理，将功能区分开，`UIView`用于传递绘制内容给`CALayer`并且由于继承自`UIResponder`，因此还具有响应触碰的；`CALayer`只是单纯的用于生成展示的内容（`content`其实也是最终的`位图`）。

有个比喻很好：**UIView是一副PS的图，而实际这个图上面是有很多个图层叠加而成的，这里面的图层其实就是CALayer**

- `UIView`其实只是一个容器，用于装载`CALayer`.**二者之间绘制的关系需要了解，这样在使用`CoreGraphics`做一些绘画的时候，才能做到用的明白**
- `UIView`实际只是通过传递内容给`CALayer`，通过`CALayer`绘图。
- `UIView`的frame决定了`CALayer`的可视空间
- `UIView`有视图树，对应`CALayer`的图层树


#### 1.2.1 CALayer是怎样显示的
- `CALayer`有一个`contents`属性，~~指向一块缓存区，称为`backing store`~~,可以存放位图（Bitmap）,通过赋值，可以在图层上显示你想要显示的图片。
- 你也可以自行绘图，然后经过处理之后最终也会变成类似`图片`
- `CALayer`无论使用的图片还是自定义绘制，最终展示就类似**纹理**，而**纹理**本质上就是一张图片

**PS:**`CALayer`的`content`，本质上是一个`Bitmap`位图信息，可以直接传递到GPU进行渲染。如果我们传入一个`CGImage`，即一个已经解码完成的数据，也就是`Bitmap`，是可以传到CPU进行渲染然后显示的。因此`content`不叫`Backing Store`,拜托`Backing Store`的概念查一下好吧，后备存储，效率比内存低，这里`Backing Store`是否在磁盘之上，我查不到什么。但是，只有在你使用`draw:inContext:`或者`drawLayer:inContext:`进行获取上下文进行绘制，在这之前，系统会使用`Backing Store`存储了你原来这个`layer`上的`content`！注意是相当于临时存放，因为你需要在原来的`layer`内容之上进行修改的呀大哥。因此你获取到的上下文，是从`Backing Store`中取出来的。有些文章说会通过`push`和`pop`方法在全局取出上下文进行操作，那么可以认为这个`Backing Store`是全局的一个图形上下文栈。等你对操作完的上下文修改后，就会重新赋值回`layer`的`content`属性，然后作为新的`Bitmap`传递到GPU进行渲染！！！

#### 1.2.2 绘制方法
- `CALayer`自带方法
	- `func display(_ layer: CALayer)` 可以重写该方法，主要用于设置`contents`属性
	- `func draw(_ layer: CALayer, in ctx: CGContext)`可以获取`context`，更加丰富的绘制入口

- `CALayerDelegate`
如果自带的方法没有实现，则可以使用`delegate`的方法
	- `func display(_ layer: CALayer)` **异步绘制的入口**
	- `func draw(_ layer: CALayer, in ctx: CGContext)`

#### 1.2.3 `UIView`绘制原理

![UI视图绘制原理](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/UI%E8%A7%86%E5%9B%BE%E7%BB%98%E5%88%B6%E5%8E%9F%E7%90%86.webp)

- 其实就是相当于`CALayer`进行了一次重新绘制
- 流程就是先判断有没有实现`CALayerDelegate`的方法-----`异步绘制`
- 然后才是`CALayer`自身的绘制方法-----`系统绘制流程`

##### 1.2.3.1 系统绘制流程

![系统绘制流程](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/%E7%B3%BB%E7%BB%9F%E7%BB%98%E5%88%B6%E6%B5%81%E7%A8%8B.webp)


#### 1.2.4 异步绘制

- 在`CALayer`中实现代理方法`displayLayer`
- 在里面使用异步线程创建一个新的图形上下文(也就是最终会作为`Bitmap`传递回`CALayer`的`content`属性)
- 然后在这个图形上下文中绘制内容
- 在结束绘制之后，将绘制内容作为`Bitmap`赋值到`content`属性


### 1.3 事件传递&视图响应

[参考：iOS事件处理，看我就够了~](https://segmentfault.com/a/1190000013265845)

#### 1.3.1 事件传递主要方法
- `func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?`返回最终响应的视图
- `func point(inside point: CGPoint, with event: UIEvent?) -> Bool`判断点击是否在视图范围内

##### 1.3.1.1 事件传递流程
- 用户点击屏幕，产生一个触控事件
- 事件传递到`UIAplication`的队列中，等待出列
- 事件在队列取出后会传到`UIWindow`，开始倒序遍历每个子视图
- 规则：调用`hitTest`(内部是`pointInside`)去查找子视图中，子视图是否包含点击区域，查找到最末尾的（最顶层的视图）之后，回传给`UIApplication`

![事件传递流程图](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/%E4%BA%8B%E4%BB%B6%E4%BC%A0%E9%80%92%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

##### 1.3.1.2 HitTest内部实现描述
- 从`UIWindow`为入口，每次检测视图的`可触控`、`透明`、`Alpha`都满足响应条件且点击是否落在视图上
- 倒序遍历视图的子视图，寻找最后一个（最上层一个）视图返回

![HitTest流程图](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/HitTest%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

#### 1.3.2 视图响应链

##### 1.3.2.1 一般响应流程
视图作为最顶层触控视图，会将触控事件从自身开始往下一级响应链，也就是父视图传递，如果一直没有找到`UIApplicationDelegate`也没有响应者，则这次触控会被忽略掉。

![响应流程图](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/%E5%93%8D%E5%BA%94%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

##### 1.3.2.2 手势识别(优先级比响应链高，提前终止)
众所周知，会接收掉该次触控响应，终止响应链流程继续。

##### 1.3.2.3 UIControl(不经由响应链，直接与`UIApplication`取得联系，Target-Action)

### 1.4 图像显示原理
[参考：iOS 图像渲染原理](http://www.chuquan.me/2018/09/25/ios-graphics-render-principle/)

整体历程：CPU->GPU->显示器

![图像显示原理](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/%E5%9B%BE%E5%83%8F%E6%98%BE%E7%A4%BA%E5%8E%9F%E7%90%86.png)

#### 1.4.1 CPU负责
- `Layout` 视图构建，在这个阶段，程序设置 View/Layer 的层级信息，设置 layer 的属性，如 frame，background color 等等。
- `Dsiplay` 视图绘制，在这个阶段程序会创建 layer 的 backing image，无论是通过 setContents 将一个 image 传給 layer，还是通过 drawRect：或 drawLayer:inContext：来画出来的。所以 drawRect：等函数是在这个阶段被调用的。
- `Prepare` 图像解码和转换，在这个阶段，Core Animation 框架准备要渲染的 layer 的各种属性数据，以及要做的动画的参数，准备传递給 render server。同时在这个阶段也会解压要渲染的 image。
- `Commit` 图层打包，在这个阶段，Core Animation 打包 layer 的信息以及需要做的动画的参数，通过 IPC（inter-Process Communication）传递給 render server。



#### 1.4.2 GPU负责
应该是类似Matel渲染流程

![GPU处理流程](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/1/GPU%E5%A4%84%E7%90%86%E6%B5%81%E7%A8%8B.png)

- 顶点着色器：构建顶点信息
- 形状装配：顶点连接起来，变成形状
- 几个着色器：
- 光栅化：就是把图像映射成最终需要点亮屏幕的像素
- 片段着色器
- 测试与融合


#### 1.4.3 UI卡顿掉帧的原因
- 每一帧需要产生一个画面，由CPU->GPU处理完最终生成画面。
- 如果这一帧时间超过了规定时间，`VSync`信道到来前没有准备好，就会产生掉帧卡顿

#### 1.4.4 滑动优化方案（两方面）
- CPU
	- 对象创建、销毁、调整放在子线程
	- 预排版（布局计算、文本计算）可以放到子线程，让主线程有更多空闲时间
	- 预渲染（文本等异步绘制、图片编解码）
- GPU
	- 纹理渲染
	- 视图混合


### 1.5 离屏渲染
- On-Screen Rendering
意为当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。

- Off-Screen Rendering
意为离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。

- 特殊的离屏渲染：
如果将不在GPU的当前屏幕缓冲区中进行的渲染都称为离屏渲染，那么就还有另一种特殊的“离屏渲染”方式： CPU渲染。
如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内 同步完成，渲染得到的bitmap最后再交由GPU用于显示。

#### 1.5.1 离屏渲染的触发方式

设置了以下属性时，都会触发离屏绘制：

- shouldRasterize（光栅化）
- masks（遮罩）
- shadows（阴影）
- edge antialiasing（抗锯齿）
- group opacity（不透明）
- 复杂形状设置圆角等
- 渐变

