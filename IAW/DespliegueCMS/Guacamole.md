# Guacamole.
`Guacamole` es un CMS escrito en `Java` utilizado para acceder remotamente a las distintas máquinas de nuestra red a través de un navegador.

### Instalación.
Antes de comenzar a instalar `Guacamole` instalaremos los siguientes paquetes así como sus dependenciasx:
~~~
root@guacamole:~# apt install libcairo2-dev libjpeg62-turbo-dev libpng-dev libossp-uuid-dev libtool
~~~

A continuación realizaremos la instalación  del (servidor)[http://archive.apache.org/dist/guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz], primero lo compilaremos y posteriormente lo instalaremos:
~~~
#----- Configuración -----#
root@guacamole:~/guacamole-server-1.1.0# ./configure --with-init-dir=/etc/init.d

#----- Compilación -----#
root@guacamole:~/guacamole-server-1.1.0# make

#----- Instalación -----#
root@guacamole:~/guacamole-server-1.1.0# make install
~~~

Una vez instalado el servidor, procederemos a instalar el (cliente)[http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.1.0/binary/guacamole-1.1.0.war]:
~~~
root@guacamole:~# ls -l /var/lib/tomcat9/webapps/
total 9304
drwxr-x--- 11 tomcat tomcat    4096 Feb 16 18:42 guacamole-1.1.0
drwxr-xr-x  3 root   root      4096 Feb 16 18:10 ROOT
root@guacamole:~# 
~~~