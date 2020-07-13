Simply run `bash test.sh` to execute the test.

The main idea is the use of a docker volume and docker DNS.

This example repo works like this:
- The php container simply always references the mysql host `db` with the same credentials. 
- The mysql 5.7 container is started with a docker volume (`-v db:/var/lib/mysql`)
- When mysql is ready php injects some data and pulls the running mysql version
- The mysql 5.7 container is stopped, and a mysql 8.0 container is started in the same way as the 5.7 container and uses the same volume (`-v db:/var/lib/mysql`)
- Php pulls the existing data and version to show the migration was successful.  
