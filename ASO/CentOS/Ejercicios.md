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