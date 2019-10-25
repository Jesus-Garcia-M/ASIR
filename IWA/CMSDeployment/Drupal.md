# Drupal.
### Apache2 Conf.
- Creating the virtual host (`/etc/apache2/sites-available/drupal.conf`):
~~~
...
ServerName www.jesusgarcia-drupal.org
DocumentRoot /var/www/drupal-8.7.8
...
~~~

- Adding the `AllowOverride` parameter (`/etc/apache2/sites-available/drupal.conf`):
~~~
<Directory /var/www/drupal-8.7.8>
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
</Directory>
~~~

- Enabling `rewrite` mod:
~~~
root@drupal:~# a2enmod rewrite
~~~

- Enabling the virtual host:
~~~
root@drupal:~# a2ensite drupal.conf
~~~

### MariaDB Conf.
- Creating the databse:
~~~
MariaDB [(none)]> create database dbdrupal;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]>
~~~

- Creating the user:
~~~
MariaDB [(none)]> create user usuariodrupal identified by 'usuariodrupal';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]>
~~~

- Changing user privileges:
~~~
MariaDB [dbdrupal]> grant all on *.* to usuariodrupal;
Query OK, 0 rows affected (0.001 sec)

MariaDB [dbdrupal]> 
~~~

### Migrating the database.
- Creating a backup:
~~~
root@drupal:~# mysqldump -u usuariodrupal -p dbdrupal --single-transaction --quick --lock-tables=false > dbdrupal-backup-$(date +%F).sql
Enter password: 
root@drupal:~# ls -l
total 5756
-rw-r--r-- 1 root root 5892441 Oct 16 09:12 dbdrupal-backup-2019-10-16.sql
root@drupal:~# 
~~~

- Importing the backup:
~~~
root@dbroot@dbdrupal:~# mysql -u usuariodrupal -p dbdrupal < /vagrant/dbdrupal-backup-2019-10-16.sql
Enter password: 
root@dbdrupal:~# 
~~~

- Creating the remote user:
~~~
MariaDB [(none)]> grant all on dbdrupal.* to usuariodrupal@192.168.1.10 identified by 'usuariodrupal';
Query OK, 0 rows affected (0.001 sec)

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
root@dbdrupal:~# iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~

- Modifying Drupal's conf (`/var/www/drupal-8.7.8/sites/default/settings.php`):
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