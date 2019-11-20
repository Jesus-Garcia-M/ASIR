# Práctica bind9.
### Instalación y configuración inicial.
- Instalación del servicio:
~~~
root@jesus:~# apt install bind9
~~~

- Configuración de zonas (`/etc/bind/named.conf.local`):
~~~
etc/bind/named.conf.local

// Zona iesgn.org
zone "iesgn.org" {
  type master;
  file "db.iesgn.org";
};

// Zona inversa iesgn.org
zone "0.0.10.in-addr.arpa" {
  type master;
  file "db.0.0.10";
};

// Zona inversa IPv6 iesgn.org
zone "f.f.7.2.0.0.a.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.e.f.ip6.arpa" {
  type master;
  file "db.f.f.7.2.0.0.a.0.0.0.0.0.8.e.f";
};
~~~

- Configuración de la zona `iesgn.org` (`/var/cache/bind/db.iesgn.org`):
~~~
$TTL	86400
@	IN	SOA	jesus.iesgn.org. root.iesgn.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	        jesus.iesgn.org.
@	IN	MX	10	correo.iesgn.org.

$ORIGIN iesgn.org.
; Máquinas IPv4:
jesus          IN    A    10.0.0.100
clientebind9   IN    A    10.0.0.4
cliente2bind9  IN    A    10.0.0.5
correo         IN    A    10.0.0.200
ftp            IN    A    10.0.0.201
web            IN    A    10.0.0.202
; Máquinas IPv6:
jesus          IN    AAAA    fe80::a00:27ff:fe98:e04c
clientebind9   IN    AAAA    fe80::a00:27ff:feea:a17a
cliente2bind9  IN    AAAA    fe80::a00:27ff:fe32:47c3
correo         IN    AAAA    fe80::a00:27ff:fee2:ae2e
ftp            IN    AAAA    fe80::a00:27ff:fe0a:1c12
web            IN    AAAA    fe80::a00:27ff:fe76:ee4
; Alias:
www            IN    CNAME    web
departamentos  IN    CNAME    web
~~~

- Configuración de la zona inversa IPv4 (`/var/cache/bind/db.0.0.10`):
~~~
$TTL	86400
@	IN	SOA	jesus.iesgn.org. root.iesgn.org. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	jesus.iesgn.org.


$ORIGIN 0.0.10.in-addr.arpa.
100  IN    PTR    jesus.iesgn.org.
4    IN    PTR    clientebind9.iesgn.org.
5    IN    PTR    cliente2bind9.iesgn.org.
200  IN    PTR    correo.iesgn.org.
201  IN    PTR    ftp.iesgn.org.
202  IN    PTR    web.iesgn.org.
~~~

- Configuración de la zona inversa IPv6 (`/var/cache/bind/db.f.f.7.2.0.0.a.0.0.0.0.0.8.e.f`):
~~~
$TTL    86400
@       IN      SOA     jesus.iesgn.org. root.iesgn.org. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      jesus.iesgn.org.

$ORIGIN 0.0.0.0.0.0.0.0.0.0.0.0.0.8.e.f.ip6.arpa.
c.4.0.e.8.9.e.f.f.f.7.2.0.0.a    IN    PTR    jesus.iesgn.org.
a.7.1.a.a.e.e.f.f.f.7.2.0.0.a    IN    PTR    clientebind9.iesgn.org.
3.c.7.4.2.3.e.f.f.f.7.2.0.0.a    IN    PTR    cliente2bind9.iesgn.org.
e.2.e.a.2.e.e.f.f.f.7.2.0.0.a    IN    PTR    correo.iesgn.org.
2.1.c.1.a.0.e.f.f.f.7.2.0.0.a    IN    PTR    ftp.iesgn.org.
4.e.e.6.7.e.f.f.f.7.2.0.0.a      IN    PTR    web.iesgn.org.
~~~

- Pruebas de funcionamiento:
~~~
#----- Resolución IPv4 de jesus.iesgn.org -----#
vagrant@clientebind9:~$ dig A jesus.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> A jesus.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16651
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d176be41c232d4846231be5a5dcbbc2fa0b833dad21a2b5e (good)
;; QUESTION SECTION:
;jesus.iesgn.org.		IN	A

;; ANSWER SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:17:51 GMT 2019
;; MSG SIZE  rcvd: 130

vagrant@clientebind9:~$ 


#----- Resolución IPv6 de jesus.iesgn.org -----#
vagrant@clientebind9:~$ dig AAAA jesus.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> AAAA jesus.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41674
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: c9e231883da00b12b9f483505dcbbd2c4b214abcb852a07e (good)
;; QUESTION SECTION:
;jesus.iesgn.org.		IN	AAAA

;; ANSWER SECTION:
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100

;; Query time: 1 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:22:04 GMT 2019
;; MSG SIZE  rcvd: 130

vagrant@clientebind9:~$ 


#----- Resolución IPv4 de www.iesgn.org -----#
vagrant@clientebind9:~$ dig A www.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> A www.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15632
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: b629f1a4e2593ca686fef9355dcbbd45083979c6c16b7cc6 (good)
;; QUESTION SECTION:
;www.iesgn.org.			IN	A

;; ANSWER SECTION:
www.iesgn.org.		86400	IN	CNAME	web.iesgn.org.
web.iesgn.org.		86400	IN	A	10.0.0.202

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:22:29 GMT 2019
;; MSG SIZE  rcvd: 168

vagrant@clientebind9:~$ 


#----- Resolución IPv4 de ftp.iesgn.org -----#
vagrant@clientebind9:~$ dig A ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> A ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32964
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 5609d4e674380ab4d4aa3a095dcbbd763854ef1a17bcdf45 (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		86400	IN	A	10.0.0.201

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:23:18 GMT 2019
;; MSG SIZE  rcvd: 150

vagrant@clientebind9:~$ 


#----- Resolución IPv4 del servidor con autoridad de la zona iesgn.org -----#
vagrant@clientebind9:~$ dig ns iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ns iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61147
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: a5ef253c8ed347d6e5fcfc985dcbbdba911f11c40622f688 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	NS

;; ANSWER SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:24:26 GMT 2019
;; MSG SIZE  rcvd: 130

vagrant@clientebind9:~$ 


#----- Resolución IPv4 del servidor de correo de la zona iesgn.org -----#
vagrant@clientebind9:~$ dig mx iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> mx iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41755
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 5

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 43b5cae46fd8fc0a911c53335dcbbdc9a730c94795a9adc4 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	MX

;; ANSWER SECTION:
iesgn.org.		86400	IN	MX	10 correo.iesgn.org.

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
correo.iesgn.org.	86400	IN	A	10.0.0.200
jesus.iesgn.org.	86400	IN	A	10.0.0.100
correo.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fee2:ae2e
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:24:41 GMT 2019
;; MSG SIZE  rcvd: 197

vagrant@clientebind9:~$ 


#----- Resolución de www.josedomingo.org -----#
vagrant@clientebind9:~$ dig www.josedomingo.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49082
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 5, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d276bd22ab864b81c71702155dcbbdd8d0528fe5012df3cb (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	361	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 361	IN	A	137.74.161.90

;; AUTHORITY SECTION:
josedomingo.org.	85860	IN	NS	ns5.cdmondns-01.com.
josedomingo.org.	85860	IN	NS	ns2.cdmon.net.
josedomingo.org.	85860	IN	NS	ns4.cdmondns-01.org.
josedomingo.org.	85860	IN	NS	ns1.cdmon.net.
josedomingo.org.	85860	IN	NS	ns3.cdmon.net.

;; ADDITIONAL SECTION:
ns1.cdmon.net.		172261	IN	A	35.189.106.232
ns2.cdmon.net.		172261	IN	A	35.195.57.29
ns3.cdmon.net.		172261	IN	A	35.157.47.125
ns4.cdmondns-01.org.	85860	IN	A	52.58.66.183
ns5.cdmondns-01.com.	172261	IN	A	52.59.146.62

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:24:56 GMT 2019
;; MSG SIZE  rcvd: 322

vagrant@clientebind9:~$ 


#----- Resolución IPv4 inversa de 10.0.0.201 -----#
vagrant@clientebind9:~$ dig -x 10.0.0.201

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> -x 10.0.0.201
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50403
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 0b2faa9f56f253d6d915cc705dcbbe0022fafc54525f1fed (good)
;; QUESTION SECTION:
;201.0.0.10.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
201.0.0.10.in-addr.arpa. 86400	IN	PTR	ftp.iesgn.org.

;; AUTHORITY SECTION:
0.0.10.in-addr.arpa.	86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 13 08:25:36 GMT 2019
;; MSG SIZE  rcvd: 171

vagrant@clientebind9:~$ 
~~~

### Configuración master/slave.
- Configuración de transferencia de la zona (`/etc/bind/named.conf.options`):
~~~
options {
...
        allow-transfer { none; };
...
};
~~~

- Configuración de transferencia de la zona en el master (`/etc/bind/named.conf.local`):
~~~
etc/bind/named.conf.local

// Zona iesgn.org
zone "iesgn.org" {
  type master;
  file "db.iesgn.org";
  allow-transfer { 10.0.0.101; };
  notify yes;
};

// Zona inversa IPv4 iesgn.org
zone "0.0.10.in-addr.arpa" {
  type master;
  file "db.0.0.10";
  allow-transfer { 10.0.0.101; };
  notify yes;
};
~~~

- Configuración de la zona en el slave (`etc/bind/named.conf.local`):
~~~
etc/bind/named.conf.local

// Zona iesgn.org
zone "iesgn.org" {
  type slave;   
  file "db.iesgn.org";
  masters { 10.0.0.100; };
};

// Zona inversa iesgn.org
zone "0.0.10.in-addr.arpa" {
  type slave;
  file "db.0.0.10";
  masters { 10.0.0.100; };
};
~~~

- Modificación de la zona `iesgn.org` (`/var/cache/bind/db.iesgn.org`):
~~~
...
@       IN      NS              jesus-slave.iesgn.org.
...
jesus-slave    IN    A    10.0.0.101
...
~~~

- Modificación de la zona inversa (`/var/cache/bind/db.0.0.10`):
~~~
...
@       IN      NS      jesus-slave.iesgn.org.
...
101  IN    PTR    jesus-slave.iesgn.org.
...
~~~

- Comprobación de errores:
~~~
#----- Comprobación de las zonas del master -----#
root@jesus:~# named-checkzone iesgn.org /var/cache/bind/db.iesgn.org
zone iesgn.org/IN: loaded serial 1
OK
root@jesus:~# named-checkzone 0.0.10.in-addr.arpa /var/cache/bind/db.0.0.10
zone 0.0.10.in-addr.arpa/IN: loaded serial 1
OK
root@jesus:~# 

#----- Comprobación del fichero named.conf en el master -----#
root@jesus:~# named-checkconf
root@jesus:~# 


#----- Comprobación del fichero named.conf en el slave -----#
root@jesus-slave:~# named-checkconf
root@jesus-slave:~#
~~~

- Comprobación de la transferencia de la zona:
~~~
root@jesus-slave:~# tail /var/log/syslog
Nov 19 08:02:16 bind9-slave named[1958]: transfer of 'iesgn.org/IN' from 10.0.0.100#53: Transfer status: success
Nov 19 08:02:16 bind9-slave named[1958]: transfer of 'iesgn.org/IN' from 10.0.0.100#53: Transfer completed: 1 messages, 18 records, 492 bytes, 0.001 secs (492000 bytes/sec)
Nov 19 08:02:17 bind9-slave named[1958]: zone 0.0.10.in-addr.arpa/IN: Transfer started.
Nov 19 08:02:17 bind9-slave named[1958]: transfer of '0.0.10.in-addr.arpa/IN' from 10.0.0.100#53: connected using 10.0.0.101#43695
Nov 19 08:02:17 bind9-slave named[1958]: zone 0.0.10.in-addr.arpa/IN: transferred serial 1
Nov 19 08:02:17 bind9-slave named[1958]: transfer of '0.0.10.in-addr.arpa/IN' from 10.0.0.100#53: Transfer status: success
Nov 19 08:02:17 bind9-slave named[1958]: transfer of '0.0.10.in-addr.arpa/IN' from 10.0.0.100#53: Transfer completed: 1 messages, 9 records, 287 bytes, 0.001 secs (287000 bytes/sec)
Nov 19 08:02:24 bind9-slave named[1958]: managed-keys-zone: Key 20326 for zone . acceptance timer complete: key now trusted
Nov 19 08:02:24 bind9-slave named[1958]: resolver priming query complete
root@jesus-slave:~#
~~~

- Configuración del cliente (`/etc/resolv.conf`):
~~~
nameserver 10.0.0.100
nameserver 10.0.0.101
~~~

- Prueba de funcionamiento de ambos servidores:
~~~
#----- Petición al servidor master -----#
vagrant@clientebind9:~$ dig +norec @10.0.0.100 iesgn.org soa

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> +norec @10.0.0.100 iesgn.org soa
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3602
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 5

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 03c9b42f5f0fed34705be2cc5dd3a7275dc4f186b83ae66b (good)
;; QUESTION SECTION:
;iesgn.org.			IN	SOA

;; ANSWER SECTION:
iesgn.org.		86400	IN	SOA	jesus.iesgn.org. root.iesgn.org. 1 604800 86400 2419200 86400

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus-slave.iesgn.org.
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus-slave.iesgn.org.	86400	IN	A	10.0.0.101
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c
jesus-slave.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe94:cd7

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Tue Nov 19 08:26:15 GMT 2019
;; MSG SIZE  rcvd: 241

vagrant@clientebind9:~$

#----- Petición al servidor slave -----#
vagrant@clientebind9:~$ dig +norec @10.0.0.101 iesgn.org soa

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> +norec @10.0.0.101 iesgn.org soa
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62437
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: c46feac8ca1924b01871dfa05dd3a767b4bef576255f5386 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	SOA

;; ANSWER SECTION:
iesgn.org.		86400	IN	SOA	jesus.iesgn.org. root.iesgn.org. 1 604800 86400 2419200 86400

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.101#53(10.0.0.101)
;; WHEN: Tue Nov 19 08:27:19 GMT 2019
;; MSG SIZE  rcvd: 171

vagrant@clientebind9:~$ 
~~~

- Prueba de funcionamiento de la transferencia de la zona:
~~~
#----- Petición de transferencia desde el cliente -----#
vagrant@clientebind9:~$ dig @10.0.0.100 iesgn.org axfr

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @10.0.0.100 iesgn.org axfr
; (1 server found)
;; global options: +cmd
; Transfer failed.
vagrant@clientebind9:~$ 

#----- Petición de transferencia desde el servidor slave -----#
vagrant@jesus-slave:~$ dig @10.0.0.100 iesgn.org axfr

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @10.0.0.100 iesgn.org axfr
; (1 server found)
;; global options: +cmd
iesgn.org.		86400	IN	SOA	jesus.iesgn.org. root.iesgn.org. 1 604800 86400 2419200 86400
iesgn.org.		86400	IN	NS	jesus.iesgn.org.
iesgn.org.		86400	IN	NS	jesus-slave.iesgn.org.
iesgn.org.		86400	IN	MX	10 correo.iesgn.org.
cliente2bind9.iesgn.org. 86400	IN	AAAA	fe80::a00:27ff:fe32:47c3
cliente2bind9.iesgn.org. 86400	IN	A	10.0.0.5
clientebind9.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:feea:a17a
clientebind9.iesgn.org.	86400	IN	A	10.0.0.4
correo.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fee2:ae2e
correo.iesgn.org.	86400	IN	A	10.0.0.200
departamentos.iesgn.org. 86400	IN	CNAME	web.iesgn.org.
ftp.iesgn.org.		86400	IN	AAAA	fe80::a00:27ff:fe0a:1c12
ftp.iesgn.org.		86400	IN	A	10.0.0.201
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus-slave.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe94:cd7
jesus-slave.iesgn.org.	86400	IN	A	10.0.0.101
web.iesgn.org.		86400	IN	AAAA	fe80::a00:27ff:fe76:ee4
web.iesgn.org.		86400	IN	A	10.0.0.202
www.iesgn.org.		86400	IN	CNAME	web.iesgn.org.
iesgn.org.		86400	IN	SOA	jesus.iesgn.org. root.iesgn.org. 1 604800 86400 2419200 86400
;; Query time: 1 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Tue Nov 19 08:29:26 GMT 2019
;; XFR size: 21 records (messages 1, bytes 601)

vagrant@jesus-slave:~$ 
~~~

- Prueba de funcionamiento de la configuración `master/slave`:
~~~
#----- Resolución con ambos servidores operativos -----#
vagrant@clientebind9:~$ dig ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14630
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 5

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d1420d1f50d9ae861be038305dd3a94a07ba10aa4e501f72 (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		86400	IN	A	10.0.0.201

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.
iesgn.org.		86400	IN	NS	jesus-slave.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus-slave.iesgn.org.	86400	IN	A	10.0.0.101
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c
jesus-slave.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe94:cd7

;; Query time: 0 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Tue Nov 19 08:35:22 GMT 2019
;; MSG SIZE  rcvd: 220

vagrant@clientebind9:~$

#----- Apagado del servidor master -----#
root@jesus:~# systemctl stop bind9
root@jesus:~#

#----- Resolución con únicamente el servidor slave operativo -----#
vagrant@clientebind9:~$ dig correo.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> correo.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62602
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 8b2ae051a1882beef49728ef5dd3a9ce548409ebce6698d3 (good)
;; QUESTION SECTION:
;correo.iesgn.org.		IN	A

;; ANSWER SECTION:
correo.iesgn.org.	86400	IN	A	10.0.0.200

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	A	10.0.0.100
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.101#53(10.0.0.101)
;; WHEN: Tue Nov 19 08:37:34 GMT 2019
;; MSG SIZE  rcvd: 153

vagrant@clientebind9:~$ 
~~~

### Delegación de dominio.
- Creación del subdominio `informatica.iesgn.org` en la zona `iesgn.org` (`/var/cache/bind/db.iesgn.org`):
~~~
; Subdominio informatica.iesgn.org
$ORIGIN informatica.iesgn.org.
@              IN    NS    jesus-subd
jesus-subd    IN    A     10.0.0.102
~~~

- Configuración de la zona `informatica.iesgn.org` en el NS del subdominio (`/etc/bind/named.conf.local`):
~~~
// Zona informatica.iesgn.org
zone "informatica.iesgn.org" {
type master;
file "db.informatica.iesgn.org";
};
~~~

- Creación de la zona `informatica.iesgn.org` (`/var/cache/bind/db.informatica.iesgn.org`):
~~~
$TTL    86400
@       IN      SOA     jesus-subd.informatica.iesgn.org. root.informatica.iesgn.org. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS              jesus-subd.informatica.iesgn.org.
@       IN      MX      10      correo.informatica.iesgn.org.

$ORIGIN informatica.iesgn.org.
; Máquinas:
jesus-subd    IN    A         10.0.0.102
web            IN    A        10.0.0.200
ftp            IN    A        10.0.0.201
correo         IN    A        10.0.0.202
; Alias:
www            IN    CNAME    web
~~~

- Prueba de funcionamiento:
~~~
#----- Resolución de los nombres www y ftp -----#
vagrant@clientebind9:~$ dig www.informatica.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.informatica.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30699
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 81e1dc6f1c03cff9f1afa9c85dd4f712696d2ef8e03d4bb4 (good)
;; QUESTION SECTION:
;www.informatica.iesgn.org.	IN	A

;; ANSWER SECTION:
www.informatica.iesgn.org. 86400 IN	CNAME	web.informatica.iesgn.org.
web.informatica.iesgn.org. 86400 IN	A	10.0.0.200

;; AUTHORITY SECTION:
informatica.iesgn.org.	86400	IN	NS	jesus-subd.informatica.iesgn.org.

;; Query time: 68 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 20 08:19:30 GMT 2019
;; MSG SIZE  rcvd: 142

vagrant@clientebind9:~$ dig ftp.informatica.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ftp.informatica.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46557
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 6ee6337f3b4fb7a94acdd2b75dd4f72c326ea9d6a58c9196 (good)
;; QUESTION SECTION:
;ftp.informatica.iesgn.org.	IN	A

;; ANSWER SECTION:
ftp.informatica.iesgn.org. 86400 IN	A	10.0.0.201

;; AUTHORITY SECTION:
informatica.iesgn.org.	86400	IN	NS	jesus-subd.informatica.iesgn.org.

;; Query time: 4 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 20 08:19:56 GMT 2019
;; MSG SIZE  rcvd: 124

vagrant@clientebind9:~$

#----- Resolución del servidor NS de la zona -----#
vagrant@clientebind9:~$ dig ns informatica.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ns informatica.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33881
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 237eba9bc2e5891436ce63da5dd4f74c0a98c0e43e9e6278 (good)
;; QUESTION SECTION:
;informatica.iesgn.org.		IN	NS

;; ANSWER SECTION:
informatica.iesgn.org.	86400	IN	NS	jesus-subd.informatica.iesgn.org.

;; Query time: 4 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 20 08:20:28 GMT 2019
;; MSG SIZE  rcvd: 104

vagrant@clientebind9:~$

#----- Resolución del servidor MX de la zona -----#
vagrant@clientebind9:~$ dig mx informatica.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> mx informatica.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52257
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d08eebd4eff78f202c2e060d5dd4f75f58291af7c333cfe4 (good)
;; QUESTION SECTION:
;informatica.iesgn.org.		IN	MX

;; ANSWER SECTION:
informatica.iesgn.org.	86400	IN	MX	10 correo.informatica.iesgn.org.

;; AUTHORITY SECTION:
informatica.iesgn.org.	86381	IN	NS	jesus-subd.informatica.iesgn.org.

;; Query time: 4 msec
;; SERVER: 10.0.0.100#53(10.0.0.100)
;; WHEN: Wed Nov 20 08:20:47 GMT 2019
;; MSG SIZE  rcvd: 127

vagrant@clientebind9:~$ 
~~~

### DDNS.
- Modificación para poder utilizar la clave `rndc.key` (`/etc/bind/named.conf.options`):
~~~
// Configuración DDNS
   include "/etc/bind/rndc.key";
   controls {
      inet 127.0.0.1 port 953
      allow { 127.0.0.1; } keys { "rndc-key"; };
   };
~~~

- Modificación de las zonas activas (`/etc/bind/named.conf.local`):
~~~
// Zona iesgn.org
zone "iesgn.org" {
  type master;
  file "db.iesgn.org";
  allow-update { key "rndc-key"; };
};

// Zona inversa IPv4 iesgn.org
zone "0.0.10.in-addr.arpa" {
  type master;
  file "db.0.0.10";
  allow-update { key "rndc-key"; };
};
~~~

- Configuración de la zona directa (`/var/cache/bind/db.iesgn.org`):
~~~
$TTL    86400
@       IN      SOA     jesus.iesgn.org. root.iesgn.org. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS              jesus.iesgn.org.
@       IN      MX      10      correo.iesgn.org.

$ORIGIN iesgn.org.
; Máquinas IPv4:
jesus          IN    A    10.0.0.100
~~~

- Configuración de la zona inversa (`/var/cache/bind/db.0.0.10`):
~~~
$TTL    86400
@       IN      SOA     jesus.iesgn.org. root.iesgn.org. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      jesus.iesgn.org.

$ORIGIN 0.0.10.in-addr.arpa.
; Máquinas:
100  IN    PTR    jesus.iesgn.org.
~~~

- Modificación de la interfaz por la que trabaja el servidor DHCP (`/etc/default/isc-dhcp-server`):
~~~
INTERFACESv4="eth2"
~~~

- Configuración del servidor DHCP (`/etc/dhcp/dhcpd.conf`):
~~~
# Configuración DDNS
include "/etc/bind/rndc.key";

server-identifier jesus;
ddns-updates on;
ddns-update-style interim;
ddns-domainname "iesgn.org.";
ddns-rev-domainname "0.0.10.in-addr.arpa.";
deny client-updates;

### Definición de zonas
##### Zona directa
zone iesgn.org. {
  primary 127.0.0.1;
  key rndc-key;
}

zone 0.0.10.in-addr.arpa. {
  primary 127.0.0.1;
  key rndc-key;
}
~~~