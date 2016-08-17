from ubuntu:14.04 
maintainer pratheesh
run apt-get -y update  
run apt-get -y install apache2 
run apt-get -y install php5 
run apt-get -y install libapache2-mod-php5 
run apt-get -y install php5-gd 
run apt-get -y install php5-curl 
run apt-get -y install libssh2-php
run apt-get -y install php5-mysql
run apt-get -y install php5-fpm

run sed -i "s|expose_php = On|expose_php = Off|g" /etc/php5/apache2/php.ini
run sed -i "s|allow_url_fopen = On|allow_url_fopen = Off|g" /etc/php5/apache2/php.ini
run sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g" /etc/php5/fpm/php.ini


add http://wordpress.org/latest.tar.gz /tmp/
workdir /tmp
run tar xzvf latest.tar.gz

workdir /tmp/wordpress
run cp wp-config-sample.php wp-config.php
run sed -i "s|define('DB_NAME', 'database_name_here');|define('DB_NAME', 'wordpress');|g" wp-config.php
run sed -i "s|define('DB_USER', 'username_here');|define('DB_USER', 'wordpressuser');|g" wp-config.php
run sed -i "s|define('DB_PASSWORD', 'password_here');|define('DB_PASSWORD', 'password');|g" wp-config.php
run sed -i "s|define('DB_HOST', 'localhost');|define('DB_HOST', '192.168.1.235');|g" wp-config.php

run mkdir /var/www/html/wordpress
run apt-get -y install rsync
run rsync -avP /tmp/wordpress/ /var/www/html/wordpress/
workdir /root

add dorssl.conf /etc/apache2/sites-available/
run apt-get install ssl-cert
run a2enmod ssl
run a2ensite dorssl.conf
run a2dissite 000-default.conf
run chown -R www-data:www-data /var/www/html/
run chmod 777 -R /var/www/html/
expose 80 
expose 443
entrypoint service apache2 restart && service php5-fpm restart && bash
