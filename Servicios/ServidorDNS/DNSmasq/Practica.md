# Práctica DNSmasq.
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