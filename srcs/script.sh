#/bin/bash!

service nginx start;
service mysql start;
service php7.3-fpm start;
mysql -h localhost -u root -proot < conf.sql
