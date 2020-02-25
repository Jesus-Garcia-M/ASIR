# Proxy Inverso.
Para esta práctica utilizaremos el [escenario anterior](../Balanceador/Vagrantfile) e instalaremos `apache2` como proxy inverso.

### Pasos previos.
Ya que `haproxy` está funcionando debido al ejercicio anterior, antes de comenzar deberemos pararlo:
~~~

~~~

### Instalación.
A continuación instalaremos `apache2` y activaremos el módulo `proxy_http`:
~~~
root@balanceador:~# apt install apache2
root@balanceador:~# a2enmod proxy_http
Considering dependency proxy for proxy_http:
Enabling module proxy.
Enabling module proxy_http.
To activate the new configuration, you need to run:
  systemctl restart apache2
root@balanceador:~# systemctl restart apache2
~~~

### Configuración.
Vamos a realizar dos configuraciones:
 - Configuración 1: Acceso a los servidores a través de `www.app1.org` y `www.app2.org`.
 - Configuración 2: Acceso a los servidores a través de `www.servidor.org/app1` y `www.servidor.org/app2`.

Configuración 1 (`/etc/apache2/sites-enabled/000-default.conf`):
~~~
#################
# Configuración #
#################
# Máquina apache1 como "www.app1.org"
ProxyPass "www.app1.org" 10.10.10.11
# Máquina apache2 como "www.app2.org"
ProxyPass "www.app2.org" 10.10.10.22
~~~