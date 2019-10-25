# Subrion.
### Apache2 Conf.
- Creating the virtual host (`/etc/apache2/sites-available/subrion.conf`):
~~~
<VirtualHost *:80>
	ServerName www.jesusgarcia-subrion.org
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/subrion
</VirtualHost>
~~~

- Adding the `AllowOverride` parameter (`/etc/apache2/sites-available/subrion.conf`):
~~~
<Directory /var/www/subrion>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
~~~

- Enabling `rewrite` mod:
~~~
root@subrion:~# a2enmod rewrite
~~~

- Enabling the virtual host:
~~~
root@subrion:~# a2ensite subrion.conf
~~~

- Download and extraction on `DocumentRoot` (`/var/www/subrion`):
~~~
root@subrion:/var/www/subrion# wget https://tools.subrion.org/get/latest.zip
root@subrion:/var/www/subrion# unzip latest.zip
root@subrion:/var/www/subrion# ls
admin	       CONTRIBUTING.md	index.php    modules	 tmp
backup	       favicon.ico	install      README.md	 updates
changelog.txt  front		js	     robots.txt  uploads
composer.json  includes		license.txt  templates
root@subrion:/var/www/subrion# 
~~~



### MariaDB Conf.
- Creating the database:
~~~
MariaDB [(none)]> create database db_subrion;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]>
~~~

- Creating the user:
~~~
MariaDB [(none)]> grant all on db_subrion.* to user_subrion@192.168.1.10 identified by 'subrion';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]> 
~~~

- Configurating remote access (`/etc/mysql/mariadb.conf.d/50-server.cnf`):
~~~
...
bind-address = 192.168.1.100
...
~~~

- Configurating firewall (Opens port 3306):
~~~
root@dbsubrion:~# iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~