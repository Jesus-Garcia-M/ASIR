### Configuración de Apache2.
- Creación del virtual host:
~~~
<VirtualHost *:80>

        ServerName www.jesus-mediawiki.org
        DocumentRoot /var/www/mediawiki

</VirtualHost>
~~~

- Activación del sitio:
~~~
root@mediawiki:~# a2ensite mediawiki.conf
Enabling site mediawiki.
To activate the new configuration, you need to run:
  systemctl reload apache2
root@mediawiki:~#
~~~

### Configuración de MariaDB.
- Creación de la base de datos:
~~~
MariaDB [(none)]> create database mediawiki;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]>
~~~

- Creación del usuario:
~~~
MariaDB [(none)]> create user mediawiki identified by 'mediawiki';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]>
~~~

- Asignación de permisos al usuario:
~~~
MariaDB [(none)]> grant all on mediawiki.* to mediawiki;
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]>
~~~

# Instalación de dependencias.
~~~
root@mediawiki:~# apt install php-apcu php-intl php-mbstring php-xml php-mysql
~~~

### Instalación.
- Descarga del paquete:
~~~
root@mediawiki:~# wget https://releases.wikimedia.org/mediawiki/1.33/mediawiki-1.33.1.tar.gz
--2019-11-08 16:14:32--  https://releases.wikimedia.org/mediawiki/1.33/mediawiki-1.33.1.tar.gz
Resolving releases.wikimedia.org (releases.wikimedia.org)... 91.198.174.192, 2620:0:862:ed1a::1
Connecting to releases.wikimedia.org (releases.wikimedia.org)|91.198.174.192|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 37863816 (36M) [application/x-gzip]
Saving to: ‘mediawiki-1.33.1.tar.gz’

mediawiki-1.33.1.tar.gz                   100%[=====================================================================================>]  36.11M  4.86MB/s    in 7.7s

2019-11-08 16:14:45 (4.68 MB/s) - ‘mediawiki-1.33.1.tar.gz’ saved [37863816/37863816]

root@mediawiki:~#
~~~

- Descompresión del paquete:
~~~
root@mediawiki:/var/www/mediawiki# tar -xf mediawiki-1.33.1.tar.gz
~~~

### Configuración de Mediawiki.
- Modificación del logo (`LocalSettings.php`):
~~~
$wgLogo = "https://rlv.zcache.com/cute_otter_wearing_a_santa_hat_christmas_ceramic_ornament-rc1411a3b46fc4584a682a78066903a06_x7s2y_8byvr_307.jpg";
~~~


### Migración de la base de datos.
- Realización de copia de seguridad:
~~~
root@mediawiki:~# mysqldump -u mediawiki -p mediawiki --single-transaction --quick --lock-tables=false > dbmediawiki-backup-$(date +%F).sql
Enter password:
root@mediawiki:~# ls
dbmediawiki-backup-2019-11-08.sql
root@mediawiki:~#
~~~


### Migración de la instalación.
- Compresión del contenido:
~~~
root@mediawiki:/var/www/mediawiki# zip mediawiki.zip *
root@mediawiki:/var/www/mediawiki#
~~~
