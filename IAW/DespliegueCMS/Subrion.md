### Configuración de Apache2.
- Creación del virtual host (`/etc/apache2/sites-available/subrion.conf`):
~~~
<VirtualHost *:80>
	ServerName www.jesusgarcia-subrion.org
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/subrion
</VirtualHost>
~~~

- Modificación del parámetro `AllowOverride` en `/etc/apache2/sites-available/subrion.conf`:
~~~
<Directory /var/www/subrion>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
~~~

- Activación del módulo `rewrite`:
~~~
root@subrion:~# a2enmod rewrite
~~~

- Activación del sitio:
~~~
root@subrion:~# a2ensite subrion.conf
~~~

- Descarga y descompresión en el `DocumentRoot` (`/var/www/subrion`):
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



### Configuración de MariaDB.
- Creación de la base de datos:
~~~
MariaDB [(none)]> create database db_subrion;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]>
~~~

- Creación del usuario:
~~~
MariaDB [(none)]> grant all on db_subrion.* to user_subrion@192.168.1.10 identified by 'subrion';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]> 
~~~

- Configuración del acceso remoto (`/etc/mysql/mariadb.conf.d/50-server.cnf`):
~~~
...
bind-address = 192.168.1.100
...
~~~

- Configuración de cortafuegos:
~~~
root@dbsubrion:~# iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~