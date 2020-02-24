### Activa desde `SQL*Plus` la auditoría de los intentos de acceso fallidos al sistema. Comprueba su funcionamiento. 
~~~
# Activar auditorias
SQL> ALTER SYSTEM SET audit_trail=db scope=spfile;
# Explicar opciones; db, db extended, os, xml, xml extended, none

Sistema modificado.

SQL>

# Activar la auditoria de intentos de autenticación fallidos.
SQL> AUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

Auditoría terminada correctamente.

SQL>

# Prueba de funcionamiento.
oracle@OracleJessie:~$ rlwrap sqlplus jesus

SQL*Plus: Release 12.1.0.2.0 Production on Vie Feb 14 14:12:56 2020

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Introduzca la contraseña: 
ERROR:
ORA-01017: invalid username/password; logon denied


Introduzca el nombre de usuario: system as sysdba
Introduzca la contraseña: 

Conectado a:
Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options


Sesión modificada.

SQL> SELECT os_username, username, userhost, timestamp FROM dba_audit_trail;

OS_USERNAME            | USERNAME           | USERHOST           | TIMESTAMP
______________________ | __________________ | __________________ | ____________________
oracle                 | JESUS              | OracleJessie       | 14/02/20

SQL> 
~~~

### Realiza un procedimiento en PL/SQL que te muestre los accesos fallidos junto con el motivo de los mismos, transformando el código de error almacenado en un mensaje de texto comprensible.

### Activa la auditoría de las operaciones DML realizadas por SCOTT. Comprueba su funcionamiento.
~~~
# Activación de auditoría.
SQL> AUDIT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE BY scott BY ACCESS;

Auditoría terminada correctamente.

SQL>

# Pruebas de funcionamiento:
oracle@OracleJessie:~$ rlwrap sqlplus SCOTT/TIGER

SQL*Plus: Release 12.1.0.2.0 Production on Vie Feb 14 14:34:52 2020

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Hora de Última Conexión Correcta: Vie Feb 14 2020 14:29:03 +01:00

Conectado a:
Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options


Sesión modificada.

SQL> 

## SELECT.
SQL> SELECT * FROM pruebaprivs;

C
-
1

SQL>

## INSERT.
SQL> INSERT INTO pruebaprivs VALUES (2);

1 fila creada.

SQL> 

## UPDATE.
SQL> UPDATE pruebaprivs
  2  SET codigo = 3
  3  WHERE codigo = 1;

1 fila actualizada.

SQL>

## DELETE.
SQL> DELETE FROM pruebaprivs
  2  WHERE codigo = 2;

1 fila suprimida.

SQL> 

## Comprobación auditoría.
SQL> SELECT os_username, username, action_name, obj_name, timestamp FROM dba_audit_object WHERE username = 'SCOTT';

OS_USERNAME	     | USERNAME 	    | ACTION_NAME	   | OBJ_NAME		  | TIMESTAMP
________________ | ______________ | ______________ | ____________________ | ____________________
oracle	     | SCOTT	    | DELETE         | PRUEBAPRIVS	        | 18/02/20
oracle	     | SCOTT	    | UPDATE         | PRUEBAPRIVS	        | 18/02/20
oracle	     | SCOTT	    | SELECT         | PRUEBAPRIVS	        | 18/02/20
oracle	     | SCOTT	    | INSERT         | PRUEBAPRIVS	        | 18/02/20

10 filas seleccionadas.

SQL> 
~~~

### Realiza una auditoría de grano fino para almacenar información sobre la inserción de empleados del departamento 10 en la tabla emp de scott.

### Explica la diferencia entre auditar una operación by access o by session.

### Documenta las diferencias entre los valores db y db, extended del parámetro audit_trail de ORACLE. Demuéstralas poniendo un ejemplo de la información sobre una operación concreta
recopilada con cada uno de ellos.

### Localiza en Enterprise Manager las posibilidades para realizar una auditoría e intenta repetir con dicha herramienta los apartados 1, 3 y 4.

### Averigua si en Postgres se pueden realizar los apartados 1, 3 y 4. Si es así, documenta el proceso adecuadamente.

### Averigua si en MySQL se pueden realizar los apartados 1, 3 y 4. Si es así, documenta el proceso adecuadamente.

### Averigua las posibilidades que ofrece MongoDB para auditar los cambios que va sufriendo un documento.

### Averigua si en MongoDB se pueden auditar los accesos al sistema.