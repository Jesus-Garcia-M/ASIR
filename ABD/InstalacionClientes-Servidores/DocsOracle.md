#### Instalación SQLPlus 12.1.
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