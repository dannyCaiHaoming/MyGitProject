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
![类拼接分类方法示例]()

#### 1.4 使用关联对象为分类添加属性
主要使用到两个方法：

- `objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
                         id _Nullable value, objc_AssociationPolicy policy)`
- `objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)`

#### 1.5 关联对象的本质
`AssocationsManger`维护了一个`spinlock_t`，保证关联对象修改属性的时候是线程安全。

![关联对象底层实现]()



### 2. 扩展(Extension)----分类和扩展最好还是对比的来记

#### 2.1 扩展的用途
用于隐藏类的私有信息，但是必须能查看并修改到这个类的`.m`文件。

- 声明私有属性
- 声明私有方法
- 声明私有变量

#### 2.2 扩展的特性

- 编译时决议
- 一般在`.m`文件中声明并且实现

### 2. 关联对象

### 3. 扩展

### 4. 代理

### 5. 通知

### 6. KVO

### 7. KVC

### 8. 属性关键字