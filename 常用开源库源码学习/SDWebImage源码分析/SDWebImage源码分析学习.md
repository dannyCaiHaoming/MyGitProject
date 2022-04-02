# SDWebImage源码分析学习


## ==业务层==

**UI层调用业务层顺序**  


- UI层  
	- `UIView+WebCache`分类会调用`sd_internalSetImageWithURL`  
  
- 业务层  
	- `SDWebImageManager`调用`loadImageWithURL`开始进入获取图片逻辑，返回一个`SDWebImageCombinedOperation`,将`查找缓存`及`下载图片`两个操作合在一起的类  
	-  每次调用都会重新生成一个全新的`SDWebImageCombinedOperation`，然后使用这个对象进行对`查找缓存`及`下载图片`两个操作的初始化。  
	- `查找缓存的初始化`  
		- 使用`SDWebImageManager`下的`SDImageCache`成员变量，调用`queryImageForKey`方法  
		- 先从内存查找，然后再到磁盘查找，内存查找的会直接返回图片以及空的`NSOperation`；磁盘查找会返回一个`NSOperation`，赋值到`SDWebImageCombinedOperation`的`cacheOperation`  
	- `下载图片`  
		- 在查找缓存完接着就是下载图片的逻辑  
		- 使用`SDWebImageManager`下的`SDImageLoader`成员变量，调用`requestImageWithURL`方法  
		- 由`SDWebImageDownloader`负责实现`requestImageWithURL`方法  
		- 维护了一组对象，`SDWebImageDownloadToken`是对`SDWebImageDownloaderOperation`的多一层封装，原本的`SDWebImageDownloaderOperation`已经是拥有了下载的`NSURLRequest`以及下载进度、下载完成的回调  
		- 以`URL`的MD5作为`key`对应的只有一个`SDWebImageDownloaderOperation`，但是如果是多个同样的图片下载，这种机制就相当于，多张图片下载的处理逻辑能对应多个`SDWebImageDownloadToken`  
		- `SDWebImageDownloadToken`是对应每一个下载；`SDWebImageDownloaderOperation`是对应一个下载操作  
  
		- 最终是SDWebImageDownloadToken`作为`operation`赋值到`SDWebImageCombinedOperation`的`loaderOperation`  
		

### SDWebImageManager(中心管理处)

`SDWebImageManager`是隐藏在UI层后面的。用于联系`异步下载器`(SDWebImageDownloader)和`图片缓存器(SDImageCache)`

- #### \<SDImageCache\>图片缓存协议
  `SDImageCache`的协议声明在`SDImageCacheDefine`里面。<br>  
  
  主要声明了增删改查等几类方法：  
  
  ````  
  /* ———————定义了提供给SDWebImageManager使用的接口———— */  
    
  ///主要提供给SDWebImageManager使用，在内存+磁盘中进行缓存查询  
  - (nullable id<SDWebImageOperation>)queryImageForKey:(nullable NSString *)key  
                                               options:(SDWebImageOptions)options  
                                               context:(nullable SDWebImageContext *)context  
                                            completion:(nullable SDImageCacheQueryCompletionBlock)completionBlock;  
    
  ///用于SDWebImageManger下载图片后，进行缓存操作  
  - (void)storeImage:(nullable UIImage *)image  
           imageData:(nullable NSData *)imageData  
              forKey:(nullable NSString *)key  
           cacheType:(SDImageCacheType)cacheType  
          completion:(nullable SDWebImageNoParamsBlock)completionBlock;  
    
    
  ///指定key和缓存类型进行缓存图片移除  
  - (void)removeImageForKey:(nullable NSString *)key  
                  cacheType:(SDImageCacheType)cacheType  
                 completion:(nullable SDWebImageNoParamsBlock)completionBlock;  
    
  ///查找key和指定缓存是否存在图片韩村  
  - (void)containsImageForKey:(nullable NSString *)key  
                    cacheType:(SDImageCacheType)cacheType  
                   completion:(nullable SDImageCacheContainsCompletionBlock)completionBlock;  
    
  ///清除指定类型的缓存  
  - (void)clearWithCacheType:(SDImageCacheType)cacheType  
                  completion:(nullable SDWebImageNoParamsBlock)completionBlock;  
    
    
  ````
  
  
  `SDImageCache`对象，实现了`SDImageCache`的协议，提供了缓存的增删改查的接口。同时也整合了`SDMemoryCache`,`SDDiskCache`。  
  借着持有`SDMemoryCache`和`SDDiskCache`的对象，将先内存查找，再到磁盘查找的流程封装起来。并且也能根据查找类型，对查找流程进行拆分。同理也对图片的保存进行流程的封装已经每一步拆分。

	- SDImageCacheConfig

	- SDMemoryCache
	  `SDMemoryCache`声明了一个协议去定义管理缓存的方法。<br>  
	  同时`SDMemoryCache`类是继承`NSCache`及遵循`SDMemoryCache`协议的。<br>  
	  
	  关于`SDMemoryCache`继承于`NSCache`有几个要点：  
	  1.`NSCache`是类似`NSDictionary`也是一个哈希表啊的结构  
	  2.`NSCache`多了个线程安全的特性，这样就不用自己管理锁  
	  3.`NSCache`会在系统内存低的时候会驱逐一些缓存内的对象  
	  4.`NSCache`的key不要实现`NSCopying`的方式

	- SDDiskCache
	  `SDDiskCache`定义了管理磁盘缓存方法的协议。<br>  
	  
	  磁盘缓存管理主要分两部分，一个是存储，一个缓存管理。<br>  
	  
	  存储:<br>  
	  1.使用`NSFileManager`进行文件的存取  
	  2.文件名由于容易重复，这里使用了`MD5`计算得到文件名  
	  
	  缓存管理:<br>  
	  1.默认是对在磁盘上存在一周以上的内容进行清除(策略一：创建时间；策略二：最后修改时间)  
	  2.如果磁盘上缓存空间大于设置空间的一半，就会按照创建时间，开始循环删除，直到空间大小满足要求。（默认是0）

- #### \<SDImageLoader\>图片下载加载协议
  ````  
    
  定义了C语言的图片解码接口  
    
    
  //普通解码方法  
  FOUNDATION_EXPORT UIImage * _Nullable SDImageLoaderDecodeImageData(NSData * _Nonnull imageData, NSURL * _Nonnull imageURL, SDWebImageOptions options, SDWebImageContext * _Nullable context);  
    
  //渐进式解码方法  
  FOUNDATION_EXPORT UIImage * _Nullable SDImageLoaderDecodeProgressiveImageData(NSData * _Nonnull imageData, NSURL * _Nonnull imageURL, BOOL finished,  id<SDWebImageOperation> _Nonnull operation, SDWebImageOptions options, SDWebImageContext * _Nullable context);  
    
    
  ````
  
    
  
  
  ````  
    
  定义了`SDImageLoader`协议接口,提供当前`SDWebImageManager`去查询图片缓存  
    
  //核心方法，用于获取图片  
  - (nullable id<SDWebImageOperation>)requestImageWithURL:(nullable NSURL *)url  
                                                  options:(SDWebImageOptions)options  
                                                  context:(nullable SDWebImageContext *)context  
                                                 progress:(nullable SDImageLoaderProgressBlock)progressBlock  
                                                completed:(nullable SDImageLoaderCompletedBlock)completedBlock;  
    
  //判断URL是否可以获取图片  
  - (BOOL)canRequestImageForURL:(nullable NSURL *)url;  
    
  //判断是否需要屏蔽URL  
  - (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url  
                                error:(nonnull NSError *)error;  
    
  ````

- #### SDWebImageDownloader(图片缓存管理中心)
  `SDWebImageDownload`类主要实现了`SDImageLoader`协议的接口方法，然后将整个根据图片`URL`去得图片的逻辑封装起来，只由`SDImageLoader`提供访问接口。<br>  
  
  下载的逻辑主要分几步：<br>  
  1.下载任务是使用`NSURLSession`进行的，使用了`SDWebImageDownloaderOperation`自定了一个`NSOperation`来管理每一个下载任务  
  2.下载任务的队列使用`NSOperationQueue`管理，由系统管理并发处理  
  3.队列的优先级顺序是通过`NSOperation`添加依赖的特性实现的  
  
  **PS:**<br>  
  1.同一时间多个相同的`URL`任务不会创建多个下载任务，这里下载任务的唯一`URL`是对应唯一的`NSURLSession`，也是对应唯一的`SDWebImageDownloadOperation`下载任务，在`SDWebImageDownloader`使用字典管理着。那么这些不同任务之间的回调是如何管理的呢？在`SDWebImageDownloadOperation`里面还有一个字典管理这些回调。同于同一个`URL`任务，多次创建只会去增加`SDWebImageDownloadOperation`里面维护的回调字典。然后每次会封装一个用于关联每一个下载任务的`SDWebImageDownloadToken`.

- #### \<SDImageTransformer\>图片转换协议
  提供图片在下载完依照需求进行转换，然后再存储到本地。例如缩放，裁剪，滤镜等，不需要等到解码之后准备加载的时候再去进行转换，而是在本地存储一份转换好的数据。

- SDWebImageCacheKeyFilter(图片缓存键值查找中心)
  	每一次`manager`需要缓存的`key`去使用图片缓存，`cachefilter`提供图片的`URL`转换成缓存的`kye`，

- SDWebImageCacheSerializer(图片缓存解析中心)
  	提供图片的转码，将已经编码的图片或者源文件到实际需要的数据进行转换存储到磁盘。例如可以将WebP格式图片先进行转到成JPEG/PNG格式然后再存储到磁盘。

- SDWebImageOptionsProcessor(图片选项配置中心)
  	用于对所有图片有个全局的控制属性以及上下文选项。

## UI层

### UIView+WebCache

- UIImageView+WebCache

- UIButton+WebCache

### UIVIew+WebCacheOperation







1. 首先是从UI层调用扩展方法，例如UIImageView,会调用`sd_setImageWithUrl()`

2. 然后会去到`UIView+WebCache`扩展类里面，调用内部`sd_internalSetImageWithUrl()`方法

   1. 先获取跟实例绑定的操作字典，查找是否有正在进行中的Operation，如果有则先cancel，这步也能保证tableviewcell重用的时候，图片不会被覆盖显示
   2. 使用placeHodlerImage先展示置位图
   3. 调用SDWebIamgeManager的`loadImageWithURL`进行图片获取的操作，会返回一个二合一的SDWebImageOperation,包含查询操作，加载操作

3. SDWebImageManager如果需要查找缓存会先创建缓存查找的Operation，然后再到创建下载Operation

   1. SDImageCache的`queryImageForKey`

      1. 先回从内存缓存查找.在SDMemoryCache中，使用的是`NSMapTable`，优点是不会强引用，key或和value释放的时候都能够得到释放，但不是线程安全，因此会在读写的时候进行了一个`os_unfair_lock_lock`锁的操作，这是一个能让线程睡眠的锁，会比自旋锁高效且安全。
      2. 在SDDiskCache，根据url字符串的十六进制32位md5值，作为文件保存的文件名，在文件保存路径下查找是否存在这个文件名。
      3. memory中查找出来的解码，是会先重新调用一次UIImage的构造方法，使用cgimage，进行解码。而在磁盘中取出的时候，根据data先转成cgimage,进行解码操作。

   2. 如果缓存和disk中都查不到图片，则会进入下载流程。

      1. SDWebImageDownloader的`requestImageWithURL`方法
      2. SDWebImageDownloader的`downloadImageWithURL`创建一个download的Operation
         1. SDWebImageDownloaderOperation是由NSOperation子类化
         2. 使用的是NSURLSession进行任务下载,使用NSURLSessionDelegate回调的方法来通知Operation完成，失败，处理中的状态
         3. 完成的回调中，对图片进行Decode的操作。
         4. 请求，等待，解码等的操作都是在DownloaderOperation中创建的子线程完成。因此回调图片的时候，需要保证是在主线程去更新UI。

      




### Q&A

1. 列表重用的时候，SDWebImage是如何避免图片被覆盖。

   ​		会为每个调用的方法的class，建立一个hashmap，记录每个class发起获取图片的这个操作。在重用逻辑里面，当一个cell被重新发起获取操作的时候，会首先查询这个hashmap里面是否有正在查询的操作，并且进行cancel操作。然后再回发起这次新的请求。

   ​		如果说不想进行cancel操作的话，我后面时候kingfisher库的时候，发现库原来没有处理这个问题，那只能由我们判断图片返回的url和我们发起的url是否匹配，来进行是否图片赋值的操作。



2. 如何避免同一时间多个请求，请求同一张图片下载多次问题。

   ​	熬到阿道夫
