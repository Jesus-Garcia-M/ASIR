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


root@drupal:~# mysqldump -u usuariodrupal -p dbdrupal --single-transaction --quick --lock-tables=false > dbdrupal-backup-$(date +%F).sql
Enter password: 
root@drupal:~# ls -l
total 5756
-rw-r--r-- 1 root root 5892441 Oct 16 09:12 dbdrupal-backup-2019-10-16.sql
root@drupal:~# 
~~~


### Migración de la instalación.
- Compresión del contenido:
~~~
root@mediawiki:~# zip mediawiki.zip /var/www/mediawiki/*
  adding: var/www/mediawiki/api.php (deflated 52%)
  adding: var/www/mediawiki/autoload.php (deflated 86%)
  adding: var/www/mediawiki/cache/ (stored 0%)
  adding: var/www/mediawiki/CODE_OF_CONDUCT.md (deflated 13%)
  adding: var/www/mediawiki/composer.json (deflated 61%)
  adding: var/www/mediawiki/composer.local.json-sample (deflated 15%)
  adding: var/www/mediawiki/COPYING (deflated 62%)
  adding: var/www/mediawiki/CREDITS (deflated 48%)
  adding: var/www/mediawiki/docs/ (stored 0%)
  adding: var/www/mediawiki/extensions/ (stored 0%)
  adding: var/www/mediawiki/FAQ (deflated 6%)
  adding: var/www/mediawiki/Gruntfile.js (deflated 60%)
  adding: var/www/mediawiki/HISTORY (deflated 66%)
  adding: var/www/mediawiki/images/ (stored 0%)
  adding: var/www/mediawiki/img_auth.php (deflated 58%)
  adding: var/www/mediawiki/includes/ (stored 0%)
  adding: var/www/mediawiki/index.php (deflated 44%)
  adding: var/www/mediawiki/INSTALL (deflated 53%)
  adding: var/www/mediawiki/jsduck.json (deflated 65%)
  adding: var/www/mediawiki/languages/ (stored 0%)
  adding: var/www/mediawiki/load.php (deflated 47%)
  adding: var/www/mediawiki/LocalSettings-backup.php (deflated 52%)
  adding: var/www/mediawiki/LocalSettings.php (deflated 51%)
  adding: var/www/mediawiki/maintenance/ (stored 0%)
  adding: var/www/mediawiki/mw-config/ (stored 0%)
  adding: var/www/mediawiki/opensearch_desc.php (deflated 50%)
  adding: var/www/mediawiki/profileinfo.php (deflated 67%)
  adding: var/www/mediawiki/README (deflated 49%)
  adding: var/www/mediawiki/RELEASE-NOTES-1.33 (deflated 63%)
  adding: var/www/mediawiki/resources/ (stored 0%)
  adding: var/www/mediawiki/SECURITY (deflated 26%)
  adding: var/www/mediawiki/skins/ (stored 0%)
  adding: var/www/mediawiki/tests/ (stored 0%)
  adding: var/www/mediawiki/thumb_handler.php (deflated 41%)
  adding: var/www/mediawiki/thumb.php (deflated 66%)
  adding: var/www/mediawiki/UPGRADE (deflated 60%)
  adding: var/www/mediawiki/vendor/ (stored 0%)
root@mediawiki:~# ls
dbmediawiki-backup-2019-11-08.sql  mediawiki.zip
root@mediawiki:~#
~~~
