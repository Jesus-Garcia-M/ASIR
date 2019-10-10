# Drupal.
### Configuración Apache2.
- Creación del virtual hosting `www.jesus-drupal.org` en `/etc/apache2/sites-available/drupal.conf`:
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

### Instalaciones previas:
- Instalación de Composer:
~~~
root@drupal:/var/www/drupal# php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
root@drupal:/var/www/drupal# php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
Installer verified
root@drupal:/var/www/drupal# php composer-setup.php
All settings correct for using Composer
Downloading...

Composer (version 1.9.0) successfully installed to: /var/www/drupal/composer.phar
Use it: php composer.phar

root@drupal:/var/www/drupal# php -r "unlink('composer-setup.php');"
root@drupal:/var/www/drupal# 
~~~

- Instalación de dependencias: