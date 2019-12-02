### Crea un rol rolpractica1 con los privilegios necesarios para conectarse a la base de datos, crear tablas y vistas e insertar datos en la tabla EMP de SCOTT.
- Creación del rol:
~~~
SQL> CREATE ROLE rolpractica1;

Rol creado.

SQL> 
~~~

- Asignación de privilegios al rol:
~~~
#----- Conexión a la base de datos -----#
SQL> GRANT CREATE SESSION TO rolpractica1;

Concesión terminada correctamente.

SQL>

#----- Crear tablas -----#
SQL> GRANT CREATE TABLE TO rolpractica1;

Concesión terminada correctamente.

SQL>

#----- Crear vistas -----#
SQL> GRANT CREATE VIEW TO rolpractica1;

Concesión terminada correctamente.

SQL>

#----- Inserción de datos en la tabla EMP -----#
SQL> GRANT INSERT ON SCOTT.EMP TO rolpractica1;

Concesión terminada correctamente.

SQL>
~~~

- Comprobación:
~~~
SELECT privilege, concat(concat(owner, ' / '), table_name) AS "Usuario/Tabla"
FROM role_tab_privs
WHERE role = 'ROLPRACTICA1'
UNION
SELECT privilege, ''
FROM role_sys_privs
  7  WHERE role = 'ROLPRACTICA1';

PRIVILEGE                                | Usuario/Tabla
________________________________________ | _____________________________________
CREATE SESSION                           |
CREATE TABLE                             |
CREATE VIEW                              |
INSERT                                   | SCOTT / EMP

SQL>
~~~

### Crea un usuario usrpractica1 con el tablespace USERS por defecto y averigua que cuota se le ha asignado por defecto en el mismo. Sustitúyela por una cuota de 1M.
- Creación del usuario:
~~~
SQL> CREATE USER usrpractica1 IDENTIFIED BY "usrpractica1" DEFAULT TABLESPACE users;
~~~

- Comprobación de cuota:
~~~
# Por defecto no se le asigna ninguna cuota al usuario, puede crear la tabla ya que esta se crea en el tablespace 'SYSTEM', pero,
# al insertar un registro debe acceder al tablespace 'USERS' y no puede realizar dicha acción, adicionalmente, como se muestra,
# la vista 'USER_TABLESPACES' está vacía.
SQL> SELECT user FROM dual;

USER
------------------------------
USRPRACTICA1

SQL> create table prueba (codigo VARCHAR2(1));

Tabla creada.

SQL> INSERT INTO prueba values (1);
INSERT INTO prueba values (1)
            *
ERROR en línea 1:
ORA-01950: no existen privilegios en tablespace 'USERS'


SQL> SELECT * FROM user_tablespaces;

ninguna fila seleccionada

SQL>
~~~

- Modificación de la cuota en el tablespace `USERS`:
~~~
#----- Modificación Cuota -----#
SQL> ALTER USER usrpractica1 QUOTA 1M ON users;

Usuario modificado.

SQL>

#----- Comprobación -----#
SELECT concat(concat(tablespace_name, ' / '), username) AS "TS / User", max_bytes
FROM dba_ts_quotas
  3  WHERE username = 'USRPRACTICA1';

TS / User                                     |  MAX_BYTES
_____________________________________________ | __________
USERS / USRPRACTICA1                          |    1048576

SQL>
~~~


### Modifica el usuario usrpractica1 para que tenga cuota 0 en el tablespace SYSTEM.
- Modificación de la cuota en el tablespace `SYSTEM`:
~~~
#----- Modificación de la cuota -----#
SQL> ALTER USER usrpractica1 QUOTA 0 ON system;

Usuario modificado.

SQL> 

#----- Comprobación -----#
SELECT concat(concat(tablespace_name, ' / '), username) AS "TS / User", max_bytes
FROM dba_ts_quotas
WHERE username = 'USRPRACTICA1'
  4  AND tablespace_name = 'SYSTEM';

ninguna fila seleccionada

SQL> 
~~~

### Concede a usrpractica1 el rolpractica1.
- Concesión del rol:
~~~
#----- Concesión -----#
SQL> GRANT rolpractica1 TO usrpractica1;

Concesión terminada correctamente.

SQL> 

#----- Comprobación -----#
SQL> SELECT grantee FROM dba_role_privs WHERE granted_role = 'ROLPRACTICA1';

GRANTEE
________________________________________________________________________________
USRPRACTICA1
SYS

SQL>
~~~


### Concede a usrpractica1 el privilegio de crear tablas e insertar datos en el esquema de cualquier usuario. Prueba el privilegio. Comprueba si puede modificar la estructura o eliminar las tablas creadas.
- Concesión de privilegios:
~~~
#----- Creación de tablas -----#
SQL> GRANT CREATE ANY TABLE TO usrpractica1;

Concesión terminada correctamente.

SQL>

#----- Inserción de datos -----#
SQL> GRANT INSERT ANY TABLE TO usrpractica1;

Concesión terminada correctamente.

SQL> 
~~~

- Comprobación:
~~~
SQL> SELECT user FROM dual;

USER
------------------------------
USRPRACTICA1

SQL>

#----- Creación de tablas -----#
SQL> CREATE TABLE scott.pruebaprivs (codigo VARCHAR2(1));

Tabla creada.

SQL> 

#----- Inserción de datos -----#
SQL> INSERT INTO scott.pruebaprivs VALUES ('1');

1 fila creada.

SQL>

#----- Modificación de estructura de tablas -----#
SQL> ALTER TABLE scott.pruebaprivs ADD nombre VARCHAR2(20);
ALTER TABLE scott.pruebaprivs ADD nombre VARCHAR2(20)
*
ERROR en línea 1:
ORA-01031: privilegios insuficientes


SQL>

#----- Eliminación de tablas -----#
SQL> DROP TABLE scott.pruebaprivs;
DROP TABLE scott.pruebaprivs
                 *
ERROR en línea 1:
ORA-01031: privilegios insuficientes


SQL>
~~~

### Concede a usrpractica1 el privilegio de leer la tabla DEPT de SCOTT con la posibilidad de que lo pase a su vez a terceros usuarios.
- Concesión del privilegio:
~~~
SQL> GRANT SELECT ON scott.dept TO usrpractica1 WITH GRANT OPTION;

Concesión terminada correctamente.

SQL>
~~~

- Comprobación:
~~~
#----- Comprobación -----#
SQL> SELECT concat(concat(owner, ' / '), table_name) AS "Propietario / Tabla", concat(concat(privilege, ' / '), grantable) AS "Privilegio / Delegable" FROM dba_tab_privs WHERE grantee = 'USRPRACTICA1';

Propietario / Tabla
________________________________________
Privilegio / Delegable
________________________________________
SCOTT / DEPT
SELECT / YES


SQL>

#----- Prueba de funcionamiento -----#
SQL> SELECT user FROM dual;

USER
------------------------------
USRPRACTICA1

SQL> SELECT * FROM scott.dept;

    DEPTNO | DNAME          | LOC
__________ | ______________ | _____________
        10 | ACCOUNTING     | NEW YORK
        20 | RESEARCH       | DALLAS
        30 | SALES          | CHICAGO
        40 | OPERATIONS     | BOSTON

SQL> GRANT SELECT ON scott.dept TO user_privs;

Concesión terminada correctamente.

SQL>
~~~

### Comprueba que usrpractica1 puede realizar todas las operaciones previstas en el rol.
- Prueba de funcionamiento:
~~~
#----- Iniciar sesión en la base de datos -----#
oracle@OracleJessie:~$ rlwrap sqlplus usrpractica1/usrpractica1

SQL*Plus: Release 12.1.0.2.0 Production on Jue Nov 28 18:56:01 2019

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Hora de Última Conexión Correcta: Jue Nov 28 2019 18:49:48 +01:00

Conectado a:
Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options


Sesión modificada.

SQL> 

#----- Crear tablas -----#
SQL> CREATE TABLE prueba_privs_tabla (codigo VARCHAR2(1));

Tabla creada.

SQL>

#----- Crear vistas -----#
CREATE VIEW prueba_privs_vista AS
  2  SELECT * FROM scott.dept;

Vista creada.

SQL>

#----- Insertar datos en la tabla emp de scott -----#
SQL> INSERT INTO scott.emp (empno, ename, deptno) VALUES ('9', 'Jesus', '20');

1 fila creada.

SQL>
~~~

### Quita a usrpractica1 el privilegio de crear vistas. Comprueba que ya no puede hacerlo.
- Revocación de los permisos:
~~~
GRANT rol1 TO rol2 - revoke create view from rol2
~~~

- Prueba de funcionamiento:
~~~

~~~

### Crea un perfil NOPARESDECURRAR que limita a dos el número de minutos de inactividad permitidos en una sesión.
- Creación del perfil:
~~~
SQL> CREATE PROFILE NoParesDeCurrar LIMIT
  2  IDLE_TIME 2;

Perfil creado.

SQL>
~~~

- Comprobación:
~~~
SQL> SELECT limit, common, resource_type FROM dba_profiles WHERE profile = 'NOPARESDECURRAR' AND resource_name = 'IDLE_TIME';

LIMIT      | COM | RESOURCE
__________ | ___ | ________
2          | YES | KERNEL

SQL>
~~~

### Activa el uso de perfiles en ORACLE.
~~~
SQL> ALTER SYSTEM SET RESOURCE_LIMIT=TRUE;

Sistema modificado.

SQL>
~~~
### Asigna el perfil creado a usrpractica1 y comprueba su correcto funcionamiento.
- Asignación del perfil:
~~~
SQL> ALTER USER usrpractica1 PROFILE noparesdecurrar;

Usuario modificado.

SQL>
~~~

- Prueba de funcionamiento:
~~~

~~~

### Crea un perfil CONTRASEÑASEGURA especificando que la contraseña caduca mensualmente y sólo se permiten tres intentos fallidos para acceder a la cuenta. En caso de superarse, la cuenta debe quedar bloqueada indefinidamente.
- Creación del perfil:
~~~

~~~

- Comprobación:
~~~

~~~

### Asigna el perfil creado a usrpractica1 y comprueba su funcionamiento. Desbloquea posteriormente al usuario.
- Asiganción del perfil:
~~~

~~~

- Prueba de funcionamiento:
~~~

~~~

- Desbloqueo del usuario:
~~~

~~~

### Consulta qué usuarios existen en tu base de datos.
- Consulta:
~~~
SQL> SELECT username FROM dba_users;
~~~

### Elige un usuario concreto y consulta qué cuota tiene sobre cada uno de los tablespaces.
- Consulta:
~~~

~~~

### Elige un usuario concreto y muestra qué privilegios de sistema tiene asignados.
- Consulta:
~~~
SQL> SELECT privilege, admin_option FROM dba_sys_privs WHERE grantee = 'SYSTEM';
~~~

### Elige un usuario concreto y muestra qué privilegios sobre objetos tiene asignados.
- Consulta:
~~~
SQL> SELECT owner, table_name, privilege, type, grantable FROM dba_tab_privs WHERE grantee = 'BECARIO';
~~~

### Consulta qué roles existen en tu base de datos.
- Consulta:
~~~
SQL> SELECT role FROM dba_roles;
~~~

### Elige un rol concreto y consulta qué usuarios lo tienen asignado.
- Consulta:
~~~
SQL> SELECT grantee FROM dba_role_privs WHERE granted_role = 'CONNECT';
~~~

### Elige un rol concreto y averigua si está compuesto por otros roles o no.
- Consulta:
~~~
SQL> SELECT granted_role FROM role_role_privs WHERE role = 'DBA';
~~~

### Consulta qué perfiles existen en tu base de datos.
- Consulta:
~~~
SQL> SELECT DISTINCT profile FROM dba_profiles;
~~~

### Elige un perfil y consulta qué límites se establecen en el mismo.
- Consulta:
~~~
SQL> SELECT resource_name, limit FROM dba_profiles WHERE profile = 'DEFAULT';
~~~

### Muestra los nombres de los usuarios que tienen limitado el número de sesiones concurrentes.
- Consulta:
~~~
SELECT username
FROM dba_users
WHERE profile IN (SELECT profile
                 FROM dba_profiles
                 WHERE resource_name = 'SESSIONS_PER_USER');
~~~

### Realiza un procedimiento que reciba un nombre de usuario y un privilegio de sistema y nos muestre el mensaje 'SI, DIRECTO' si el usuario tiene ese privilegio concedido directamente, 'SI, POR ROL' si el usuario tiene ese privilegio en alguno de los roles que tiene concedidos y un 'NO' si el usuario no tiene dicho privilegio.

### Realiza un procedimiento llamado MostrarNumSesiones que reciba un nombre de usuario y muestre el número de sesiones concurrentes que puede tener abiertas como máximo y las que tiene abiertas realmente.