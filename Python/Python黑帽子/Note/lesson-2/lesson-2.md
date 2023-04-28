

##### argparse -- 命令行选项、参数和子命令解析器
1. ArgumentParser对象
- `description`: 描述
- `epilog`: 用于介绍参数用法的文字
- `formatter_class`: 用于自定义帮助文档输出格式的类

2. add_argument()方法：
- `name`：参数命名，是一个字符串数组，一般把省略和全程写上
- `aciton`: 操作，默认保存，如果是`store_ture`,就是保存true值
- `type`: 输入内容类型
- `help`: 帮助介绍


##### textwrap -- 文本自动换行与填充
1. dedent(text): 
    移除text中每一行任何相同前缀空白符
    
2. intent(text,prefix,predicate=None);
    添加开头到text中选定行


##### subprocess -- 子进程管理

1. Linux三种标准数据流
- `stdin`: Standard input
- `stdout`: Standard output
- `stderr`: Standard error 

2. run()
- `args`: 启动进程的参数,

3. check_out():
    等同于run(check=true),检查进程运行是否异常并退出。


##### shlex -- 简单的词法分析

1. split(s, comments=false, posix=true)
    用类似shell的语法拆分字符串。


##### sys -- 系统相关的参数和函数

1. stdin,stdout,stderr获取解释器标准流

2. exit，退出解释器