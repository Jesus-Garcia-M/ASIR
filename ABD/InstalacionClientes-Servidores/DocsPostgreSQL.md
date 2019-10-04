#### Instalación del servidor.
- Instalación de PostgreSQL 11.5.
~~~
apt install postgresql
~~~

- Creación del usuario `postgres` en caso de que no exista.
~~~
useradd -m postgres
~~~

#### Configuración de acceso remoto.
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

#### Creación del usuario y base de datos para el acceso remoto.
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