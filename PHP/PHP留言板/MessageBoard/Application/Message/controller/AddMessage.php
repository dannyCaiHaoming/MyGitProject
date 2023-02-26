<?php
header('Content-Type:text/html; charset=utf-8');



require_once(__DIR__.'/../../Common/dbConnect.php');

$username = $_POST['user'];
$content = $_POST['content'];

if (strlen($username) >= 30 || strlen($username) <= 4) {
    echo '名字长度不对';
    exit;
}

if (strlen($content < 1)) {
    echo '留言内容不能为空';
    exit;
}

$sql = "insert into message (message_user,message_content,message_time) values ('$username','$content',now())";

$result = mysqli_query($connection,$sql);

if ($result) {
    echo '<script>alert("恭喜你，留言成功!")</script>';
} else {
    echo '<script>alert("留言失败!")</script>';
}
?>