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





/*
reset() - 函数将内部指针指向数组中的第一个元素，并输出。
current() - 返回数组中的当前元素的值。
end() - 将内部指针指向数组中的最后一个元素，并输出。
next() - 将内部指针指向数组中的下一个元素，并输出。
prev() - 将内部指针指向数组中的上一个元素，并输出。
each() - 返回当前元素的键名和键值，并将内部指针向前移动。
这些指针输出，有点像c语言需要先将指针指向制定的位置，才能得到值。
*/
$array_ = array("a","b","c","d");
// echo "\n reset =".reset($array_);
// echo "\n current =".current($array_);
// echo "\n end =".end($array_);
// echo "\n next =".next($array_);
// echo "\n prev =".prev($array_);
// echo "\n each =".each($array_);




?>

