# Práctica DNS.
## DNSmasq.
- Instalación del servicio:
~~~
root@DNSmasq~# apt install dnsmasq
~~~

- Configuración del servicio (`/etc/dnsmasq.conf`):
~~~
...
strict-order
...
interface=eth2
~~~

- Configuración de resolución de nombres (`/etc/hosts`):
~~~
# DNSmasq.
192.168.1.10 www.iesgn.org
192.168.1.10 departamentos.iesgn.org
~~~

- Configuración del cliente (`/etc/resolv.conf`):
~~~
nameserver 192.168.1.10
~~~

## bind9.
- Instalación del servicio:
~~~
root@jesus:~# apt install bind9
~~~

- Configuración de zonas (`/etc/bind/named.conf.local`):
~~~
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
jesus          IN    A    10.0.0.3
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
; Máquinas:
3    IN    PTR    jesus.iesgn.org.
4    IN    PTR    clientebind9.iesgn.org.
5    IN    PTR    cliente2bind9.iesgn.org.
200  IN    PTR    correo.iesgn.org.
201  IN    PTR    ftp.iesgn.org.
202  IN    PTR    web.iesgn.org.
~~~

- Configuración de la zona inversa IPv6 (`/var/cache/bind/db.f.f.7.2.0.0.a.0.0.0.0.0.8.e.f`):
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

$ORIGIN f.f.7.2.0.0.a.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.e.f.ip6.arpa.
c.4.0.e.8.9.e.f    IN    PTR    jesus.iesgn.org.
a.7.1.a.a.e.e.f    IN    PTR    clientebind9.iesgn.org.
3.c.4.7.2.3.e.f    IN    PTR    cliente2bind9.iesgn.org.
e.2.e.a.2.e.e.f    IN    PTR    correo.iesgn.org.
2.1.c.1.a.0.e.f    IN    PTR    ftp.iesgn.org.
4.e.e.6.7.e.f      IN    PTR    web.iesgn.org.
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	jesus.iesgn.org.

;; ADDITIONAL SECTION:
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3

;; Query time: 1 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3
correo.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fee2:ae2e
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 0 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
;; SERVER: 10.0.0.3#53(10.0.0.3)
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
jesus.iesgn.org.	86400	IN	A	10.0.0.3
jesus.iesgn.org.	86400	IN	AAAA	fe80::a00:27ff:fe98:e04c

;; Query time: 1 msec
;; SERVER: 10.0.0.3#53(10.0.0.3)
;; WHEN: Wed Nov 13 08:25:36 GMT 2019
;; MSG SIZE  rcvd: 171

vagrant@clientebind9:~$ 
~~~