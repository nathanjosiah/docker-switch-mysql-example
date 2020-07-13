<?php
$connection = mysqli_connect('db', 'root', 'secretpw', 'main');
$data = $connection->query('SELECT name FROM test')->fetch_row()[0];
echo 'PHP found data "' . $data . "\"\n";
