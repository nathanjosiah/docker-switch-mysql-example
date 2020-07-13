<?php
$connection = mysqli_connect('db', 'root', 'secretpw', 'main');
$version = $connection->query('SELECT VERSION()')->fetch_row()[0];
echo 'PHP is using MySQL version: ' . $version . "\n";
