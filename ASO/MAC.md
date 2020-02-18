# SELinux.
La máquina `Salmorejo` siempre a tenido `SELinux` funcionando, por lo que he ido añadiendo distintas reglas (tanto en `SELinux` como en `firewalld`) para permitir el funcionamiento de distintos servicios.

Primero comprobaré si `SELinux` y `firewalld` están funcionando y posteriormente listaré las distintas reglas añadidas:
~~~
#----- Comprobación de funcionamiento de SELinux -----#
[root@salmorejo ~]# getenforce
Enforcing
[root@salmorejo ~]# 

#----- Comprobación de funcionamiento de firewalld -----#
[root@salmorejo ~]# firewall-cmd --state
running
[root@salmorejo ~]#

#----- Reglas de SELinux -----#
# En mi caso he tenido que habilitar las siguientes funcionas:
# Permitir el acceso a las distintas aplicaciones web:
[root@salmorejo ~]# getsebool -a | grep httpd_can_network_connect
httpd_can_network_connect --> on
[root@salmorejo ~]# 
# Permitir a las aplicaciones web acceder a una base de datos:
[root@salmorejo ~]# getsebool -a | grep httpd_can_network_connect_db
httpd_can_network_connect_db --> on
[root@salmorejo ~]# 
# Permitir el uso y escritura de chroot en vsftpd:
[root@salmorejo ~]# getsebool -a | grep ftpd_full_access
ftpd_full_access --> on
[root@salmorejo ~]#

#----- Reglas de firewalld -----#
# En mi caso he añadido los servicios ftp (20), http (80) y ssh (22) junto a sus respectivos puertos.
# Adicionalmente, he añadido los puertos 9101, 9102, 9103 (Sistema de backups Bacula) y 21 (FTP) de forma manual.
[root@salmorejo ~]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources: 
  services: dhcpv6-client ftp http ssh
  ports: 21/tcp 9101/tcp 9102/tcp 9103/tcp
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
	
[root@salmorejo ~]# 
~~~ 

# Apparmor.
Instalación del paquete `apparmor-utils` que añadirá nuevas funcionalidades como el asistente para la creación de perfiles:
~~~
root@croqueta:~# apt install apparmor-utils
~~~