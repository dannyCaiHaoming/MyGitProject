<?php


############################ 基本类型String，Array，等等 常见函数   ############################

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


/*
php数组，也可以构造关联数组
关联数组，$a是获取key，$$a是等于先将$a取值，然后再拼$符号。。
下面例子，$key = a, $$key = $(a)。
*/
$normal_array = array(1,2,3);
$dic_array = array("a"=>"aa","b"=>"bb","c"=>"cc");

foreach($dic_array as $key=>$value)
{
    echo "\n";
    echo "key=".$key."   value = ".$value."as =";
    #$test = $$key;
    #echo $test;
    echo "\n";
}

$test = array("flag"=>"bingo","handsome"=>"flag","flag"=>"x","x"=>"flag");
foreach ($test as $x => $y) {
    $$x = $$y;
    echo "\$y=".$y."---".$$y."\n";
}
foreach ($test as $x => $y) {
    echo $x.$y."\n";
}

?>



<?php
############################ php 标准函数   ############################

/*
输出变量
var_dump ( mixed $expression [, mixed $... ] )
*/
var_dump(1,2,$x);


?>




<?php
############################ php 文件系统   ############################


/*
将整个文件读取输出字符串
file_get_contents(string $filename,bool $use_include_path = false,?resource $context = null,int $offset = 0,?int $length = null)
*/
file_get_contents($filename);




############################ php 文件系统 扩展  ############################

/*
路径中文件和目录
scandir(string $directory, int $sorting_order = SCANDIR_SORT_ASCENDING, ?resource $context = null)
*/
scandir($path);

?>
