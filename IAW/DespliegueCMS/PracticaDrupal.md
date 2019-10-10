# Drupal.
### Configuración Apache2.
- Creación del virtual hosting en `/etc/apache2/sites-available/drupal.conf`:
~~~
...
ServerName www.jesusgarcia-drupal.org
DocumentRoot /var/www/drupal-8.7.8
...
~~~

- Activación del sitio:
~~~
root@drupal:~# a2ensite drupal.conf
~~~

- Modificación del parámetro `AllowOverride` en `/etc/apache2/sites-available/drupal.conf`:
~~~
<Directory /var/www/drupal-8.7.8>
	Options Indexes FollowSymLinks
	AllowOverride All
	Require all granted
</Directory>
~~~

- Activación del módulo `rewrite`:
~~~
root@drupal:~# a2enmod rewrite
~~~

### Configuración MariaDB.
- Creación de la base de datos:
~~~
MariaDB [(none)]> create database dbdrupal;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]>
~~~

- Creación del usuario:
~~~
MariaDB [(none)]> create user usuariodrupal identified by 'usuariodrupal';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]>
~~~

- Modificación de permisos del usuario:
~~~
MariaDB [dbdrupal]> grant all on *.* to usuariodrupal;
Query OK, 0 rows affected (0.001 sec)

MariaDB [dbdrupal]> 
~~~