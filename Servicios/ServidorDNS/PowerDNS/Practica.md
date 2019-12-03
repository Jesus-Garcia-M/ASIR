# Práctica PowerDNS.
### PowerDNS Recursivo.
- Instalación:
~~~
root@jesus:~# apt install pdns-recursor
~~~

- Configuración de `forward` (`/etc/powerdns/recursor.conf`):
~~~
# Forward de cualquier dominio (".") a la máquina "192.168.202.2".
forward-zones=.=192.168.202.2

# Escuchar peticiones en el puerto 53.
local-port=53

# Escuchar peticiones en la dirección IP "10.0.0.100".
local-address=10.0.0.100
~~~

- Pruebas de funcionamiento:
~~~
vagrant@clientepowerdns:~$ dig www.google.com

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12099
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.google.com.			IN	A

;; ANSWER SECTION:
www.google.com.		175	IN	A	216.58.211.36

;; Query time: 4 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Tue Dec 03 07:46:25 GMT 2019
;; MSG SIZE  rcvd: 59

vagrant@clientepowerdns:~$
~~~

### PowerDNS Autoritativo.
- Instalación:
~~~
root@jesus:~# apt install pdns-server
~~~

- Creación de base de datos y usuario:
~~~
MariaDB [(none)]> CREATE DATABASE powerDNS;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL ON powerDNS.* TO pdns IDENTIFIED BY 'pdns';
Query OK, 0 rows affected (0.003 sec)

MariaDB [(none)]> 
~~~

- Configuración de `PowerDNS` (`/`):
~~~
# Escuchar peticiones en el puerto 53.
local-port=53

# Configuración de acceso a MariaDB.
launch=gmysql
gmysql-host=127.0.0.1
gmysql-user=pdns
gmysql-dbname=powerDNS
gmysql-password=pdns

# Escuchar peticiones en la dirección IP "10.0.0.100".
local-address=10.0.0.100
~~~

- Creación de la estructura de tablas:
~~~

~~~