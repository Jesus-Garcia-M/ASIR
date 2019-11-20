### Creación de los distintos virtual hosts.
- Creación del sitio `www.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/wordpress.conf`):
~~~
server {
  listen 80;

  root /var/www/wordpress;
  index index.html index.php;

  server_name www.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~

- Creación del sitio `cloud.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/nextcloud.conf`):
~~~
server {
  listen 80;

  root /var/www/nextcloud;
  index index.html index.php;

  server_name cloud.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~

- Modificación de SELinux:
~~~
[centos@salmorejo ~]$ sudo semanage fcontext -a -t httpd_config_t "/etc/nginx/conf.d(/.*)?"
[centos@salmorejo ~]$ sudo restorecon -Rv /etc/nginx/conf.d
~~~


### Creación de usuarios y bases de datos en Tortilla.
- Creación del usuario y la base de datos de `WordPress`:
~~~
MariaDB [(none)]> CREATE DATABASE wordpress;
Query OK, 1 row affected (0.05 sec)

MariaDB [(none)]> GRANT ALL ON wordpress.* TO wordpress@salmorejo IDENTIFIED BY 'wordpress';
Query OK, 0 rows affected (0.01 sec)

MariaDB [(none)]> 

#----- Prueba de funcionamiento -----#
[centos@salmorejo ~]$ mysql -u wordpress -p wordpress -h tortilla
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 32
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [wordpress]>
~~~

- Creación del usuario y la base de datos de `NextCloud`:
~~~
MariaDB [(none)]> CREATE DATABASE nextcloud;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> GRANT ALL ON nextcloud.* TO nextcloud@salmorejo IDENTIFIED BY 'nextcloud';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> 

#----- Prueba de funcionamiento -----#
[centos@salmorejo ~]$ mysql -u nextcloud -p nextcloud -h tortilla
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 33
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [nextcloud]>
~~~

### Instalación de Wordpress
- Descarga y descompresión del paquete:
~~~
[root@salmorejo wordpress]# wget https://wordpress.org/latest.tar.gz
--2019-11-19 18:35:50--  https://wordpress.org/latest.tar.gz
Resolviendo wordpress.org (wordpress.org)... 198.143.164.252
Conectando con wordpress.org (wordpress.org)[198.143.164.252]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 12372564 (12M) [application/octet-stream]
Grabando a: “latest.tar.gz”

100%[==============================================================================================================================>] 12.372.564  3,37MB/s   en 3,5s

2019-11-19 18:35:54 (3,37 MB/s) - “latest.tar.gz” guardado [12372564/12372564]

[root@salmorejo wordpress]# tar xvf latest.tar.gz
[root@salmorejo wordpress]# mv wordpress/* .
~~~

- Configuración del fichero `wp-config.php`:
~~~
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'tortilla' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );
~~~

- Modificación de SELinux:
~~~
[root@salmorejo wordpress]# semanage fcontext -a -t httpd_sys_content_t "/var/www/wordpress(/.*)?"
[root@salmorejo wordpress]# restorecon -Rv /var/www/wordpress
~~~

- Instalación de la extensión `MySQL` de `php`:
~~~
[root@salmorejo ~]# yum --enablerepo=remi-php72 install php-mysql
~~~
