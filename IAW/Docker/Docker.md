# Docker
### Tarea 1. Ejecución de una aplicación web PHP en docker.
En esta tarea crearemos dos contenedores (base de datos y aplicación) para ejecutar la aplicación [Bookmedik](https://github.com/evilnapsis/bookmedik) a partir de la imagen de [Debian](https://hub.docker.com/_/debian).

Configuración de `docker-compose`:
~~~
version: '3.1'

services:
  db:
    container_name: bookmedik_db
    image: mariadb
    restart: always
    environment:
      MYSQL_USER: bookmedik
      MYSQL_PASSWORD: bookmedik
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - /opt/docker/ej1/db:/var/lib/mysql
~~~

Creación del contenedor `MariaDB` y de la base de datos:
~~~
root@docker:~/docker/ej1/compose# docker-compose up -d db
Creating bookmedik_db ... done
root@docker:~/docker/ej1/compose#

# Modificamos el fichero para dar permisos al usuario "bookmedik":
GRANT ALL ON bookmedik.* TO bookmedik@'%';

root@docker:~# cat schema.sql | docker exec -i mariadb /usr/bin/mysql -u root --password=root
root@docker:~# docker exec -it bookmedik_db bash
root@8cea33540cd2:/# mysql -u root -p bookmedik
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 10
Server version: 10.4.12-MariaDB-1:10.4.12+maria~bionic mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [bookmedik]> show tables;
+---------------------+
| Tables_in_bookmedik |
+---------------------+
| category            |
| medic               |
| pacient             |
| payment             |
| reservation         |
| status              |
| user                |
+---------------------+
7 rows in set (0.001 sec)

MariaDB [bookmedik]> 
~~~

Clonamos el repositorio de la aplicación para posteriormente utilizarlo como volumen en el contenedor con la aplicación:
~~~
root@docker:~# git clone https://github.com/evilnapsis/bookmedik.git /opt/docker/ej1/app
Cloning into '/opt/docker/ej1/app'...
remote: Enumerating objects: 856, done.
remote: Total 856 (delta 0), reused 0 (delta 0), pack-reused 856
Receiving objects: 100% (856/856), 1.90 MiB | 1024.00 KiB/s, done.
Resolving deltas: 100% (372/372), done.
root@docker:~# 
~~~

Modificamos el fichero `core/controller/Database.php` para poder acceder a la base de datos a través de variables de entorno:
~~~
class Database {
        public static $db;
        public static $con;
        function Database(){
                $this->user=getenv('MYSQL_USER');
                $this->pass=getenv('MYSQL_PASSWORD');
                $this->host=getenv('MYSQL_HOST');
                $this->ddbb="bookmedik";
        }
~~~

Creamos el `Dockerfile` para posteriormente crear la imagen:
~~~
FROM debian
MAINTAINER Jesús García Muñox "jesus.garcia.inf@gmail.com"

RUN apt update && apt upgrade -y && apt install -y apache2 libapache2-mod-php && apt install php7.3-mysql && apt clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
~~~

Creamos la imagen:
~~~
root@docker:~/docker/ej1/build# docker build -t jesusgarciam/apache2php:v2 .
...
root@docker:~/docker/ej1/build# docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
jesusgarciam/apache2php   v2                  59ee3efa5bc4        2 hours ago         251MB
jesusgarciam/apache2php   v1                  89666da71958        3 days ago          251MB
debian                    latest              a8797652cfd9        2 weeks ago         114MB
mariadb                   latest              1f9cfa8dc305        2 weeks ago         356MB
root@docker:~/docker/ej1/build# 
~~~

Añadimos la configuración del nuevo contenedor a `docker-compose`:
~~~
  app:
    container_name: bookmedik
    image: jesusgarciam/apache2php:v2
    restart: always
    environment:
      MYSQL_USER: bookmedik
      MYSQL_PASSWORD: bookmedik
      MYSQL_HOST: bookmedik_db
    ports:
      - 80:80
    volumes:
      - /opt/docker/ej1/app:/var/www/html
      - /opt/docker/ej1/logs:/var/log/apache2
~~~

Creamos el contenedor:
~~~
root@docker:~/docker/ej1/compose# docker-compose up -d app
Creating bookmedik ... done
root@docker:~/docker/ej1/compose#
~~~

Prueba de funcionamiento:
![LogIn](images/ej1/login.png)
![App](images/ej1/app.png)

Por último, comprobaremos el funcionamiento de los datos persistentes, borrando el contenedor con la base de datos y volviendo a crearlo:
~~~
root@docker:~/docker/ej1/compose# docker-compose stop db
Stopping bookmedik_db ... done
root@docker:~/docker/ej1/compose# docker-compose rm db
Going to remove bookmedik_db
Are you sure? [yN] y
Removing bookmedik_db ... done
root@docker:~/docker/ej1/compose# docker-compose up -d db
Creating bookmedik_db ... done
root@docker:~/docker/ej1/compose# 
~~~

Prueba de funcionamiento:
![Datos Persistentes](images/ej1/persistent.png)

### Tarea 2. Ejecución de una aplicación web PHP en dockerPermalink
En este caso, la tarea será similar a la anterior, solo que utilizaremos la imagen de [PHP](https://hub.docker.com/_/php) en vez de la de Debian.

### Tarea 4. Ejecución de un CMS en Docker (Imagen base).

### Tarea 5. Ejecución de un CMS en Docker (Imagen del CMS).
En este caso vamos a utilizar [Owncloud](https://hub.docker.com/_/owncloud) y la estructura será la siguiente:
- 1 contenedor con el servidor de base de datos (`MariaDB`).
- 1 contenedor con `Owncloud`.
- Datos persistentes.
- Despliegue con `docker-compose`.

Configuración de `docker-compose`:
~~~
version: '3.1'

services:
  db:
    container_name: owncloud_db
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: oc_db
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - /opt/docker/ej5/db:/var/lib/mysql

  owncloud:
    container_name: owncloud
    image: owncloud
    restart: always
    ports:
      - 80:80
    volumes:
      - /opt/docker/ej5/owncloud/apps:/var/www/html/apps
      - /opt/docker/ej5/owncloud/config:/var/www/html/config
      - /opt/docker/ej5/owncloud/data:/var/www/html/data
~~~

Creación del escenario:
~~~
root@docker:~/docker/ej5/compose/owncloud# docker-compose up -d
Creating network "owncloud_default" with the default driver
Pulling owncloud (owncloud:)...
latest: Pulling from library/owncloud
177e7ef0df69: Pull complete
9bf89f2eda24: Pull complete
350207dcf1b7: Pull complete
a8a33d96b4e7: Pull complete
c0421d5b63d6: Pull complete
f76e300fbe72: Pull complete
af9ff1b9ce5b: Pull complete
d9f072d61771: Pull complete
a6c512d0c2db: Pull complete
5a99458af5f8: Pull complete
8f2842d661a0: Pull complete
3c71c5361f06: Pull complete
baeacbad0a0c: Pull complete
e60049bf081a: Pull complete
0619078e32d3: Pull complete
a8e482ee2313: Pull complete
174d1b06857d: Pull complete
4a86c437f077: Pull complete
5e9ed4c3df2d: Pull complete
8a1479477c8e: Pull complete
8ab262044e9e: Pull complete
Digest: sha256:173811cb4c40505401595a45c39a802b89fb476885b3f6e8fe327aae08d20fe8
Status: Downloaded newer image for owncloud:latest
Creating owncloud    ... done
Creating owncloud_db ... done
root@docker:~/docker/ej5/compose/owncloud# 
~~~

Instalación de `Owncloud`:
![Instalación](images/ej5/inst1.png)
![App Instalada](images/ej5/inst2.png)

Para comprobar el buen funcionamiento de los datos persistentes, eliminaremos los contenedores y volveremos a crearlos:
~~~
root@docker:~/docker/ej5/compose/owncloud# docker-compose stop
Stopping owncloud_db ... done
Stopping owncloud    ... done
root@docker:~/docker/ej5/compose/owncloud# docker-compose rm
Going to remove owncloud_db, owncloud
Are you sure? [yN] y
Removing owncloud_db ... done
Removing owncloud    ... done
root@docker:~/docker/ej5/compose/owncloud# docker-compose up -d
Creating owncloud_db ... done
Creating owncloud    ... done
root@docker:~/docker/ej5/compose/owncloud# 
~~~

Prueba de funcionamiento:
![Persistente LogIn](images/ej5/persistent1.png)
![Persistente App](images/ej5/persistent2.png)