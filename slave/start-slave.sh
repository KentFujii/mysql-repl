#!/bin/sh

while ! mysqladmin ping -u root -h mysql-master --password=root --silent; do
    sleep 1
done

mysql -u root -h mysql-master --password=root -e "RESET MASTER;"
mysql -u root -h mysql-master --password=root -e "FLUSH TABLES WITH READ LOCK;"

mysqldump -uroot -h mysql-master --password=root --all-databases --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql

mysql -u root --password=root -e "STOP SLAVE;";
mysql -u root --password=root < /tmp/master_dump.sql

log_file=`mysql -u root -h mysql-master --password=root -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
pos=`mysql -u root -h mysql-master --password=root -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

mysql -u root --password=root -e "RESET SLAVE";
mysql -u root --password=root -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='root', MASTER_PASSWORD='root', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
mysql -u root --password=root -e "start slave"

mysql -u root -h mysql-master --password=root -e "UNLOCK TABLES;"
