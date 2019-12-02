# Actualización a CentOS 8.
- Instalación de `epel-release`:
~~~
[centos@salmorejo ~]$ sudo yum -y install epel-release
~~~

- Instalación de `yum-utils`:
~~~
[centos@salmorejo ~]$ sudo yum -y install yum-utils
~~~

- Instalación de `rpmconf`:
~~~
[centos@salmorejo ~]$ sudo yum -y install rpmconf
~~~

- Ejecución de `rpmconf -a`:
~~~
[centos@salmorejo ~]$ sudo rpmconf -a
Configuration file `/etc/ssh/sshd_config'
-rw-------. 1 root root 3907 ago  9 01:40 /etc/ssh/sshd_config.rpmnew
-rw-------. 1 root root 3851 oct 14 11:13 /etc/ssh/sshd_config
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      M	    : merge configuration files
      Z     : background this process to examine the situation
      S     : skip this file
 The default action is to keep your current version.
*** aliases (Y/I/N/O/D/Z/S) [default=N] ? 
Your choice: N
Configuration file `/etc/nsswitch.conf'
-rw-r--r--. 1 root root 1746 sep 12  2017 /etc/nsswitch.conf
-rw-r--r--. 1 root root 1938 ago  6 23:00 /etc/nsswitch.conf.rpmnew
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      M	    : merge configuration files
      Z     : background this process to examine the situation
      S     : skip this file
 The default action is to keep your current version.
*** aliases (Y/I/N/O/D/Z/S) [default=N] ? 
Your choice: Y
[centos@salmorejo ~]$ 
~~~

- Limpieza de los paquetes no necesarios:
~~~
[centos@salmorejo ~]$ sudo package-cleanup --leaves
[centos@salmorejo ~]$ sudo package-cleanup --orphans
~~~

- Instalación de `dnf`:
~~~
[centos@salmorejo ~]$ sudo yum -y install dnf
~~~

- Desinstalación de `yum`:
~~~
[centos@salmorejo ~]$ sudo dnf -y remove yum yum-metadata-parser
[centos@salmorejo ~]$ sudo rm -rf /etc/yum
~~~

- Actualización del sistema de paquetas `dnf`:
~~~
[centos@salmorejo ~]$ sudo dnf -y upgrade
~~~

- Instalación de los paquetes de `CentOS 8`:
~~~
[centos@salmorejo ~]$ sudo dnf -y upgrade http://mirror.bytemark.co.uk/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.0-0.1905.0.9.el8.x86_64.rpm
~~~

- Actualización del repositorio `EPEL`:
~~~
[centos@salmorejo ~]$ sudo dnf -y --allowerasing --best upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
~~~

- Limpieza de ficheros temporales:
~~~
[centos@salmorejo ~]$ sudo dnf clean all
66 archivos eliminados
[centos@salmorejo ~]$ 
~~~

- Eliminación de los kernels existentes:
~~~
[centos@salmorejo ~]$ sudo rpm -e `rpm -q kernel`
~~~

- Eliminación de paquetes conflictivos:
~~~
[centos@salmorejo ~]$ sudo rpm -e --nodeps sysvinit-tools
~~~

- Actualización a CentOS 8:
~~~
[centos@salmorejo ~]$ sudo dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
~~~

- Instalación del nuevo kernel:
~~~
[centos@salmorejo ~]$ sudo dnf -y install kernel-core
~~~

- Instalación de paquetería mínima:
~~~
[centos@salmorejo ~]$ sudo dnf -y --allowerasing groupupdate "Core" "Minimal Install"
~~~

- Añadir configuración de SELinux:
~~~
[centos@salmorejo ~]$ sudo setsebool -P httpd_can_network_connect 1
~~~

### Reconfiguración de Nextcloud.
- Cambio de los permisos de `/var/lib/php/session`:
~~~
[centos@salmorejo config]$ sudo chown -R nginx:nginx /var/lib/php/session
~~~

- Reestablecer la contraseña de `admin`:
~~~
[root@salmorejo ~]# [root@salmorejo config]# sudo -u nginx php /var/www/nextcloud/occ user:resetpassword admin
The current PHP memory limit is below the recommended value of 512MB.
Enter a new password: 
Confirm the new password: 
Successfully reset password for admin
[root@salmorejo ~]#
~~~

- Prueba de funcionamiento:
~~~
jesus@jesus:~$ ssh -i .ssh/OnlyIMayPass.pem centos@salmorejo
Enter passphrase for key '.ssh/OnlyIMayPass.pem':
Last login: Mon Nov 25 16:13:41 2019 from 172.23.0.78
[centos@salmorejo ~]$ cat /etc/redhat-release
CentOS Linux release 8.0.1905 (Core)
[centos@salmorejo ~]$
~~~
