<?php
$connection = mysqli_connect('db', 'root', 'secretpw', 'main');
$connection->query('CREATE TABLE test (name VARCHAR(255))');
$connection->query('INSERT INTO test SET name="test data"');
$data = $connection->query('SELECT name FROM test')->fetch_row()[0];
echo 'PHP inserted data "' . $data . "\"\n";
