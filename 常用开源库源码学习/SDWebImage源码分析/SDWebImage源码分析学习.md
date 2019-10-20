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

- #### \<SDImageLoader\>图片下载加载协议
  提供当前`manager`去加载图片

- #### SDWebImageDownloader(图片缓存管理中心)

- #### \<SDImageCache\>图片缓存协议
    
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

- #### \<SDImageTransformer\>图片转换协议
  	提供图片在加载完之后的转换和存储转换好的图片到缓存中。

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

