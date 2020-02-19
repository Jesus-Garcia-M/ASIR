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
Instalamos el paquete `apparmor-utils` que añadirá nuevas funcionalidades como el asistente para la creación de perfiles:
~~~
root@croqueta:~# apt install apparmor-utils
~~~

Una vez instalado utilizaremos la herramienta `aa-genprof` para generar el perfil del programa deseado (En mi caso, `lynx`), pero no realizaremos el escaneo, únicamente la utilizaremos para generar el perfil:
~~~
root@apparmor:~# aa-genprof lynx
Writing updated profile for /usr/bin/lynx.
Setting /usr/bin/lynx to complain mode.

Before you begin, you may wish to check if a
profile already exists for the application you
wish to confine. See the following wiki page for
more information:
https://gitlab.com/apparmor/apparmor/wikis/Profiles

Profiling: /usr/bin/lynx

Please start the application to be profiled in
another window and exercise its functionality now.

Once completed, select the "Scan" option below in 
order to scan the system logs for AppArmor events. 

For each AppArmor event, you will be given the 
opportunity to choose whether the access should be 
allowed or denied.

[(S)can system log for AppArmor events] / (F)inish
Setting /usr/bin/lynx to enforce mode.

Reloaded AppArmor profiles in enforce mode.

Please consider contributing your new profile!
See the following wiki page for more information:
https://gitlab.com/apparmor/apparmor/wikis/Profiles

Finished generating profile for /usr/bin/lynx.
root@apparmor:~#
~~~

Una vez creado el perfil lo activaremos en modo estricto:
~~~
root@apparmor:~# aa-enforce /etc/apparmor.d/usr.bin.lynx
Setting /etc/apparmor.d/usr.bin.lynx to enforce mode.
root@apparmor:~# 
~~~

Para la configuración del perfil (`/etc/apparmor.d/usr.bin.lynx`) he ido ejecutando `lynx` viendo los errores que me iba proporcionando y solucionandolos poco a poco, terminando la configuración de la siguiente forma:
~~~
# Last Modified: Wed Feb 19 18:22:39 2020
#include <tunables/global>

/usr/bin/lynx {
  #include <abstractions/base>
  # Permitir la resolución de nombres.
  #include <abstractions/nameservice>

  # Permitir al usuario el uso de ficheros temporales.
  #include <abstractions/user-tmp>

  # Permisos sobre el binario de lynx.
  # m - Permite la ejecución de llamadas mmap.
  # r - Permiso de lectura.
  /usr/bin/lynx mr,
  # Permiso de lectura sobre el fichero de configuración.
  /etc/lynx/lynx.cfg r,
  # Permiso de lectura sobe el fichero de configuración de estilo.
  # Tipo de letra, colores etc...
  /etc/lynx/lynx.lss r,
  # Permiso de lectura para poder accedor a los MIME types.
  # Saber el tipo de fichero según la extensión.
  /etc/mailcap r,
  /etc/mime.types r,
}
~~~