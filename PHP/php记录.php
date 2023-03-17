<?php


## 常见函数

/*
trim(string,charlist)
移除两侧指定或默认字符
*/
echo trim("xxhelloxx ","x");


/*
substr(string,start,length)
返回字符串一部分,start从第几位开始，负数的话从末尾开始。
*/
echo "\n substr=".substr("Hello world",4);

/*
strrchr(string,find,start)
查找字符串最后一次出现到末尾的内容
*/
echo "\n strrchr=".strrchr("Hello world","l");


/*
strrpos(string,find,start)
查找字符最后出现的位置
*/
echo "\n strrpos=".strrpos("012345","3");



/*  
str_ireplace(find,replace,string,count)
str中查找并替换 （不区分大小写）。
*/
echo "\n str_ireplace=".str_ireplace("Fucking","Beautiful","Hello Fucking World");











?>

