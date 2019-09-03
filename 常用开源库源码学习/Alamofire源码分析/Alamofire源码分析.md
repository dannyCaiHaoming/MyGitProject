# Alamofire源码分析


- ## Session.swift
  `Session`负责创建和管理`Request`的类型。同时也提供了`Request`需要的所有功能，包括队列管理，中断请求，https证书管理，重定向，响应缓存处理。  
    
    
  ###  `Session`类的属性  
    
  - `session`:用底层的`URLSession`来创建`URLSessionTasks`提供给当前实例使用，并且提供`delegate`响应`URLSessionDelegate`的回调  
    
  - `delegate`:`SessionDelegate`的实例，用于处理`URLSessionDelegate`中的方法和`Request`的交互  
    
  ————————  
    
  - `rootQeueu`:主的`DispatchQueue`，用于所有内部的回调和状态更新，必须是个串行队列  
    
    
  

- ## Almofire.swift
  这个文件里面没有使用`Almofire`去声明一个类，而是使用了全名命名空间去包含了所有`默认的``Session`的实例方法

