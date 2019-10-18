### Instalación del servidor.
- Instalación:
~~~
vagrant@MariaDBServer:~$ sudo apt install mariadb-server
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
galera-3 gawk libaio1 libcgi-fast-perl libcgi-pm-perl libconfig-inifiles-perl
libdbd-mysql-perl libdbi-perl libencode-locale-perl
libfcgi-perl libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
libhttp-date-perl libhttp-message-perl libio-html-perl
liblwp-mediatypes-perl libmariadb3 libmpfr6 libreadline5 libsigsegv2
libsnappy1v5 libterm-readkey-perl libtimedate-perl liburi-perl
mariadb-client-10.3 mariadb-client-core-10.3 mariadb-common mariadb-server-
10.3 mariadb-server-core-10.3 mysql-common psmisc socat
...
0 upgraded, 34 newly installed, 0 to remove and 38 not upgraded.
Need to get 21.9 MB of archives.
After this operation, 169 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
...
vagrant@MariaDBServer:~$
~~~

- Secure instalation:
~~~
vagrant@MariaDBServer:~$ sudo mysql_secure_installation
*# Indicamos la contraseña de root para poder continuar.*
Enter current password for root (enter for none):
OK, successfully used password, moving on...
# Elegimos “n”, como root ya tiene contraseña no queremos cambiarla.
Change the root password? [Y/n] n
... skipping.
# MariaDB cuenta con usuarios anónimos por defecto, vamos a
eliminarlos para permitir conexiones unicamente con usuarios
existentes.
Remove anonymous users? [Y/n] Y
... Success!
# Desactivamos la conexión de root de forma remota.
Disallow root login remotely? [Y/n] Y
... Success!
# Eliminamos las bases de datos “test” creadas por defecto.
Remove test database and access to it? [Y/n] Y
- Dropping test database...
... Success!
- Removing privileges on test database...
... Success!
# Recargamos las tablas de privilegios para que los cambios tengan
efecto.
Reload privilege tables now? [Y/n] Y
... Success!
Cleaning up...
All done! If you've completed all of the above steps, your MariaDB
installation should now be secure.
Thanks for using MariaDB!
vagrant@MariaDBServer:~$
~~~

### Configuración de acceso remoto.

- Seleccionar la dirección de la interfaz por la que va a escuchar el servidor (`/etc/mysql/mariadb.conf.d/50-server.cnf`):
~~~
...
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
Bind-address
= 10.1.1.10
...
~~~

- Creación del usuario y la base de datos para el acceso remoto:
~~~
MariaDB [(none)]> create database bd_remota;
Query OK, 1 row affected (0.001 sec)
MariaDB [(none)]> show databases;
+--------------------+
| Database
|
+--------------------+
| bd_remota
|
| information_schema |
| mysql
|
| performance_schema |
+--------------------+
4 rows in set (0.001 sec)
MariaDB [(none)]> grant all on bd_remota.* to cliente_remoto@10.1.1.11
identified by '*****';
~~~

- Creación de la regla de cortafuegos:
~~~
vagrant@MariaDBServer:~$ sudo iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~