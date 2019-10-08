### Configuración previa a la instalación de Oracle 12c.
- Creación de grupos y usuarios:
~~~
root@OracleJessie:~# addgroup --system oinstall
root@OracleJessie:~# addgroup --system dba
root@OracleJessie:~# adduser --system --ingroup oinstall -shell /bin/bash oracle
root@OracleJessie:~# adduser oracle dba
~~~

- Creación de directorios y asignación de permisos:
~~~
root@OracleJessie:~# mkdir -p /opt/oracle/product/12.1.0.2
root@OracleJessie:~# mkdir -p /opt/oraInventory
root@OracleJessie:~# chown -R oracle:dba /opt/ora*
~~~

- Creación de enlaces simbólicos:
~~~
root@OracleJessie:~# ln -s /usr/bin/awk /bin/awk
root@OracleJessie:~# ln -s /usr/bin/basename /bin/basename
root@OracleJessie:~# ln -s /usr/bin/rpm /bin/rpm
root@OracleJessie:~# ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
~~~

- Averiguar el valor de `kernel.shmmax`:
~~~
root@OracleJessie:~# free -b | grep -Ei 'mem:' | awk '{print $2}'
4156006400
~~~

- Averiguar el valor de `kernel.shmmin`:
~~~
root@OracleJessie:~# getconf PAGE_SIZE
4096
~~~

- Calcular el valor `kernel.shmall`:
~~~
4156006400 (kernel.shmmax) / 4096 (kernel.shmmin) = 1014660 (kernel.shmall)
~~~

- Introducir los parámetros calculados en el fichero de configuración (`/etc/sysctl.d/local-oracle.conf`):
~~~
root@OracleJessie:~# echo ”””
fs.file-max = 65536
fs.aio-max-nr = 1048576
kernel.sem = 250 32000 100 128
kernel.shmmax = 4156006400
kernel.shmall = 1014660
kernel.shmmni = 4096
net.ipv4.ip_local_port_range = 1024 65000
#GID del grupo dba
vm.hugetlb_shm_group = 123
vm.nr_hugepages = 64
""" > /etc/sysctl.d/local-oracle.conf
root@OracleJessie:~# sysctl -p 
~~~

- Añadir las variables de entorno necesarias (`/etc/bash.bashrc`):
~~~
root@OracleJessie:~# ”””
export ORACLE_HOSTNAME=localhost
export ORACLE_OWNER=oracle
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/12.1.0.2/dbhome_1
export ORACLE_UNQNAME=oraname
export ORACLE_SID=orasid
export PATH=$PATH:/opt/oracle/product/12.1.0.2/dbhome_1/bin
export LD_LIBRARY_PATH=/opt/oracle/product/12.1.0.2/dbhome_1/lib
export NLS_LANG='SPANISH_SPAIN.AL32UTF8'
””” >> /etc/bash.bashrc
root@OracleJessie:~# source /etc/bash.bashrc
~~~

- Instalación de dependencias:
~~~
root@OracleJessie:~# apt -y install build-essential binutils libcap-dev gcc g++ libc6-dev ksh libaio-dev make libxi-dev libxtst-dev libxau-dev libxcb1-dev sysstat rpm xauth xorg unzip
~~~

- *Nota:* Configurar el idioma del sistema en `es_ES.UTF-8`.

### Instalación de Oracle 12c.
- Ejecución del instalador:
~~~
oracle@OracleJessie:~$ database/runInstaller -IgnoreSysPreReqs -ignorePrereq
~~~

- Pasos de la instalación:
	- Paso 1. "Crear y configurar base de datos".
	- Paso 2. "Clase Servidor".
	- Paso 3. "Instalación de base de datos de instancia única".
	- Paso 4. "Instalación avanzada".
	- Paso 5. Seleccionar idiomas.
	- Paso 6. Enterprise Edition.
	- Paso 7. Configuración automática debido a la configuración realizada previamente.
	- Paso 8. Configuración por defecto.
	- Paso 9. "Uso General".
	- Paso 10. Valores por defecto.
	- Paso 11. "Juego de caracteres/Unicode" y marcar opción en "Esquemas de Ejemplo"
	- Paso 12. Valores por defecto.
	- Paso 13. No se selecciona nada.
	- Paso 14. No se selecciona nada.
	- Paso 15. Establecer contraseña a los administradores.
	- Paso 16. Valores por defecto.
	- Paso 17. Instalar
	- Paso 18. Ejecución de los scripts necesarios:
~~~
root@OracleJessie:~# source /opt/oraInventory/orainstRoot.sh
root@OracleJessie:~# source /opt/oracle/product/12.1.0/dbhome_1/root.sh
~~~

- Inicio del listener:
~~~
oracle@OracleJessie:~$ lsnrctl start
~~~

- Conexión e inicio de la base de datos:
~~~
oracle@OracleJessie:~$ sqlplus SYSTEM/(PASS) as sysdba
SQL> startup
~~~

- Modificación de la variable `_ORACLE_SCRIPT` para permitir el uso de la base de datos;
~~~
SQL> alter session set "_ORACLE_SCRIPT"=true; 
~~~

### Instalación SQLPlus 12.1.
- Instalación de `alien`:
~~~
vagrant@ClienteOracle:~$ sudo apt install alien
~~~

- Reempaquetado a `.deb`:
~~~
vagrant@ClienteOracle:~$ sudo alien --to-deb --scripts oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
vagrant@ClienteOracle:~$ sudo alien --to-deb --scripts oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
~~~

- Instalación de los paquetes:
~~~
vagrant@ClienteOracle:~$ sudo dpkg -i oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
vagrant@ClienteOracle:~$ sudo dpkg -i oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
~~~

- Modificación de la variable de entorno necesaria:
~~~
root@ClienteOracle:~# echo "export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib/libsqlplus.so" >> /etc/bash.bashrc
~~~

- Prueba de funcionamiento:
~~~
vagrant@ClienteOracle:~$ sqlplus64 {usuario}/{contraseña}//{IP}:1521/orcl
~~~