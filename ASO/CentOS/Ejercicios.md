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