### Configuración de red estática.
- Modificación del fichero `/etc/sysconfig/network-scripts/ifcfg-eth0`:
~~~
BOOTPROTO=none
IPADDR=10.0.0.11
NETMASK=255.255.255.0
GATEWAY=10.0.0.1
DNS1=192.168.202.2
DEVICE=eth0
HWADDR=fa:16:3e:f5:78:50
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
~~~

### Actualización del sistema.
~~~
[centos@ejercicioscentos ~]$ sudo yum update
~~~

### Instalación del repositorio EPEL.
~~~
[centos@ejercicioscentos ~]$ sudo yum install epel-realease
~~~

### Instalación del repositorio CentOSPlus.
- Instalación de `yum-utils`:
~~~
[centos@ejercicioscentos ~]$ sudo yum install yum-utils
~~~

- Activación del repositorio CentOSPlus:
~~~
[centos@ejercicioscentos ~]$ sudo yum-config-manager --enable centosplus
Complementos cargados:fastestmirror
================================================================== repo: centosplus ==================================================================
[centosplus]
async = True
bandwidth = 0
base_persistdir = /var/lib/yum/repos/x86_64/7
baseurl = 
cache = 0
cachedir = /var/cache/yum/x86_64/7/centosplus
check_config_file_age = True
compare_providers_priority = 80
...

[centos@ejercicioscentos ~]$ 
~~~

### Instalación del programa dig.
- Buesqueda del paquete:
~~~
[centos@ejercicioscentos ~]$ yum provides dig
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.csuc.cat
 * centosplus: ftp.csuc.cat
 * epel: epel.uni-sofia.bg
 * extras: ftp.csuc.cat
 * updates: ftp.cixug.es
base/7/x86_64/filelists_db                                                                                                     | 7.3 MB  00:00:00     
centosplus/7/x86_64/filelists_db                                                                                               | 574 kB  00:00:00     
epel/x86_64/filelists_db                                                                                                       |  12 MB  00:00:03     
extras/7/x86_64/filelists_db                                                                                                   | 207 kB  00:00:00     
updates/7/x86_64/filelists_db                                                                                                  | 2.1 MB  00:00:00     
32:bind-utils-9.11.4-9.P2.el7.x86_64 : Utilities for querying DNS name servers
Repositorio        : base
Resultado obtenido desde:
Nombre del archivo    : /usr/bin/dig

[centos@ejercicioscentos ~]$
~~~

- Instalación del paquete:
~~~
[centos@ejercicioscentos ~]$ sudo yum install bind-utils
...

======================================================================================================================================================
 Package                             Arquitectura                    Versión                                      Repositorio                   Tamaño
======================================================================================================================================================
Instalando:
 bind-utils                          x86_64                          32:9.11.4-9.P2.el7                           base                          258 k
Instalando para las dependencias:
 bind-libs                           x86_64                          32:9.11.4-9.P2.el7                           base                          154 k

Resumen de la transacción
======================================================================================================================================================
Instalar  1 Paquete (+1 Paquete dependiente)

Tamaño total de la descarga: 412 k
Tamaño instalado: 769 k
Is this ok [y/d/N]: y
Downloading packages:
(1/2): bind-libs-9.11.4-9.P2.el7.x86_64.rpm                                                                                    | 154 kB  00:00:00     
(2/2): bind-utils-9.11.4-9.P2.el7.x86_64.rpm                                                                                   | 258 kB  00:00:00     
------------------------------------------------------------------------------------------------------------------------------------------------------

...

Instalado:
  bind-utils.x86_64 32:9.11.4-9.P2.el7                                                                                                                

Dependencia(s) instalada(s):
  bind-libs.x86_64 32:9.11.4-9.P2.el7                                                                                                                 

¡Listo!
[centos@ejercicioscentos ~]$ 
~~~

### Mostrar información del kernel actual.
~~~
[centos@ejercicioscentos ~]$ yum info kernel
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.csuc.cat
 * centosplus: ftp.csuc.cat
 * epel: epel.uni-sofia.bg
 * extras: ftp.csuc.cat
 * updates: ftp.cixug.es
Paquetes instalados
Nombre        : kernel
Arquitectura        : x86_64
Versión     : 3.10.0
Lanzamiento     : 693.el7
Tamaño        : 59 M
Repositorio        : installed
Resumen     : The Linux kernel
URL         : http://www.kernel.org/
Licencia     : GPLv2
Descripción :The kernel package contains the Linux kernel (vmlinuz), the core of any
           : Linux operating system.  The kernel handles the basic functions
           : of the operating system: memory allocation, process allocation, device
           : input and output, etc.

Nombre        : kernel
Arquitectura        : x86_64
Versión     : 3.10.0
Lanzamiento     : 1062.4.1.el7
Tamaño        : 64 M
Repositorio        : installed
Desde el repositorio   : updates
Resumen     : The Linux kernel
URL         : http://www.kernel.org/
Licencia     : GPLv2
Descripción :The kernel package contains the Linux kernel (vmlinuz), the core of any
           : Linux operating system.  The kernel handles the basic functions
           : of the operating system: memory allocation, process allocation, device
           : input and output, etc.

[centos@ejercicioscentos ~]$ 
~~~

### Instalación de la última versión de kernel disponible.
- Descarga, comprobación e importación de la clave GPG de ElRepo:
~~~
[centos@ejercicioscentos ~]$ wget https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
--2019-11-08 07:56:19--  https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
Resolviendo www.elrepo.org (www.elrepo.org)... 69.195.83.87
Conectando con www.elrepo.org (www.elrepo.org)[69.195.83.87]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 1722 (1,7K) [application/vnd.lotus-organizer]
Grabando a: “RPM-GPG-KEY-elrepo.org”

100%[============================================================================================================>] 1.722       --.-K/s   en 0s      

2019-11-08 07:56:20 (139 MB/s) - “RPM-GPG-KEY-elrepo.org” guardado [1722/1722]

[centos@ejercicioscentos ~]$ gpg --quiet --with-fingerprint RPM-GPG-KEY-elrepo.org
pub  1024D/BAADAE52 2009-03-17 elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>
      Huella de clave = 96C0 104F 6315 4731 1E0B  B1AE 309B C305 BAAD AE52
sub  2048g/B8C66E6D 2009-03-17

[centos@ejercicioscentos ~]$ sudo rpm --import RPM-GPG-KEY-elrepo.org
[centos@ejercicioscentos ~]$
~~~

- Descarga e instalación de ElRepo:
~~~
[centos@ejercicioscentos ~]$ wget http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
--2019-11-08 07:58:49--  http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Resolviendo www.elrepo.org (www.elrepo.org)... 69.195.83.87
Conectando con www.elrepo.org (www.elrepo.org)[69.195.83.87]:80... conectado.
Petición HTTP enviada, esperando respuesta... 301 Moved Permanently
Localización: https://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm [siguiendo]
--2019-11-08 07:58:50--  https://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Conectando con www.elrepo.org (www.elrepo.org)[69.195.83.87]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 61
Grabando a: “elrepo-release-7.0-2.el7.elrepo.noarch.rpm”

100%[============================================================================================================>] 61          --.-K/s   en 0s      

2019-11-08 07:58:51 (4,19 MB/s) - “elrepo-release-7.0-2.el7.elrepo.noarch.rpm” guardado [61/61]

[centos@ejercicioscentos ~]$ sudo rpm -i -f elrepo-release-7.0-2.el7.elrepo.noarch.rpm
[centos@ejercicioscentos ~]$ 
~~~

- Instalación de la versión de kernel actual:
~~~
[centos@ejercicioscentos ~]$ sudo yum --disablerepo='*' --enablerepo=elrepo-kernel install kernel-ml
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * elrepo-kernel: elrepo.mirrors.arminco.com
elrepo-kernel                                                                                                                  | 2.9 kB  00:00:00     
elrepo-kernel/primary_db                                                                                                       | 1.8 MB  00:00:01     
Resolviendo dependencias
--> Ejecutando prueba de transacción
---> Paquete kernel-ml.x86_64 0:5.3.9-1.el7.elrepo debe ser instalado
--> Resolución de dependencias finalizada

Dependencias resueltas

======================================================================================================================================================
 Package                          Arquitectura                  Versión                                    Repositorio                          Tamaño
======================================================================================================================================================
Instalando:
 kernel-ml                        x86_64                        5.3.9-1.el7.elrepo                         elrepo-kernel                         48 M

Resumen de la transacción
======================================================================================================================================================
Instalar  1 Paquete

Tamaño total de la descarga: 48 M
Tamaño instalado: 216 M
Is this ok [y/d/N]: y
Downloading packages:
kernel-ml-5.3.9-1.el7.elrepo.x86_64.rpm                                                                                        |  48 MB  00:00:08     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Advertencia: Las bases de datos (RPMDB) han sido modificadas por un elemento ajeno a yum.
  Instalando    : kernel-ml-5.3.9-1.el7.elrepo.x86_64                                                                                             1/1 
  Comprobando   : kernel-ml-5.3.9-1.el7.elrepo.x86_64                                                                                             1/1 

Instalado:
  kernel-ml.x86_64 0:5.3.9-1.el7.elrepo                                                                                                               

¡Listo!
[centos@ejercicioscentos ~]$ 
~~~

### Busqueda de las distintas versiones de kernel disponibles.
~~~
[centos@ejercicioscentos ~]$ sudo yum --disablerepo='*' --enablerepo=elrepo-kernel list kernel*
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * elrepo-kernel: mirror.pit.teraswitch.com
Paquetes instalados
kernel.x86_64                                                             3.10.0-693.el7                                                installed     
kernel.x86_64                                                             3.10.0-1062.4.1.el7                                           @updates      
kernel-ml.x86_64                                                          5.3.9-1.el7.elrepo                                            @elrepo-kernel
kernel-tools.x86_64                                                       3.10.0-1062.4.1.el7                                           @updates      
kernel-tools-libs.x86_64                                                  3.10.0-1062.4.1.el7                                           @updates      
Paquetes disponibles
kernel-lt.x86_64                                                          4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-devel.x86_64                                                    4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-doc.noarch                                                      4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-headers.x86_64                                                  4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-tools.x86_64                                                    4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-tools-libs.x86_64                                               4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-lt-tools-libs-devel.x86_64                                         4.4.199-1.el7.elrepo                                          elrepo-kernel 
kernel-ml-devel.x86_64                                                    5.3.9-1.el7.elrepo                                            elrepo-kernel 
kernel-ml-doc.noarch                                                      5.3.9-1.el7.elrepo                                            elrepo-kernel 
kernel-ml-headers.x86_64                                                  5.3.9-1.el7.elrepo                                            elrepo-kernel 
kernel-ml-tools.x86_64                                                    5.3.9-1.el7.elrepo                                            elrepo-kernel 
kernel-ml-tools-libs.x86_64                                               5.3.9-1.el7.elrepo                                            elrepo-kernel 
kernel-ml-tools-libs-devel.x86_64                                         5.3.9-1.el7.elrepo                                            elrepo-kernel 
[centos@ejercicioscentos ~]$ 
~~~

### Mostrar información sobre la última versión de kernel.
~~~
[centos@ejercicioscentos ~]$ yum info kernel-ml
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.csuc.cat
 * centosplus: ftp.csuc.cat
 * elrepo: mirror.pit.teraswitch.com
 * epel: mirror.kinamo.be
 * extras: ftp.csuc.cat
 * updates: ftp.cixug.es
Paquetes instalados
Nombre        : kernel-ml
Arquitectura        : x86_64
Versión     : 5.3.9
Lanzamiento     : 1.el7.elrepo
Tamaño        : 216 M
Repositorio        : installed
Desde el repositorio   : elrepo-kernel
Resumen     : The Linux kernel. (The core of any Linux-based operating system.)
URL         : https://www.kernel.org/
Licencia     : GPLv2
Descripción :This package provides the Linux kernel (vmlinuz), the core of any
           : Linux-based operating system. The kernel handles the basic functions
           : of the OS: memory allocation, process allocation, device I/O, etc.

[centos@ejercicioscentos ~]$ 
~~~

### Actualización de CentOS7 a CentOS8.
- Instalación del repositorio `epel`:
~~~
[centos@ejercicioscentos ~]$ sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
~~~

- Instalación de `yum-utils`:
~~~
[centos@ejercicioscentos ~]$ sudo yum install rpmconf yum-utils
~~~

- Ejecución de `rpmconf -a`:
~~~
[centos@ejercicioscentos ~]$ sudo rpmconf -a
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
Your choice: N
[centos@ejercicioscentos ~]$
~~~

- Limpieza de los paquetes que ya no son necesarios:
~~~
[centos@ejercicioscentos ~]$ package-cleanup --leaves
[centos@ejercicioscentos ~]$ package-cleanup --orphans
~~~

- Instalación del gestor de paquetes `dnf`:
~~~
[centos@ejercicioscentos ~]$ sudo yum install dnf
~~~

- Eliminar el gestor de paquetes `yum`:
~~~
[centos@ejercicioscentos ~]$ sudo dnf remove yum yum-metadata-parser
[centos@ejercicioscentos ~]$ sudo rm -rf /etc/yum
~~~

- Actualizar el sistema con `dnf`:
~~~
[centos@ejercicioscentos ~]$ sudo dnf upgrade
~~~

- Instalar la nueva versión:
~~~
[centos@ejercicioscentos ~]$ sudo dnf upgrade http://mirror.bytemark.co.uk/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.0-0.1905.0.9.el8.x86_64.rpm
~~~

- Actualizar el repositorio `epel`:
~~~
[centos@ejercicioscentos ~]$ sudo dnf upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
~~~

- Limpieza de los fiheros temporales:
~~~
[centos@ejercicioscentos ~]$ sudo dnf clean all
~~~

- Eliminar los kernels existentes:
~~~
[centos@ejercicioscentos ~]$ sudo rpm -e `rpm -q kernel`
~~~

- Eliminar los conflictos:
~~~
[centos@ejercicioscentos ~]$ sudo rpm -e --nodeps sysvinit-tools
~~~

- Actualización del sistema:
~~~
[centos@actualizarcentos ~]$ sudo dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
~~~