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

### Migración de la base de datos.
- Realización de copia de seguridad:
~~~
root@drupal:~# mysqldump -u usuariodrupal -p dbdrupal --single-transaction --quick --lock-tables=false > dbdrupal-backup-$(date +%F).sql
Enter password: 
root@drupal:~# ls -l
total 5756
-rw-r--r-- 1 root root 5892441 Oct 16 09:12 dbdrupal-backup-2019-10-16.sql
root@drupal:~# 
~~~

- Importación de la copia de seguridad:
~~~
root@dbroot@dbdrupal:~# mysql -u usuariodrupal -p dbdrupal < /vagrant/dbdrupal-backup-2019-10-16.sql
Enter password: 
root@dbdrupal:~# 
~~~

- Modificación de la configuración (`/var/www/drupal-8.7.8/sites/default/settings.php`:
~~~
$databases['default']['default'] = array (
  'database' => 'dbdrupal',
  'username' => 'usuariodrupal',
  'password' => 'usuariodrupal',
  'prefix' => '',
  'host' => '192.168.1.100',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
~~~

- Configuración del acceso remoto:
~~~
...
bind-address            = 192.168.1.100
...
~~~

- Creación del usuario remoto:
~~~
MariaDB [(none)]> grant all on dbdrupal.* to usuariodrupal@192.168.1.10 identified by 'usuariodrupal';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> 
~~~

- Configuración de cortafuegos:
~~~
root@dbdrupal:~# iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~