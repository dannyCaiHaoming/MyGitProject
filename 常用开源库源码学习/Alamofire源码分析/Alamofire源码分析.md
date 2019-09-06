# Alamofire源码分析


## ## Session.swift

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
  
  
### `request`,`download`,`upload`方法的设计  
  
- `Session`里面整合了`URLRequest`的各种方法，如`Request`,`Download`,`Upload`，而`Session`需要使用这几个方法， 就需要整合不同的原材料，因此在`Request`类中，分别又子类化了`DataRequest`,`DownloadRequest`,`UploadRequest`用于处理不同的请求。  
- 根据不同的`Request`原材料,`Session`中先是使用了不同的子结构（继承于`URLRequestConvertible`，可用于转成`URLRequest`去请求），将原材料聚合起来，然后转成中间成品`URLRequest`  
- 根据不同的中间成品`URLRequest`，才生成对应的`Request`子类

### ### URLRequestConvertiable

提供由不同工厂`Request`,`Download`,`Upload  
`零散的原料整合成统一`URLRequest`的方法

- #### RequestConvertible
  **Request**和**Download**使用  
    
  将`URLRequest`需要的以下原料先整合起来，然后提供`URLRequestConvertible`的协议供转成`URLRequest`的对象去使用  
  - `url:URLConvertible` 扩展了`String`，可以转成`URL`  
  - `method` 定义了`HTTP`的所有请求方法的结构体  
  - `parameters`  另外定义的字典类型，用于作为请求的参数  
  - `encoding` 声明对参数加密的方法  
  - `headers`  `HTTP`请求的头

- #### RequestEncodableConvertible 
  参数需要`Encoding`的`Request`,`Download`使用

- #### UploadConvertible
  **Upload**使用  
  - 提供使用`URL`上传文件,就是直接使用`ParameterlessRequestConvertible`构建原材料  
  - 如果使用`Data`或者`Stream`的话，就需要构建`UploadConvertible`去构造原材料

	- ##### ParameterlessRequestConvertible

### ### Perform

- ### request方法

- ### download方法

- ### upload方法

## ## Request.swift

## ## Almofire.swift

这个文件里面没有使用`Almofire`去声明一个类，而是使用了全名命名空间去包含了所有`默认的``Session`的实例方法

