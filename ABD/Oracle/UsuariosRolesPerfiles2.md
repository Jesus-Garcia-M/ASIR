
#### Crea un rol rolpractica1 con los privilegios necesarios para conectarse a la base de datos, crear tablas y vistas e insertar datos en la tabla EMP de SCOTT.
- Creación del rol:
~~
SQL> CREATE ROLE rolpractica1;

Rol creado.

SQL>
~~

- Asignación de privilegios al rol:
~~
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
~~

- Comprobación:
~~
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
~~

#### Crea un usuario usrpractica1 con el tablespace USERS por defecto y averigua que cuota se le ha asignado por defecto en el mismo. Sustitúyela por una cuota de 1M.
- Creación del usuario:
~~
SQL> CREATE USER usrpractica1 IDENTIFIED BY "usrpractica1" DEFAULT TABLESPACE users;
~~

- Comprobación de cuota:
~~
# Por defecto no se le asigna ninguna cuota al usuario, puede crear la tabla ya que para ello se usa el tablespace 'SYSTEM', pero,
# al insertar un registro se hace uso del tablespace 'USERS', por lo que no puede realizar dicha acción, adicionalmente, como se muestra,
# la vista 'USER_TABLESPACES' está vacía, indicando así, que el usuario no dispone de ninguna cuota.
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
~~

- Modificación de la cuota en el tablespace `USERS`:
~~
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
~~


#### Modifica el usuario usrpractica1 para que tenga cuota 0 en el tablespace SYSTEM.
- Modificación de la cuota en el tablespace `SYSTEM`:
~~
SQL> ALTER USER usrpractica1 QUOTA 0 ON system;

Usuario modificado.

SQL>
~~

- Comprobación:
~~
# Al no tener cuota en el tablespace 'SYSTEM', no existe ninguna fila en la tabla.
SELECT concat(concat(tablespace_name, ' / '), username) AS "TS / User", max_bytes
FROM dba_ts_quotas
WHERE username = 'USRPRACTICA1'
  4  AND tablespace_name = 'SYSTEM';

ninguna fila seleccionada

SQL>
~~

#### Concede a usrpractica1 el rolpractica1.
- Concesión del rol:
~~
#----- Concesión -----#
SQL> GRANT rolpractica1 TO usrpractica1;

Concesión terminada correctamente.

SQL>
~~

- Comprobación:
~~
SQL> SELECT grantee FROM dba_role_privs WHERE granted_role = 'ROLPRACTICA1';

GRANTEE
________________________________________________________________________________
USRPRACTICA1
SYS

SQL>
~~


#### Concede a usrpractica1 el privilegio de crear tablas e insertar datos en el esquema de cualquier usuario. Prueba el privilegio. Comprueba si puede modificar la estructura o eliminar las tablas creadas.
- Concesión de privilegios:
~~
#----- Creación de tablas -----#
SQL> GRANT CREATE ANY TABLE TO usrpractica1;

Concesión terminada correctamente.

SQL>

#----- Inserción de datos -----#
SQL> GRANT INSERT ANY TABLE TO usrpractica1;

Concesión terminada correctamente.

SQL>
~~

- Prueba de funcionamiento:
~~
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
~~

#### Concede a usrpractica1 el privilegio de leer la tabla DEPT de SCOTT con la posibilidad de que lo pase a su vez a terceros usuarios.
- Concesión del privilegio:
~~
SQL> GRANT SELECT ON scott.dept TO usrpractica1 WITH GRANT OPTION;

Concesión terminada correctamente.

SQL>
~~

- Comprobación:
~~
SQL> SELECT owner, table_name, privilege, grantable FROM dba_tab_privs WHERE grantee = 'USRPRACTICA1';

OWNER                | TABLE_NAME           | PRIVILEGE            | GRA
____________________ | ____________________ | ____________________ | ___
SCOTT                | DEPT                 | SELECT               | YES

SQL>
~~

- Prueba de funcionamiento:
~~ 
SQL> SELECT user FROM dual;

USER
------------------------------
USRPRACTICA1

#----- Comprobación de efectividad del privilegio -----#
SQL> SELECT * FROM scott.dept;

    DEPTNO | DNAME          | LOC
__________ | ______________ | _____________
        10 | ACCOUNTING     | NEW YORK
        20 | RESEARCH       | DALLAS
        30 | SALES          | CHICAGO
        40 | OPERATIONS     | BOSTON

#----- Comprobación de concesión del privilegio -----#
SQL> GRANT SELECT ON scott.dept TO user_privs;

Concesión terminada correctamente.

SQL>
~~

#### Comprueba que usrpractica1 puede realizar todas las operaciones previstas en el rol.
- Pruebas de funcionamiento:
~~
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
~~

#### Quita a usrpractica1 el privilegio de crear vistas. Comprueba que ya no puede hacerlo.
- Creación del rol `rolpractica2` y asignación del rol `rolpractica1` al mismo:
~~
#----- Creación del rol -----#
SQL> CREATE ROLE rolpractica2;

Rol creado.

SQL>

#----- Asignación de 'rolpractica1' a 'rolpractica2' -----#
SQL> GRANT rolpractica1 TO rolpractica2;

Concesión terminada correctamente.

SQL>
~~

- Revocación del permiso `CREATE VIEW` al rol `rolpractica2`:
~~

~~

- Prueba de funcionamiento:
~~

~~

#### Crea un perfil NOPARESDECURRAR que limita a dos el número de minutos de inactividad permitidos en una sesión.
- Creación del perfil:
~~
SQL> CREATE PROFILE NoParesDeCurrar LIMIT
  2  IDLE_TIME 2;

Perfil creado.

SQL>
~~

- Comprobación:
~~
SQL> SELECT limit FROM dba_profiles WHERE profile = 'NOPARESDECURRAR' AND resource_name = 'IDLE_TIME';

LIMIT
__________
2

SQL>
~~

#### Activa el uso de perfiles en ORACLE.
~~
SQL> ALTER SYSTEM SET RESOURCE_LIMIT=TRUE;

Sistema modificado.

SQL>
~~

#### Asigna el perfil creado a usrpractica1 y comprueba su correcto funcionamiento.
- Asignación del perfil:
~~
SQL> ALTER USER usrpractica1 PROFILE noparesdecurrar;

Usuario modificado.

SQL>
~~

- Prueba de funcionamiento:
~~

~~

#### Crea un perfil passwordsegura especificando que la contraseña caduca mensualmente y sólo se permiten tres intentos fallidos para acceder a la cuenta. En caso de superarse, la cuenta debe quedar bloqueada indefinidamente.
- Creación del perfil:
~~
CREATE PROFILE passwordsegura LIMIT
PASSWORD_LIFE_TIME 30
FAILED_LOGIN_ATTEMPTS 3
  4  PASSWORD_LOCK_TIME unlimited;

Perfil creado.

SQL>
~~

- Comprobación:
~~
SQL> SELECT resource_name, limit FROM dba_profiles WHERE profile = 'PASSWORDSEGURA';

RESOURCE_NAME                  | LIMIT
______________________________ | _______________
COMPOSITE_LIMIT                | DEFAULT
SESSIONS_PER_USER              | DEFAULT
CPU_PER_SESSION                | DEFAULT
CPU_PER_CALL                   | DEFAULT
LOGICAL_READS_PER_SESSION      | DEFAULT
LOGICAL_READS_PER_CALL         | DEFAULT
IDLE_TIME                      | DEFAULT
CONNECT_TIME                   | DEFAULT
PRIVATE_SGA                    | DEFAULT
FAILED_LOGIN_ATTEMPTS          | 3
PASSWORD_LIFE_TIME             | 30
PASSWORD_REUSE_TIME            | DEFAULT
PASSWORD_REUSE_MAX             | DEFAULT
PASSWORD_VERIFY_FUNCTION       | DEFAULT
PASSWORD_LOCK_TIME             | UNLIMITED
PASSWORD_GRACE_TIME            | DEFAULT

16 filas seleccionadas.

SQL>
~~

#### Asigna el perfil creado a usrpractica1 y comprueba su funcionamiento. Desbloquea posteriormente al usuario.
- Asiganción del perfil:
~~
SQL> ALTER USER usrpractica1 PROFILE passwordsegura;

Usuario modificado.

SQL>
~~

- Prueba de funcionamiento:
~~
oracle@OracleJessie:~$ rlwrap sqlplus

SQL*Plus: Release 12.1.0.2.0 Production on Mar Dic 3 12:32:38 2019

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Introduzca el nombre de usuario: usrpractica1
Introduzca la contraseña:
ERROR:
ORA-01017: invalid username/password; logon denied


Introduzca el nombre de usuario: usrpractica1
Introduzca la contraseña:
ERROR:
ORA-01017: invalid username/password; logon denied


Introduzca el nombre de usuario: usrpractica1
Introduzca la contraseña:
ERROR:
ORA-28000: the account is locked


SP2-0157: no se puede CONNECT con ORACLE después de 3 intentos, saliendo de SQL*Plus
oracle@OracleJessie:~$
~~

- Desbloqueo del usuario:
~~
SQL> ALTER USER usrpractica1 ACCOUNT unlock;

Usuario modificado.

SQL> SELECT account_status FROM dba_users WHERE username = 'USRPRACTICA1';

ACCOUNT_STATUS
_____________________
OPEN

SQL>
~~

#### Consulta qué usuarios existen en tu base de datos.
- Consulta:
~~
SQL> SELECT username FROM dba_users;

USERNAME
______________________________
PRUEBA1
SCOTT
ORACLE_OCM
ANGEL
OJVMSYS
SYSKM
XS$NULL
GSMCATUSER
MDDATA
SYSBACKUP
USER_PRIVS
DIP
SYSDG
JESUS
APEX_PUBLIC_USER
FRAN
SPATIAL_CSW_ADMIN_USR
BECARIO2
SPATIAL_WFS_ADMIN_USR
FERNANDO
GSMUSER
PRUEBAS
AUDSYS
BECARIO
USRPRACTICA1
FLOWS_FILES
DVF
MDSYS
ORDSYS
DBSNMP
WMSYS
APEX_040200
APPQOSSYS
GSMADMIN_INTERNAL
ORDDATA
CTXSYS
ANONYMOUS
XDB
ORDPLUGINS
DVSYS
SI_INFORMTN_SCHEMA
OLAPSYS
LBACSYS
OUTLN
SYSTEM
SYS

46 filas seleccionadas.

SQL>
~~

#### Elige un usuario concreto y consulta qué cuota tiene sobre cada uno de los tablespaces.
- Consulta:
~~
#----- Cuota de los distintos tablespaces a los que tiene acceso el usuario 'USRPRACTICA1' -----#
SQL> SELECT tablespace_name, max_bytes FROM dba_ts_quotas WHERE username = 'USRPRACTICA1';

TABLESPACE_NAME           |  MAX_BYTES
_________________________ | __________
USERS                     |    1048576

SQL>
~~

#### Elige un usuario concreto y muestra qué privilegios de sistema tiene asignados.
- Consulta:
~~
#----- Privilegios del sistema asignados al usuario 'SYSTEM' -----#
SQL> SELECT privilege, admin_option FROM dba_sys_privs WHERE grantee = 'SYSTEM';

PRIVILEGE                                | ADM
________________________________________ | ___
CREATE MATERIALIZED VIEW                 | NO
CREATE TABLE                             | NO
UNLIMITED TABLESPACE                     | NO
GLOBAL QUERY REWRITE                     | NO
MANAGE ANY QUEUE                         | YES
ENQUEUE ANY QUEUE                        | YES
SELECT ANY TABLE                         | NO
DEQUEUE ANY QUEUE                        | YES

8 filas seleccionadas.

SQL>
~~

#### Elige un usuario concreto y muestra qué privilegios sobre objetos tiene asignados.
- Consulta:
~~
#----- Privilegios sobre objeto asignados al usuario 'BECARIO' -----#
SQL> SELECT owner, table_name, privilege, type, grantable FROM dba_tab_privs WHERE grantee = 'BECARIO';

OWNER      | TABLE_NAME | PRIVILEGE  | TYPE       | GRA
__________ | __________ | __________ | __________ | ___
SCOTT      | EMP        | INSERT     | TABLE      | YES

SQL>
~~

#### Consulta qué roles existen en tu base de datos.
- Consulta:
~~
SQL> SELECT role FROM dba_roles;

ROLE
______________________________
CONNECT
RESOURCE
DBA
AUDIT_ADMIN
AUDIT_VIEWER
SELECT_CATALOG_ROLE
EXECUTE_CATALOG_ROLE
DELETE_CATALOG_ROLE
CAPTURE_ADMIN
EXP_FULL_DATABASE
IMP_FULL_DATABASE
CDB_DBA
PDB_DBA
RECOVERY_CATALOG_OWNER
LOGSTDBY_ADMINISTRATOR
DBFS_ROLE
GSMUSER_ROLE
AQ_ADMINISTRATOR_ROLE
AQ_USER_ROLE
DATAPUMP_EXP_FULL_DATABASE
DATAPUMP_IMP_FULL_DATABASE
ADM_PARALLEL_EXECUTE_TASK
PROVISIONER
XS_RESOURCE
XS_SESSION_ADMIN
XS_NAMESPACE_ADMIN
XS_CACHE_ADMIN
GATHER_SYSTEM_STATISTICS
OPTIMIZER_PROCESSING_RATE
GSMADMIN_ROLE
RECOVERY_CATALOG_USER
EM_EXPRESS_BASIC
EM_EXPRESS_ALL
SCHEDULER_ADMIN
HS_ADMIN_SELECT_ROLE
HS_ADMIN_EXECUTE_ROLE
HS_ADMIN_ROLE
GLOBAL_AQ_USER_ROLE
OEM_ADVISOR
OEM_MONITOR
XDBADMIN
XDB_SET_INVOKER
AUTHENTICATEDUSER
XDB_WEBSERVICES
XDB_WEBSERVICES_WITH_PUBLIC
XDB_WEBSERVICES_OVER_HTTP
GSM_POOLADMIN_ROLE

ROLE
______________________________
GDS_CATALOG_SELECT
WM_ADMIN_ROLE
JAVAUSERPRIV
JAVAIDPRIV
JAVASYSPRIV
JAVADEBUGPRIV
EJBCLIENT
JMXSERVER
JAVA_ADMIN
JAVA_DEPLOY
CTXAPP
ORDADMIN
OLAP_XS_ADMIN
OLAP_DBA
OLAP_USER
SPATIAL_WFS_ADMIN
WFS_USR_ROLE
SPATIAL_CSW_ADMIN
CSW_USR_ROLE
LBAC_DBA
APEX_ADMINISTRATOR_ROLE
APEX_GRANTS_FOR_NEW_USERS_ROLE
DV_SECANALYST
DV_MONITOR
DV_ADMIN
DV_OWNER
DV_ACCTMGR
DV_PUBLIC
DV_PATCH_ADMIN
DV_STREAMS_ADMIN
DV_GOLDENGATE_ADMIN
DV_XSTREAM_ADMIN
DV_GOLDENGATE_REDO_ACCESS
DV_AUDIT_CLEANUP
DV_DATAPUMP_NETWORK_LINK
DV_REALM_RESOURCE
DV_REALM_OWNER
ROLPRACTICA1

85 filas seleccionadas.

SQL>
~~

#### Elige un rol concreto y consulta qué usuarios lo tienen asignado.
- Consulta:
~~
#----- Usuarios que tienen asginado el rol 'CONNECT' -----#
SQL> SELECT grantee FROM dba_role_privs WHERE granted_role = 'CONNECT';

GRANTEE
______________________________
JESUS
APEX_040200
DVF
MDSYS
SPATIAL_WFS_ADMIN_USR
FRAN
SPATIAL_CSW_ADMIN_USR
GSMUSER_ROLE
GSMADMIN_ROLE
DVSYS
DV_ACCTMGR
SCOTT
GSM_POOLADMIN_ROLE
MDDATA
FERNANDO
GSMCATUSER
ANGEL
SYS

18 filas seleccionadas.

SQL>
~~

#### Elige un rol concreto y averigua si está compuesto por otros roles o no.
- Consulta:
~~
#----- Roles que componen al rol 'DBA' -----#
SQL> SELECT granted_role FROM role_role_privs WHERE role = 'DBA';

GRANTED_ROLE
___________________________________
OLAP_DBA
SCHEDULER_ADMIN
OPTIMIZER_PROCESSING_RATE
DATAPUMP_IMP_FULL_DATABASE
OLAP_XS_ADMIN
DELETE_CATALOG_ROLE
EXECUTE_CATALOG_ROLE
EM_EXPRESS_ALL
CAPTURE_ADMIN
WM_ADMIN_ROLE
EXP_FULL_DATABASE
SELECT_CATALOG_ROLE
JAVA_DEPLOY
GATHER_SYSTEM_STATISTICS
JAVA_ADMIN
XDB_SET_INVOKER
DATAPUMP_EXP_FULL_DATABASE
XDBADMIN
IMP_FULL_DATABASE

19 filas seleccionadas.

SQL>
~~

#### Consulta qué perfiles existen en tu base de datos.
- Consulta:
~~
SQL> SELECT DISTINCT profile FROM dba_profiles;

PROFILE
_________________________
ORA_STIG_PROFILE
NOPARESDECURRAR
DEFAULT

SQL>
~~

#### Elige un perfil y consulta qué límites se establecen en el mismo.
- Consulta:
~~
#----- Límites de recursos del perfil 'DEFAULT' -----#
SQL> SELECT resource_name, limit FROM dba_profiles WHERE profile = 'DEFAULT';

RESOURCE_NAME                       | LIMIT
___________________________________ | _________________________
COMPOSITE_LIMIT                     | UNLIMITED
SESSIONS_PER_USER                   | UNLIMITED
CPU_PER_SESSION                     | UNLIMITED
CPU_PER_CALL                        | UNLIMITED
LOGICAL_READS_PER_SESSION           | UNLIMITED
LOGICAL_READS_PER_CALL              | UNLIMITED
IDLE_TIME                           | UNLIMITED
CONNECT_TIME                        | UNLIMITED
PRIVATE_SGA                         | UNLIMITED
FAILED_LOGIN_ATTEMPTS               | 10
PASSWORD_LIFE_TIME                  | 180
PASSWORD_REUSE_TIME                 | UNLIMITED
PASSWORD_REUSE_MAX                  | UNLIMITED
PASSWORD_VERIFY_FUNCTION            | NULL
PASSWORD_LOCK_TIME                  | 1
PASSWORD_GRACE_TIME                 | 7

16 filas seleccionadas.

SQL>
~~

#### Muestra los nombres de los usuarios que tienen limitado el número de sesiones concurrentes.
- Consulta:
~~
SELECT username
FROM dba_users
WHERE profile IN (SELECT profile
                  FROM dba_profiles                                                                                                                                                       WHERE resource_name = 'SESSIONS_PER_USER');

USERNAME
_________________________
APEX_PUBLIC_USER
WMSYS
SI_INFORMTN_SCHEMA
USRPRACTICA1
OUTLN
SYSBACKUP
FLOWS_FILES
OLAPSYS
PRUEBAS
ORDPLUGINS
USER_PRIVS
GSMADMIN_INTERNAL
SYSTEM
GSMUSER
FERNANDO
SPATIAL_WFS_ADMIN_USR
XS$NULL
ANGEL
APPQOSSYS
SYS
XDB
FRAN
ANONYMOUS
MDDATA
OJVMSYS
DVF
AUDSYS
JESUS
SYSDG
CTXSYS
GSMCATUSER
SYSKM
APEX_040200
ORDSYS
PRUEBA1
BECARIO
DVSYS
SPATIAL_CSW_ADMIN_USR
LBACSYS
DBSNMP
MDSYS
BECARIO2
DIP
ORDDATA
ORACLE_OCM
SCOTT

46 filas seleccionadas.

SQL>
~~

#### Realiza un procedimiento que reciba un nombre de usuario y un privilegio de sistema y nos muestre el mensaje 'SI, DIRECTO' si el usuario tiene ese privilegio concedido directamente, 'SI, POR ROL' si el usuario tiene ese privilegio en alguno de los roles que tiene concedidos y un 'NO' si el usuario no tiene dicho privilegio.

#### Realiza un procedimiento llamado MostrarNumSesiones que reciba un nombre de usuario y muestre el número de sesiones concurrentes que puede tener abiertas como máximo y las que tiene abiertas realmente.
- Código:
~~
CREATE OR REPLACE PROCEDURE MostrarNumSesiones (p_usuario dba_users.username%type)
AS
  v_maxesiones dba_profiles.limit%type;
  v_sesionesactivas NUMBER(3);

BEGIN
  -- Obtiene el número máximo de sesiones activas que puede tener el usuario indicado.
  SELECT limit INTO v_maxesiones
  FROM dba_profiles
  WHERE profile = (SELECT profile
             FROM dba_users
             WHERE username = UPPER(p_usuario))
  AND resource_name = 'SESSIONS_PER_USER';

  -- Obtiene el número de sesiones activas que tiene el usuario indicado actualmente.
  SELECT count(username) INTO v_sesionesactivas
  FROM v$session
  WHERE username = UPPER(p_usuario)
  GROUP BY username;

  DBMS_OUTPUT.PUT_LINE('Número Máximo de sesiones: '||v_maxesiones);
  DBMS_OUTPUT.PUT_LINE('Número de sesiones activas: '||v_sesionesactivas);

END MostrarNumSesiones;
/
~~
