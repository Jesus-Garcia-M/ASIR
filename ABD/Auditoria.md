### Activa desde `SQL*Plus` la auditoría de los intentos de acceso fallidos al sistema. Comprueba su funcionamiento.
En `Oracle` existen varios tipos de almacenamiento de auditorías, escogiendo con el parámetro `AUDIT_TRAIL`:
- `db o true`: Los registros se guardan en la auditoría de la base de datos.
- `db, extended`: Igual que `db`, pero también se rellenan las columnas `SQL_BIND` y `SQL_TEXT`.
- `xml`: Igual que `db` pero en formato XML.
- `xml, extended`: Igual que `db, extended` pero en formato XML.
- `os`: Los registros se guardan en la auditoría del sistema.

En este caso, utilizaremos `db` para poder acceder a los registros de forma más sencilla:
~~~
SQL> ALTER SYSTEM SET audit_trail=db scope=spfile;

Sistema modificado.

SQL>
~~~

Una vez activadas, debemos crear una auditoría para los inicios de sesión fallidos:
~~~
SQL> AUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

Auditoría terminada correctamente.

SQL>
~~~

Por último, comprobamos el funcionamiento:
~~~
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

SQL> SELECT os_username, username, userhost, timestamp FROM dba_audit_trail WHERE action_name = 'LOGON';

OS_USERNAME            | USERNAME           | USERHOST           | TIMESTAMP
______________________ | __________________ | __________________ | ____________________
oracle                 | JESUS              | OracleJessie       | 14/02/20

SQL> 
~~~

### Realiza un procedimiento en PL/SQL que te muestre los accesos fallidos junto con el motivo de los mismos, transformando el código de error almacenado en un mensaje de texto comprensible.
Código programa principal:
~~~
CREATE OR REPLACE PROCEDURE AutenticacionesFallidas
AS
  CURSOR c_logins IS
    SELECT os_username, username, userhost, timestamp, returncode
    FROM dba_audit_trail
    WHERE action_name = 'LOGON';

BEGIN
  FOR elem IN c_logins LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario del sistema: '||elem.os_username||'.');
    DBMS_OUTPUT.PUT_LINE('Usuario de la base de datos: '||elem.username||'.');
    DBMS_OUTPUT.PUT_LINE('Máquina desde la que se accede: '||elem.userhost||'.');
    DBMS_OUTPUT.PUT_LINE('Hora/Fecha del acceso: '||to_char(elem.timestamp, 'DD/MM/YYYY - HH24:MI:SS')||'.');
    AF_CodigosError(elem.returncode);
    DBMS_OUTPUT.PUT_LINE(chr(13));
  END LOOP;

END AutenticacionesFallidas;
/
~~~

Código programa auxiliar:
~~~
CREATE OR REPLACE PROCEDURE AF_CodigosError (p_error NUMBER)
AS
BEGIN
  CASE p_error
    WHEN 1017 THEN DBMS_OUTPUT.PUT_LINE('Motivo: Usuario o Contraseña incorrectos.');
    WHEN 1045 THEN DBMS_OUTPUT.PUT_LINE('Motivo: El usuario no dispone del privilegio "CREATE SESSION".');
    WHEN 3136 THEN DBMS_OUTPUT.PUT_LINE('Motivo: Se ha agotado el tiempo de conexión.');
    WHEN 28000 THEN DBMS_OUTPUT.PUT_LINE('Motivo: La cuenta está bloqueada.');
    WHEN 28001 THEN DBMS_OUTPUT.PUT_LINE('Motivo: La contraseña ha caducado.');
  END CASE;

END AF_CodigosError;
/
~~~

### Activa la auditoría de las operaciones DML realizadas por SCOTT. Comprueba su funcionamiento.
Al igual que en el ejercicio anterior, aunque el sistema de auditorías esté activado, debemos crear distintas auditorías que se adapten a nuestras necesidades, en este caso, monitorizaremos las instrucciones `DML` (`SELECT`, `INSERT`, `UPDATE` y `DELETE`) realizadas por el usuario `SCOTT`:
~~~
SQL> AUDIT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE BY scott BY ACCESS;

Auditoría terminada correctamente.

SQL>
~~~

A continuación, realizamos las distintas acciones para posteriormente comprobar su funcionamiento:
~~~
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

#----- Comprobación auditoría -----#
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
Las auditorías de grano fino permiten registrar movimientos más concretos, para crearlas utilizaremos `DBMS_FGA.ADD_POLICY`:
~~~
BEGIN
  DBMS_FGA.ADD_POLICY (
    object_schema => 'SCOTT',
    object_name => 'EMP',
    policy_name => 'AuditDeparts',
    audit_condition => 'DEPTNO = 10',
    statement_types => 'INSERT'
  );
END;
 10  /

Procedimiento PL/SQL terminado correctamente.

SQL> 

#----- Comprobamos que se ha creado correctamente -----#
SQL> SELECT object_schema, object_name, policy_name FROM dba_audit_policies;

OBJECT_SCHEMA		       | OBJECT_NAME			| POLICY_NAME
______________________________ | ______________________________ | ______________________________
SCOTT			       | EMP				| AUDITDEPARTS

SQL> 
~~~

Una vez creada, comprobaremos su funcionamiento insertando un nuevo empleado en el departamento 10 y otro en el 20:
~~~
#----- Inserción de los datos -----#
SQL> INSERT INTO emp (empno, ename, deptno) VALUES (99, 'Jesus', '10');

1 fila creada.

SQL> INSERT INTO emp (empno, ename, deptno) VALUES (100, 'Jesus1', '20');

1 fila creada.

SQL> 

#----- Comprobación -----#
SQL> SELECT timestamp, sql_text FROM dba_fga_audit_trail WHERE policy_name = 'AUDITDEPARTS';

TIMESTAMP	| SQL_TEXT
____________| ________________________________________________________________________________
25/02/20	| INSERT INTO emp (empno, ename, deptno) VALUES (99, 'Jesus', '10')

SQL> 
~~~