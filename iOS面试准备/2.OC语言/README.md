## 2. OC语言

### 1. 分类(Category)

#### 1.1 使用分类完成过哪些事情

- 声明私有方法
- 分解体积庞大的类(将不同的功能组织到不同的分类中)
- Framwork的私有方法公开
- 模拟`多继承`

#### 1.2 分类的特性

- 运行时决议，因此在编译时该对象的内存布局已经确认，因此不能再动态添加实例变量，会破坏该类的内存布局
- 分类只能添加属性（声明`setter`和`getter`方法），并不能添加实例变量
- 分类会`覆盖`原类的方法，也会`覆盖`比它**先编译**的分类的方法

#### 1.3 分类的原理
[参考：深入理解 Objective-C](https://devhe.com/2019/02/14/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3-Objective-C-%E2%98%9E-Category/)
分类实际上也是通过结构体实现--`Category_t`

- 这里需要先补`Runtime`的知识，了解`Class`的内部结构
- 在运行时，`类对象`会调用`attachCategories`函数去把类中的分类拼接上
- `倒序遍历`，将每个分类中的`方法`,`属性`,`协议`各自生成一个二维数组
	- `method_list_t **mlists`
	- `property_list_t **proplists`
	- `protocol_list_t **protolist`
- `attachLists`实现新旧二维数组的拼接，将原数组复制到新内容数组的最后一位，然后将倒序排序的分类数组内容按顺序在新数组的首位开始放置
![类拼接分类方法示例](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/2/%E5%88%86%E7%B1%BB%E6%89%A9%E5%B1%95%E6%96%B0%E6%97%A7%E6%95%B0%E7%BB%84%E6%8B%BC%E6%8E%A5%E5%8E%9F%E7%90%86.png)

#### 1.4 使用关联对象为分类添加属性
主要使用到两个方法：

- `objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
                         id _Nullable value, objc_AssociationPolicy policy)`
- `objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)`

#### 1.5 关联对象的本质
`AssocationsManger`维护了一个`spinlock_t`，保证关联对象修改属性的时候是线程安全。

![关联对象底层实现](https://github.com/dannyCaiHaoming/MyGitProfject/blob/master/iOS%E9%9D%A2%E8%AF%95%E5%87%86%E5%A4%87/images/2/%E5%85%B3%E8%81%94%E5%AF%B9%E8%B1%A1%E5%BA%95%E5%B1%82%E5%AE%9E%E7%8E%B0.webp)


### 2. 扩展(Extension)----分类和扩展最好还是对比的来记

#### 2.1 扩展的用途
用于隐藏类的私有信息，但是必须能查看并修改到这个类的`.m`文件。

- 声明私有属性
- 声明私有方法
- 声明私有变量

#### 2.2 扩展的特性

- 编译时决议
- 一般在`.m`文件中声明并且实现


### 3. 代理---和block的区别

- 一对一，只能返回一个变量，swift中可以用元组返回多个
- 使用的时候要分开`委托方`和`代理方`
- delegate的运行成本较低，不需要将上下文数据进行出栈入栈等操作
- 设置了`weak`就能避免循环引用，

### 4. 通知

#### 4.1 通知和代理及block的比较
- 基于`观察者模式`，多用于`跨层``一对多`进行消息传递

#### 4.2 通知的实现原理

![通知实现原理]()

### 5. KVO




### 6. KVC

### 7. 属性关键字