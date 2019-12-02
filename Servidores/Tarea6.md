### Instalación y configuración inicial.
- Instalación del servicio:
~~~
debian@croqueta:~$ sudo apt install bind9
~~~

- Configuración de zonas (`/etc/bind/named.conf.local`):
~~~
// Creación de las ACL para las vistas.
acl interna { 10.0.0.0/24; localhost; };
acl externa { 172.22.0.0/16; 192.168.202.2; };

// Creación de la vista para la red interna.
view interna {
  match-clients { interna; };
  allow-recursion { any; };
  allow-query { 10.0.0.0/24; localhost; };

  zone "jesus.gonzalonazareno.org" {
    type master;
    file "db.interna.jesus.gonzalonazareno.org";
  };

  zone "0.0.10.in-addr.arpa" {
    type master;
    file "db.0.0.10";
  };

include "/etc/bind/zones.rfc1918";
include "/etc/bind/named.conf.default-zones";
};

// Creación de la vista para el exterior.
view externa {
  match-clients { externa; };
  allow-recursion { 192.168.202.2; };
  allow-query { 172.22.0.0/16; 192.168.202.2; };

  zone "jesus.gonzalonazareno.org" {
    type master;
    allow-query { any; };
    file "db.externa.jesus.gonzalonazareno.org";
  };

  zone "22.172.in-addr.arpa" {
    type master;
    file "db.22.172";
  };

include "/etc/bind/zones.rfc1918";
include "/etc/bind/named.conf.default-zones";
};
~~~

- Modificación del fichero `/etc/bind/named.conf`:
~~~
#----- Comentar la línea a continuación -----#
//include "/etc/bind/named.conf.default-zones";
~~~

- Definición de la zona directa interna (`/var/cache/bind/db.interna.jesus.gonzalonazareno.org`):
~~~
$TTL	86400
@	IN	SOA	croqueta.jesus.gonzalonazareno.org. root.jesus.gonzalonazareno.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	        croqueta.jesus.gonzalonazareno.org.

$ORIGIN jesus.gonzalonazareno.org.
; Máquinas.
croqueta    IN    A    10.0.0.6
tortilla    IN    A    10.0.0.10
salmorejo   IN    A    10.0.0.4
; Alias.
mariadb     IN    CNAME    tortilla
www         IN    CNAME    salmorejo
cloud       IN    CNAME    salmorejo
~~~

- Definición de la zona directa externa (`/var/cache/bind/db.externa.jesus.gonzalonazareno.org`):
~~~
$TTL	86400
@	IN	SOA	croqueta.jesus.gonzalonazareno.org. root.jesus.gonzalonazareno.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	        croqueta.jesus.gonzalonazareno.org.

$ORIGIN jesus.gonzalonazareno.org.
; Máquinas.
croqueta    IN    A    172.22.200.100
tortilla    IN    A    172.22.200.36
salmorejo   IN    A    172.22.200.82
; Alias.
www         IN    CNAME    salmorejo
cloud       IN    CNAME    salmorejo
~~~

- Definición de la zona inversa interna (`/var/cache/bind/db.0.0.10`):
~~~
$TTL	86400
@	IN	SOA	croqueta.jesus.gonzalonazareno.org. root.jesus.gonzalonazareno.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	        croqueta.jesus.gonzalonazareno.org.

$ORIGIN 0.0.10.in-addr.arpa.
; Máquinas.
6    IN    PTR    croqueta.jesus.gonzalonazareno.org.
10   IN    PTR    tortilla.jesus.gonzalonazareno.org.
4    IN    PTR    salmorejo.jesus.gonzalonazareno.org.
~~~

- Definición de la zona inversa externa (`/var/cache/bind/db.22.172`):
~~~
$TTL	86400
@	IN	SOA	croqueta.jesus.gonzalonazareno.org. root.jesus.gonzalonazareno.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	        croqueta.jesus.gonzalonazareno.org.

$ORIGIN 200.22.172.in-addr.arpa.
; Máquinas.
100    IN    PTR    croqueta.jesus.gonzalonazareno.org.
36     IN    PTR    tortilla.jesus.gonzalonazareno.org.
82     IN    PTR    salmorejo.jesus.gonzalonazareno.org.
~~~

- Pruebas de funcionamiento:
~~~
#----- Petición del servidor NS de la zona jesus.gonzalonazareno.org -----#
jesus@jesus:~$ dig @192.168.202.2 ns jesus.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.202.2 ns jesus.gonzalonazareno.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43732
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 0cc9ae2a0be587d49559c0ac5ddbb8ce448143897b48efec (good)
;; QUESTION SECTION:
;jesus.gonzalonazareno.org.	IN	NS

;; ANSWER SECTION:
jesus.gonzalonazareno.org. 86400 IN	NS	croqueta.jesus.gonzalonazareno.org.

;; Query time: 6 msec
;; SERVER: 192.168.202.2#53(192.168.202.2)
;; WHEN: lun nov 25 12:19:42 CET 2019
;; MSG SIZE  rcvd: 105

jesus@jesus:~$ 

#----- Resolución de una máquin -----#
jesus@jesus:~$ dig @192.168.202.2 salmorejo.jesus.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.202.2 salmorejo.jesus.gonzalonazareno.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47774
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 5283e5aee14393d732b7e2a95ddbb99701143d7dfbe3b4a7 (good)
;; QUESTION SECTION:
;salmorejo.jesus.gonzalonazareno.org. IN	A

;; ANSWER SECTION:
salmorejo.jesus.gonzalonazareno.org. 84985 IN A	172.22.200.82

;; AUTHORITY SECTION:
jesus.gonzalonazareno.org. 86199 IN	NS	croqueta.jesus.gonzalonazareno.org.

;; Query time: 2 msec
;; SERVER: 192.168.202.2#53(192.168.202.2)
;; WHEN: lun nov 25 12:23:03 CET 2019
;; MSG SIZE  rcvd: 131

jesus@jesus:~$ 


#----- Resolución de cloud.jesus.gonzalonazareno.org -----#
jesus@jesus:~$ dig @192.168.202.2 cloud.jesus.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.202.2 cloud.jesus.gonzalonazareno.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46365
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: fef1d9a449b8b6c4aa2281565ddbb919672c9b6e5b31259c (good)
;; QUESTION SECTION:
;cloud.jesus.gonzalonazareno.org. IN	A

;; ANSWER SECTION:
cloud.jesus.gonzalonazareno.org. 85321 IN CNAME	salmorejo.jesus.gonzalonazareno.org.
salmorejo.jesus.gonzalonazareno.org. 85111 IN A	172.22.200.82

;; AUTHORITY SECTION:
jesus.gonzalonazareno.org. 86325 IN	NS	croqueta.jesus.gonzalonazareno.org.

;; Query time: 2 msec
;; SERVER: 192.168.202.2#53(192.168.202.2)
;; WHEN: lun nov 25 12:20:57 CET 2019
;; MSG SIZE  rcvd: 151

jesus@jesus:~$

#----- Resolución inversa de una dirección IP de la red interna -----#
jesus@jesus:~$ dig @172.22.200.100 -x 172.22.200.82

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @172.22.200.100 -x 172.22.200.82
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 29503
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 35c14eb98d006b5830013a8e5ddbba3e4453f9cdefc01dcd (good)
;; QUESTION SECTION:
;82.200.22.172.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
82.200.22.172.in-addr.arpa. 86400 IN	PTR	salmorejo.jesus.gonzalonazareno.org.

;; AUTHORITY SECTION:
22.172.in-addr.arpa.	86400	IN	NS	croqueta.jesus.gonzalonazareno.org.

;; ADDITIONAL SECTION:
croqueta.jesus.gonzalonazareno.org. 86400 IN A	172.22.200.100

;; Query time: 5 msec
;; SERVER: 172.22.200.100#53(172.22.200.100)
;; WHEN: lun nov 25 12:25:50 CET 2019
;; MSG SIZE  rcvd: 171

jesus@jesus:~$ 

#----- Resolución inversa de una dirección IP de la red externa -----#
debian@croqueta:~$ dig @127.0.0.1 -x 10.0.0.10

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @127.0.0.1 -x 10.0.0.10
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 63739
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 7fab4e4d38bf286814133b645ddbba73afdbc01f364aecbe (good)
;; QUESTION SECTION:
;10.0.0.10.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
10.0.0.10.in-addr.arpa.	86400	IN	PTR	tortilla.jesus.gonzalonazareno.org.

;; AUTHORITY SECTION:
0.0.10.in-addr.arpa.	86400	IN	NS	croqueta.jesus.gonzalonazareno.org.

;; ADDITIONAL SECTION:
croqueta.jesus.gonzalonazareno.org. 86400 IN A	10.0.0.6

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Mon Nov 25 11:26:43 UTC 2019
;; MSG SIZE  rcvd: 166

debian@croqueta:~$
~~~