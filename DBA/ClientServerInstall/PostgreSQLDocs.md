### Instalación del servidor.
- Instalación de PostgreSQL 11.5.
~~~
ftirado@nazo:~$ sudo apt install postgresql
~~~

- Creación del usuario `postgres` en caso de que no exista.
~~~
ftirado@nazo:~$ sudo useradd -m postgres
~~~

### Configuración de acceso remoto.
- Modificación del parámetro `listen addresses` en el fichero `/etc/postgresql/11/main/postgresql.conf`:
~~~
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

listen_addresses = '*'          # what IP address(es) to listen on;
~~~

- Modificación del parámetro `host` en el fichero `/etc/postgresql/11/main/pg_hba.conf`:
~~~
# IPv4 local connections:
host	all		all		all		md5
~~~

- Reinicio del servicio para que los cambios surtan efecto:
~~~
sudo systemctl restart postgresql
~~~

### Creación del usuario y base de datos para el acceso remoto.
- Creación del usuario:
~~~
createuser invitado 1
~~~

- Creación de la base de datos:
~~~
createdb invitado1_db -O invitado1
~~~

- Asignación de contraseña al usuario creado:
~~~
postgres=# alter user invitado1 with password 'hola123';
~~~

- Asignación de los permisos necesarios al usuario creado:
~~~
invitado1_db=# grant all privileges on all tables in schema public to invitado1;
~~~

### Conexión desde cliente remoto.
- Prueba de funcionamiento:
~~~
vagrant@psql:~$ sudo psql -h 192.168.1.41 -U invitado1 -d invitado1_db
Password for user invitado1: 
psql (11.5 (Debian 11.5-1+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

invitado1_db=> create table Personal
invitado1_db-> (
invitado1_db(>  DNI VARCHAR(9),
invitado1_db(>  Nombre VARCHAR(20),
invitado1_db(>  Apellidos VARCHAR(20),
invitado1_db(>  Direccion VARCHAR(50),
invitado1_db(>  Telefono VARCHAR(9),
invitado1_db(>  Correo_electronico VARCHAR(50),
invitado1_db(>  FechaNacimiento DATE,
invitado1_db(>  constraint pk_personal PRIMARY KEY(DNI),
invitado1_db(>  constraint telefunico UNIQUE(Telefono),
invitado1_db(>  constraint correounico UNIQUE(Correo_electronico),
invitado1_db(>  constraint restricdni check((DNI ~ '^[0-9]{8}[A-Z]$') or (DNI ~ '^[K,L,M,X,Y,Z][0-9]{7}[A-Z]$')),
invitado1_db(>  constraint restriccorreo check(Correo_electronico ~ '^.+@.+\.(com|es|org|uk|eu|edu|gov|gob|net|info)$')
invitado1_db(> );
CREATE TABLE
invitado1_db=> insert into Personal
invitado1_db-> values('49090698G','Juan','Pérez','Calle Alfonso Díaz, 6','654345231','juanperez@hotmail.com','15-10-1982');
INSERT 0 1
invitado1_db=> insert into Personal
invitado1_db-> values('38234545N','Paola','Domenech','Avenida Llano, 16','685447635','mapuchin@hotmail.com','23-07-1990');
INSERT 0 1
invitado1_db=> insert into Personal
invitado1_db-> values('95844075Q','Leire','Cortes','Calle Plata, 8','610430005','leirco@hotmail.com','12-09-1963');
INSERT 0 1
invitado1_db=>
~~~

### Herramienta de administración phppgadmin.
- Instalación de dependencias:
~~~
vagrant@psqlserver:~$ sudo apt install php-pgsql
~~~

- Instalación:
~~~
vagrant@psqlserver:~$ sudo apt install phppgadmin
~~~

- Comentar la directiva `Require` (`/etc/apache2/conf-available/phppgadmin.conf`):
- Modificación del parámetro `extra_login_security` a `false` (`/etc/phppgadmin/config.inc.php`):
- Modificación de los parámetros de conexión necesarios (`/etc/phppgadmin/config.inc.php`):
~~~
...
// Display name for the server on the login screen
$conf['servers'][0]['desc'] = 'PostgreSQL';
$conf['servers'][1]['desc'] = 'Servidor';
// Hostname or IP address for
// use 'localhost' for TCP/IP
$conf['servers'][0]['host'] =
$conf['servers'][1]['host'] =
server. Use '' for UNIX domain soc$
connection on this computer
'localhost';
'192.168.1.55';
// Database port on server (5432 is the PostgreSQL default)
$conf['servers'][0]['port'] = 5432;
$conf['servers'][1]['port'] = 5432;
...
~~~