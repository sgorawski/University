<!DOCTYPE html>

<html>
<head>
<title>Task 1</title>
<link rel="stylesheet" type"text/css" href="https://s3.eu-central-1.amazonaws.com/clouds2018-lab1-task1/style.css">
</head>
<body>
<h1>
<?php
$filename = 'ctr';
$count = file_get_contents($filename) + 1;
file_put_contents($filename, $count);
echo $count;
?>
</h1>
<img src="https://s3.eu-central-1.amazonaws.com/clouds2018-lab1-task1/img1.jpg" alt="img1">
<img src="https://s3.eu-central-1.amazonaws.com/clouds2018-lab1-task1/img2.jpg" alt="img2">
</body>
</html>