#!/bin/bash
# Cleanup
cleanup () {
  echo 'Cleaning up'
  docker stop db
  docker volume rm db
  docker network rm testnet
}

info () {
  echo -e "\033[0;34m" $* "\033[0m"
}

init() {
  docker volume create db
  docker network create testnet
  docker build -t test/mysql57 ./mysql57
  docker build -t test/php ./php
  docker build -t test/mysql80 ./mysql80
}

startMysql57 () {
  # Start the MySQL 5.7 Container using the db volume from above
  docker run -d -v db:/var/lib/mysql --rm --network testnet --name db -e MYSQL_ROOT_PASSWORD=secretpw -e 'MYSQL_ROOT_HOST=%' test/mysql57

  # Wait for the DB to be ready
  while true; do
      docker exec db mysql -uroot --password=secretpw  2>/dev/null && break
      sleep 2
      echo 'Waiting for DB to start'
  done
  # Create the Database so PHP doesn't complain
  docker exec db mysql -uroot --password=secretpw -e 'CREATE DATABASE main'
}

outputMySqlVersionFromPhp() {
  # Run the PHP script to pull the php version
  info $(docker run --rm --network testnet -v $(pwd)/phpfiles:/app test/php php /app/get-mysql-version.php)
}
insertData() {
  # Run the PHP script to pull the php version
  info $(docker run --rm --network testnet -v $(pwd)/phpfiles:/app test/php php /app/create-data.php)
}
fetchData() {
  # Run the PHP script to pull the php version
  info $(docker run --rm --network testnet -v $(pwd)/phpfiles:/app test/php php /app/fetch-data.php)
}

switchMySqlVersion() {
  # Stop mysql 5.7
  docker stop db

  # Start the MySQL 8.0 Container using the db volume from above
  docker run -d -v db:/var/lib/mysql --rm --network testnet --name db -e MYSQL_ROOT_PASSWORD=secretpw -e 'MYSQL_ROOT_HOST=%' test/mysql80
  # Wait for the DB to be ready
  while true; do
      docker exec db mysql -uroot --password=secretpw  2>/dev/null && break
      sleep 2
      echo 'Waiting for DB to start'
  done
}

trap "cleanup" EXIT
init
startMysql57
outputMySqlVersionFromPhp
insertData
switchMySqlVersion
outputMySqlVersionFromPhp
fetchData
