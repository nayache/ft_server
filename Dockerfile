FROM debian:buster

###utils
RUN apt update && apt upgrade -y && apt install -y gnupg && apt-get install -y lsb-release \
&& apt-get install -y dpkg && apt-get install -y wget && apt install -y vim

###NGINX
RUN apt install -y nginx

COPY srcs/default ./srcs/default /etc/nginx/sites-enabled/

###MYSQL
RUN apt install -y mariadb-server && apt install -y mariadb-client
###PHPMYADMIN
RUN apt install -y php-fpm php-mysql php-cli && apt install -y php-mbstring php-zip php-gd \
&& wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz \
&& apt install -y gpg
RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 3D06A59ECE730EB71B511C17CE752F178259BD92
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz.asc \
&& gpg --verify phpMyAdmin-4.9.0.1-english.tar.gz.asc \
&& mkdir /var/www/html/phpmyadmin && tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

COPY srcs/config.inc.php ./srcs/config.inc.php /var/www/html/phpmyadmin/

RUN chmod 660 /var/www/html/phpmyadmin/config.inc.php && chown -R www-data:www-data /var/www/html/phpmyadmin \
&& rm -f /var/www/html/config.sample.inc.php
##WORDPRESS
COPY srcs/wordpress ./srcs/wordpress /etc/nginx/sites-available/
RUN apt install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip \
&& ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/ && wget https://wordpress.org/latest.tar.gz -P /tmp \
&& mkdir /var/www/html/wordpress && tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress \
&& rm -f wp-config.sample.php && mkdir /etc/nginx/ssl
COPY srcs/nginx.crt ./srcs/nginx.crt /etc/nginx/ssl/
COPY srcs/nginx.key ./srcs/nginx.key /etc/nginx/ssl/
COPY srcs/wp-config.php ./srcs/wp-config.php /var/www/html/wordpress/
COPY srcs/conf.sql ./srcs/conf.sql ./
RUN chown -R www-data:www-data /var/www/html/wordpress 
COPY srcs/script.sh ./srcs/script.sh ./

EXPOSE 80

CMD /bin/bash script.sh && sleep infinity
