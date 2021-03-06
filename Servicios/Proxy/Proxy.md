# Proxy.
Durante esta práctica utilizaremos la herramienta `squid` y realizaremos distintas configuraciones.
Adicionalmente utilizaremos un escenario [Vagrant](Vagrantfile) con las siguientes máquinas:
- `proxy`: Servidor proxy, direccioón IP: 10.0.0.10.
- `cliente_int`: Cliente, dirección IP: 10.0.0.11.

### Permitir conexiones desde la red externa.
Instalación de `squid` en la máquina `proxy`:
~~~
root@proxy:~# apt install squid
~~~

Creamos una ACL en `squid` para permitir el acceso de la red externa (`/etc/squid/squid.conf`):
~~~
#################
# Configuración #
#################

# Permitir conexiones desde la red externa.
## Definición de la ACL.
acl externa src 192.168.200.0/24
## Permisos.
http_access allow externa

#----- Recargamos el servicio -----#
root@proxy:~# systemctl reload squid
~~~

Una vez instalado y configurado `squid` pasaremos a configurar el cliente, para ello deberemos configurar la navegación a través de proxy en el navegador o bien configurando el proxy del sistema.
Configuración del navegador (`Firefox ESR`):
![Configuración Proxy Navegador 1](images/confproxyweb2.png)
![Configuración Proxy Navegador 2](images/confproxyweb1.png)

Configuración del proxy del sistema:
![Configuración Proxy Sistema 1](images/confproxysys1.png)
![Configuración Proxy Sistema 2](images/confproxysys2.png)

Comprobamos el funcionamiento del proxy desde el servidor (`/var/log/squid/access.log`):
~~~
root@proxy:~# tail -f /var/log/squid/access.log
...
1582016840.050    181 192.168.200.1 TCP_TUNNEL/200 5447 CONNECT upload.wikimedia.org:443 - HIER_DIRECT/91.198.174.208 -
1582016840.057    223 192.168.200.1 TCP_TUNNEL/200 5662 CONNECT upload.wikimedia.org:443 - HIER_DIRECT/91.198.174.208 -
1582016840.072    238 192.168.200.1 TCP_TUNNEL/200 19658 CONNECT upload.wikimedia.org:443 - HIER_DIRECT/91.198.174.208 -
1582016840.076    242 192.168.200.1 TCP_TUNNEL/200 14466 CONNECT upload.wikimedia.org:443 - HIER_DIRECT/91.198.174.208 -
1582016840.173    339 192.168.200.1 TCP_TUNNEL/200 57231 CONNECT upload.wikimedia.org:443 - HIER_DIRECT/91.198.174.208 -
1582016840.702    158 192.168.200.1 TCP_MISS/200 1038 POST http://ocsp.pki.goog/gts1o1 - HIER_DIRECT/172.217.17.3 application/ocsp-response
1582016841.538    245 192.168.200.1 TCP_TUNNEL/200 15250 CONNECT meta.wikimedia.org:443 - HIER_DIRECT/91.198.174.192 -
~~~

### Permitir conexiones desde la red interna.
Añadimos una nueva ACL en `squid` para permitir el acceso a la red interna (`/etc/squid/squid.conf`):
~~~
# Permitir conexiones desde la red interna.
## Definición de la ACL.
acl interna src 10.0.0.0/24
## Permisos.
http_access allow interna

#----- Recargamos el servicio -----#
root@proxy:~# systemctl reload squid
~~~

Configuramos el proxy en el cliente a través de variables de entorno:
~~~
root@buster:~# export http_proxy="http://10.0.0.10:3128"
root@buster:~# export https_proxy="https://10.0.0.10:3128"
~~~

Comprobamos el funcionamiento del proxy desde el servidor (`/var/log/squid/access.log`):
~~~
root@proxy:~# tail -f /var/log/squid/access.log
...
1582097900.980     77 10.0.0.11 TCP_MISS/301 857 GET http://google.es/ - HIER_DIRECT/172.217.168.163 text/html
1582097903.213    223 10.0.0.11 TCP_MISS/200 3359 GET http://www.google.es/ - HIER_DIRECT/172.217.17.3 text/html
~~~

### Creación de listas negras.
Para la creación de una lista negra utilizaremos un fichero en el que inidicaremos los dominios que vamos a bloquear (`/etc/squid/listanegra.txt`):
~~~
www.google.es
~~~

Una vez creada la lista añadiremos la siguiente configuración a `squid` (`/etc/squid/squid.conf`):
~~~
# Configuración de lista negra.
## Definición de la ACL
acl domain_blacklist dstdomain "/etc/squid/listanegra.txt"
## Permisos.
http_access deny all domain_blacklist

#----- Recargamos el servicio -----#
root@proxy:~# systemctl reload squid
~~~

Comprobamos el funcionamiento del proxy desde el servidor (`/var/log/squid/access.log`):
~~~
root@proxy:~# tail -f /var/log/squid/access.log
...
1582099414.745      0 10.0.0.11 TCP_DENIED/403 3961 GET http://www.google.es/ - HIER_NONE/- text/html
~~~

### Creación de listas blancas.
Para la creación de una lista blanca utilizaremos un fichero en el que inidicaremos los dominios que vamos a permitir (`/etc/squid/listablanca.txt`):
~~~
www.google.es
~~~

Una vez creada la lista añadiremos la siguiente configuración a `squid` (`/etc/squid/squid.conf`):
~~~
# Configuración de lista blanca.
## Definición de la ACL.
acl listablanca dstdomain "/etc/squid/listablanca.txt"
## Permisos.
http_access allow listablanca
http_access deny all

#----- Recargamos el servicio -----#
root@proxy:~# systemctl reload squid
~~~

Comprobamos el funcionamiento del proxy desde el servidor (`/var/log/squid/access.log`):
~~~
root@proxy:/etc/squid# tail -f /var/log/squid/access.log
...
1582099914.259      0 10.0.0.11 TCP_DENIED/403 3964 GET http://www.google.com/ - HIER_NONE/- text/html
1582099922.808    124 10.0.0.11 TCP_MISS/200 3362 GET http://www.google.es/ - HIER_DIRECT/172.217.17.3 text/html
~~~