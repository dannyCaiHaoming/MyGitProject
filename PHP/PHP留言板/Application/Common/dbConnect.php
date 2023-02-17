<?php

require("../Config/dbConfig.php");

$sql = file_get_contents('../../SQL/message_db.sql');
$sql_arr = explode(';',$sql);

$connection = mysqli_connect($servername,$db_username,$db_password);

if (!$connection) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "连接成功";

foreach ($sql_arr as $value) {
    $connection->query($value.';');
}
echo "执行sql初始化语句";

$select_result = mysqli_select_db($connection,$db_name);

if (!$select_result) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "数据库初始化完成";

?>