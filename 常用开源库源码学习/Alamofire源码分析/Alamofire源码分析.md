# Alamofire源码分析


- ## Session.swift
  `Session`负责创建和管理`Request`的类型。同时也提供了`Request`需要的所有功能，包括队列管理，中断请求，https证书管理，重定向，响应缓存处理。  
    
    
  ###  `Session`类的属性  
    
  - `session`:用底层的`URLSession`来创建`URLSessionTasks`提供给当前实例使用，并且提供`delegate`响应`URLSessionDelegate`的回调  
    
  - `delegate`:`SessionDelegate`的实例，用于处理`URLSessionDelegate`中的方法和`Request`的交互  
    
  ----
    
  - `rootQueue`:主的`DispatchQueue`，用于所有内部的回调和状态更新，必须是个串行队列  
    
  - `requestQueue`:在这之上可以异步创建`URLRequest`。默认这个队列是使用`rootQueue`，但是如果请求性能遇上瓶颈的时候，可以将请求业务分离到这个队列上完成  
    
  - `serializationQueue`: 将所有`Request`请求的响应处理放到这个队列上处理。默认也是使用主队列处理，同样也是处理瓶颈的时候可以把业务放过来  
    
    
  ----  
    
  - `interceptor`:默认`interceptor`为跟随`Session`的实例管理所有的`Request`的，但是也可以为`Request`单独指定`interceptor`  
    
  - `serverTrustManager`:用于https验证服务  
    
  - `redirectHandler`:用于提供`Request`作重定向  
    
  - `cachedResponseHandler`:提供自定的响应缓存机制  
    
  - `eventMonitor`:事件监听  
    
    
  ----  
    
  - `requestTaskMap`:`Request`和`URLSessionTasks`之间的映射关系  
    
  - `activeRequests`:当前执行中的`Request`  
    
    
  

- ## Almofire.swift
  这个文件里面没有使用`Almofire`去声明一个类，而是使用了全名命名空间去包含了所有`默认的``Session`的实例方法

