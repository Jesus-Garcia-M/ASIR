### Configuración Croqueta.
- Establecer FQDN con `hostnamectl`:
~~~
root@croqueta:~# hostnamectl set-hostname croqueta.jesus.gonzalonazareno.org
~~~

- Modificación del fichero `/etc/hosts`:
~~~
127.0.1.1 croqueta.jesus.gonzalonazareno.org croqueta
~~~

- Modificación del fichero `/etc/cloud/cloud.cfg`:
~~~
preserve_hostname: true
~~~

- Modificación del fichero `/etc/resolv.conf`:
~~~

~~~

- Prueba de acceso a la base de datos de `tortilla`:
~~~
debian@croqueta:~$ mysql -u cliente_remoto -p prueba_remoto -h tortilla
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 30
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [prueba_remoto]>
~~~

### Configuración Tortilla.
- Establecer el nombre con `hostnamectl`:
~~~
root@tortilla:~# hostnamectl set-hostname tortilla.jesus.gonzalonazareno.org
~~~

- Modificación del fichero `/etc/hosts`:
~~~
127.0.1.1 tortilla.jesus.gonzalonazareno.org tortilla
~~~

- Modificación del fichero `/etc/cloud/cloud.cfg`:
~~~
preserve_hostname: true
~~~

- Modificación del fichero `/etc/resolv.conf`:
~~~

~~~

- Instalación de MariaDB:
~~~
root@tortilla:~# apt install mariadb-server
~~~

- Configuración de acceso remoto (`/etc/mysql/mariadb.conf.d/50-server.cnf`)
~~~
bind-address = 10.0.0.10
~~~

- Creación de la base de datos y el usuario de pruebas:
~~~
MariaDB [(none)]> create database prueba_remoto;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> grant all on prueba_remoto.* to cliente_remoto@10.0.0.6 identified by "croqueta";
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> grant all on prueba_remoto.* to cliente_remoto@172.22.200.82 identified by "salmorejo";
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> 
~~~

### Configuración Salmorejo.
- Establecer el nombre con `hostnamectl`:
~~~
[root@salmorejo ~]# hostnamectl set-hostname salmorejo.jesus.gonzalonazareno.org
~~~

- Modificación del fichero `/etc/hosts`:
~~~
127.0.0.1 salmorejo.jesus.gonzalonazareno.org salmorejo
~~~

- Modificación del fichero `/etc/cloud/cloud.cfg`:
~~~
preserve_hostname: true
~~~

- Modificación del fichero `/etc/resolv.conf`:
~~~

~~~

- Instalación del cliente MariaDB:
~~~
[centos@salmorejo ~]$ sudo yum install mariadb
~~~

- Prueba de acceso a la base de datos de `tortilla`:
~~~
[centos@salmorejo ~]$ mysql -u cliente_remoto -p prueba_remoto -h tortilla
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 35
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [prueba_remoto]> 
~~~