<?php


############################ 基本类型String，Array，等等 常见函数   ############################

/**
* trim(string,charlist)
* - 移除两侧指定或默认字符
*/
echo trim("xxhelloxx ","x");


/**
* substr(string,start,length)
* - 返回字符串一部分,start从第几位开始，负数的话从末尾开始。
*/
echo "\n substr=".substr("Hello world",4);

/**
* strrchr(string,find,start)
* - 查找字符串最后一次出现到末尾的内容
*/
echo "\n strrchr=".strrchr("Hello world","l");


/**
* strrpos(string,find,start)
* - 查找字符最后出现的位置
*/
echo "\n strrpos=".strrpos("012345","3");



/**
* str_ireplace(find,replace,string,count)
* - str中查找并替换 （不区分大小写）。
*/
echo "\n str_ireplace=".str_ireplace("Fucking","Beautiful","Hello Fucking World");





/**
* - reset() - 函数将内部指针指向数组中的第一个元素，并输出。
* - current() - 返回数组中的当前元素的值。
* - end() - 将内部指针指向数组中的最后一个元素，并输出。
* - next() - 将内部指针指向数组中的下一个元素，并输出。
* - prev() - 将内部指针指向数组中的上一个元素，并输出。
* - each() - 返回当前元素的键名和键值，并将内部指针向前移动。
这些指针输出，有点像c语言需要先将指针指向制定的位置，才能得到值。
*/
$array_ = array("a","b","c","d");
// echo "\n reset =".reset($array_);
// echo "\n current =".current($array_);
// echo "\n end =".end($array_);
// echo "\n next =".next($array_);
// echo "\n prev =".prev($array_);
// echo "\n each =".each($array_);


/**
* - php数组，也可以构造关联数组
* - 关联数组，$a是获取key，$$a是等于先将$a取值，然后再拼$符号。。
* - 下面例子，$key = a, $$key = $(a)。
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
############################ php 流程控制   ############################

/**
 * swich流程
 * 类似C基本语法，如果没有break，会被一直执行，注意！！！
 */
switch ($i) {
    case 0:
    case 1:
    case 2:
        echo "流程没有break，会一直执行";
        break;
    case 3:
        echo "i is 3";
}



?>



<?php
############################ php 标准函数   ############################

/**
* 输出变量
* - var_dump ( mixed $expression [, mixed $... ] )
*/
var_dump(1,2,$x);


?>




<?php
############################ php 文件系统相关扩展  ############################


############################ php 文件系统   ############################

/**
 * 改变文件模式
 * chmod(string $filename, int $permissions): bool
 */
chmod($filePath,0755); // 后面的permission可能不会自动变成8进制数，需要自己补0


/**
 * 改变文件的所有者
 * chown(string $filename, string|int $user): bool
 */
chown($filePath,"root");

/**
* 将整个文件读取输出字符串
* file_get_contents(string $filename,bool $use_include_path = false,?resource $context = null,int $offset = 0,?int $length = null)
*/
file_get_contents($filename);


/**
 * 寻找与模式匹配的文件路径，glob有一个意思是通配符。
 * glob(string $pattern, int $flags = 0): array|false
 * - * - 匹配零个或多个字符。
 * - ? - 只匹配单个字符（任意字符）。
 * - [...] - 匹配一组字符中的一个字符。 如果第一个字符是 !，则为否定模式， 即匹配不在这组字符中的任意字符。
 * - \ - 只要没有使用 GLOB_NOESCAPE 标记，该字符会转义后面的字符。
 */
glob("*");  // 匹配所有



############################ php 目录   ############################

/**
* 路径中文件和目录
* scandir(string $directory, int $sorting_order = SCANDIR_SORT_ASCENDING, ?resource $context = null)
*/
scandir($path);

?>



<?php
############################ php 变量与类型相关扩展  ############################



############################ php Ctype函数  ############################

/**
* 检测字符字符，检测所有字符是否都是字符串
* - ctype_alpha(mixed $text): bool
*/
ctype_alpha('abc');


############################ php 变量处理 ############################

/**
* 检测参数是否是某个类型
* - is_array(mixed $value): bool
* - is_bool(mixed $value): bool
* - is_callable(mixed $value, bool $syntax_only = false, string &$callable_name = null): bool // 是否可以调用
* - is_float(mixed $value): bool
* - is_int(mixed $value): bool
* - is_iterable(mixed $value): bool // 是否可以遍历
* - is_null(mixed $value): bool // 是否为null
* - is_numeric(mixed $value): bool // 是否是数字或者数字字符串
* - is_object(mixed $value): bool // 是否对象
* - is_resource(mixed $value): bool // 变量是否为资源
*/



/**
* 以人类可读方式显示变量信息
* - print_r(mixed $value, bool $return = false): string|bool
*/
$print_r_param = array('a' => 'apple','b' => 'banana','c' => array('x','y','z'));
print_r($print_r_param);


?>






<?php
############################ php 其他基本扩展  ############################




############################ 杂项  ############################

/**
* eval: 把字符串作为PHP代码执行，相当于重新将$code放进一个<?php ?>里面执行，和@eval有啥区别？？？
* - eval(string $code): mixed
*/
eval("phpinfo();");


/**
* highlight_file: 语法高亮一个文件，一般用来输出文件源码
* - highlight_file(string $filename, bool $return = false): string|bool
*/
highlight_file("index.php");
?>



<?php
############################ php 特点 ############################


############################ php 文件上传处理 ############################


############################ php POST方法上传 ############################

/**
 * 使用html表单方式进行POST文件请求。
 * 要注意表单的属性必定为`enctype="multipart/form-data"`
 * 文件上传后，可以使用全局变量`$_FILES`获取所上传的文件信息。
 */
$_FILES['userfile']['name'];
$_FILES['userfile']['type'];
$_FILES['userfile']['size'];
# 注意，使用这个方式，上传文件之后，都会存在一个临时目录，记录用户上传的文件。
#
#
$_FILES['userfile']['tmp_name'];
$_FILES['userfile']['errro'];
$_FILES['userfile']['full_path'];




?>
