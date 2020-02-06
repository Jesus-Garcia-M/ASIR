# Interconexión de servidores.
### Conexión Oracle - Oracle.
- Configuración del fichero `tnsnames.ora` en el primer servidor (`$ORACLE_HOME/network/admin`):
~~~
ServidorRemoto =
  (DESCRIPTION =
    (ADDRESS =
      (PROTOCOL = TCP)
      (HOST = 192.168.1.127)
      (PORT = 1521)
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )
~~~

- Creación del usuario en el segundo servidor:
~~~
SQL> CREATE USER remoto IDENTIFIED BY "remoto";

Usuario creado.

SQL>
~~~

- Creación del `DATABASE LINK` en el primer servidor:
~~~
#----- Creación del enlace -----#
CREATE DATABASE LINK EnlaceDB
CONNECT TO remoto
IDENTIFIED BY "remoto"
  4  USING 'ServidorRemoto';

Enlace con la base de datos creado.

SQL>

#----- Comprobación -----#
SQL> SELECT * FROM dba_db_links WHERE db_link = 'ENLACEDB';

OWNER                | DB_LINK              | USERNAME             | HOST                 | CREATED
____________________ | ____________________ | ____________________ | ____________________ | ____________________
SYS                  | ENLACEDB             | REMOTO               | ServidorRemoto       | 23/12/19

SQL>
~~~

- Pruebas de funcionamiento del enlace:
~~~
SQL> SELECT * FROM pruebainterconexion@EnlaceDB;

CODIGO
____________________
1
2
3

SQL>
~~~

### Conexión PostgreSQL - PostgreSQL.
- Creación del usuario en el segundo servidor para permitir el acceso:
~~~
postgres@base:~$createuser --pwprompt remoto
Ingrese la contraseña para el nuevo rol: 
Ingrésela nuevamente:
postgres@base:~$
~~~

- Instalación de `postgres_fdw` en el primer servidor, lo que nos permitirá conectarnos a la base de datos remota:
~~~
postgres=# CREATE EXTENSION postgres_fdw;
CREATE EXTENSION
postgres=#
~~~

- Creación de la conexión mediante `CREATE SERVER`:
~~~
postgres=# CREATE SERVER servidor_remoto FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '192.168.1.112', port '5432', dbname 'pruebainterconexion');
CREATE SERVER
postgres=#
~~~

- Establecer el usuario que vamos a utilizar mediante `CREATE USER MAPPING`:
~~~
postgres=# CREATE USER MAPPING FOR postgres SERVER servidor_remoto OPTIONS (user 'remoto', password 'remoto');
CREATE USER MAPPING
postgres=# 
~~~

- Creación de una `foreign table` apuntando a la table en el servidor remoto:
~~~
postgres=# CREATE FOREIGN TABLE prueba_remoto (codigo NUMERIC) SERVER servidor_remoto OPTIONS (schema_name 'public', table_name 'prueba');
CREATE FOREIGN TABLE
postgres=#
~~~

- Prueba de funcionamiento:
~~~
postgres=# SELECT * FROM prueba_remoto;
 codigo
--------
     10
     11
     12
     13
(4 filas)

postgres=#
~~~

### Conexión PostgreSQL - Oracle.
- Descarga e instalación de `Oracle Instant-client` y `oracle_fwd`:
~~
postgres@base:~/instantclient$ wget https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip
--2019-12-23 18:56:50--  https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip
Resolviendo download.oracle.com (download.oracle.com)... 23.214.200.42
Conectando con download.oracle.com (download.oracle.com)[23.214.200.42]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 75169949 (72M) [application/zip]
Grabando a: instantclient-basic-linux.x64-19.5.0.0.0dbru.zip

instantclient-basic-linux.x64-19.5.0. 100%[======================================================================>]  71,69M  31,3MB/s    in 2,3s

2019-12-23 18:56:53 (31,3 MB/s) - instantclient-basic-linux.x64-19.5.0.0.0dbru.zip guardado [75169949/75169949]

postgres@base:~/instantclient$ export LD_LIBRARY_PATH=/var/lib/instantclient:$LD_LIBRARY_PATH
postgres@base:~/instantclient$




postgres@base:~$ wget http://api.pgxn.org/dist/oracle_fdw/2.2.0/oracle_fdw-2.2.0.zip
--2019-12-23 18:34:56--  http://api.pgxn.org/dist/oracle_fdw/2.2.0/oracle_fdw-2.2.0.zip
Resolviendo api.pgxn.org (api.pgxn.org)... 88.198.49.178
Conectando con api.pgxn.org (api.pgxn.org)[88.198.49.178]:80... conectado.
Petición HTTP enviada, esperando respuesta... 301 Moved Permanently
Localización: https://api.pgxn.org/dist/oracle_fdw/2.2.0/oracle_fdw-2.2.0.zip [siguiendo]
--2019-12-23 18:34:57--  https://api.pgxn.org/dist/oracle_fdw/2.2.0/oracle_fdw-2.2.0.zip
Conectando con api.pgxn.org (api.pgxn.org)[88.198.49.178]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 132988 (130K) [application/zip]
Grabando a: oracle_fdw-2.2.0.zip

oracle_fdw-2.2.0.zip                  100%[======================================================================>] 129,87K  --.-KB/s    in 0,1s

2019-12-23 18:34:57 (1,12 MB/s) - oracle_fdw-2.2.0.zip guardado [132988/132988]

postgres@base:~$ unzip oracle_fdw-2.2.0.zip
Archive:  oracle_fdw-2.2.0.zip
...
postgres@base:~$
~~~
