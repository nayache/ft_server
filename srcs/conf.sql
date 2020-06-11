ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;
SET PASSWORD = PASSWORD('root');
flush privileges;
CREATE DATABASE demo;
grant all privileges on demo.* to root@localhost;
flush privileges;
quit
