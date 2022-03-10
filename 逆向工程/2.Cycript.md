### Cycript

可以用于调试iOS上的app



常用语法：

- UIApp
  - 等价于[UIApplication sharedApplication]
- 定义变量
  - var 变量名= 变量值
- ObjectiveC.classes,查看加载的所有成员变量
- 查看对象的所有成员变量,*对象
- 递归打印view的所有子控件
  - view.recursiveDewcription().toString()
- 导入库，快速调用方法

使用：

```
cycript
cycript -p XXXX
```





自定义cy文件，封装函数

```javascript
(function(exports) {
  // 局部变量
	exports.sum = function(a,b) {
    return a+b;
  };
  exports.var = 1;//可以用来声明不变化的内容，例如bundleid
  // 全局变量
  Sum = function(a,b) {
    return a+b;
  };
})(exports);
```



导入cy文件

```javascript
// cy文件放在根目录
@import XXX
// cy文件放在目录下com/XX/XXX
@import com.XX.XXX

```



### Revel工具

调试UI