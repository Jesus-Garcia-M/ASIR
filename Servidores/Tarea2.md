### Configuración Croqueta.
##### Configuración de FQDN y Domain.
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
manage_etc_hosts: false
~~~

- Modificación del fichero `/etc/dhcp/dhclient.conf`:
~~~
request subnet-mask, broadcast-address, time-offset, routers,
        domain-name-servers, host-name,
        dhcp6.name-servers, dhcp6.domain-search, dhcp6.fqdn, dhcp6.sntp-servers,
        netbios-name-servers, netbios-scope, interface-mtu,
        rfc3442-classless-static-routes, ntp-servers;

# Configuración "domain" y "search":
interface "eth0" {
  prepend domain-name "jesus.gonzalonazareno.org";
  prepend domain-search "jesus.gonzalonazareno.org";
}
~~~

##### Acceso a la base de datos.
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
##### Configuración de FQDN y Domain.
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

- Eliminación del enlace simbólico a `/etc/resolv.conf`:
~~~
ubuntu@tortilla:~$ sudo unlink /etc/resolv.conf
~~~

- Creación del nuevo fichero `/etc/resolv.conf`:
~~~
domain jesus.gonzalonazareno.org
search jesus.gonzalonazareno.org
nameserver 192.168.202.2
~~~

##### Instalación y configuración de la base de datos.
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

MariaDB [(none)]> grant all on prueba_remoto.* to cliente_remoto@10.0.0.4 identified by "salmorejo";
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> 
~~~

### Configuración Salmorejo.
##### Configuración de FQDN y Domain.
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

- Modificación del fichero `/etc/sysconfig/network-scripts/ifcfg-eth0`:
~~~
PEERDNS=no
~~~

- Modificación del fichero `/etc/resolv.conf`:
~~~
domain jesus.gonzalonazareno.org
search jesus.gonzalonazareno.org
nameserver 192.168.202.2
~~~

##### Acceso a la base de datos.
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

##### Instalación de Nginx + PhP.
- Instalación del repositorio `epel`:
~~~
[centos@salmorejo ~]$ sudo yum install epel-release
~~~

- Instalación del repositorio `remi`:
~~~
[centos@salmorejo ~]$ sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
~~~

- Instalación del repositorio de `Nginx`:
~~~
[centos@salmorejo ~]$ sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
~~~

- Instalación de `Nginx`:
~~~
[centos@salmorejo ~]$ sudo yum install nginx
~~~

- Instalación de `php`:
~~~
[centos@salmorejo ~]$ sudo yum --enablerepo=remi-php72 install php
~~~

- Instalación de `php-fpm` y `php-common`:
~~~
[centos@salmorejo ~]$ sudo yum install php-fpm php-common
~~~

- Inicio de `Nginx` y `php-fpm`:
~~~
[centos@salmorejo ~]$ sudo systemctl start nginx php-fpm
~~~

- Configuración de php en el virtual host `pruebas-php` (`/etc/nginx/conf.d/pruebas-php.conf`):
~~~
server {
  listen 80;

  root /var/www/pruebas-php;
  index index.html index.php;

  server_name pruebas-php.iesgn.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~
