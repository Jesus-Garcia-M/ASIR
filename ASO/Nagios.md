# Nagios - Monitorización.
### Instalación:
Primero descargaremos y descomprimiremos el paquete para posteriormente instalarlo:
~~~
#----- Descarga -----#
ubuntu@nagios-monitoring:/tmp$ wget https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz
--2020-02-08 18:21:56--  https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz
Resolving assets.nagios.com (assets.nagios.com)... 72.14.181.71, 2600:3c00::f03c:91ff:fedf:b821
Connecting to assets.nagios.com (assets.nagios.com)|72.14.181.71|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 64715872 (62M) [application/x-gzip]
Saving to: ‘xi-latest.tar.gz’

xi-latest.tar.gz                      100%[=======================================================================>]  61.72M   400KB/s    in 2m 15s  

2020-02-08 18:24:13 (468 KB/s) - ‘xi-latest.tar.gz’ saved [64715872/64715872]

ubuntu@nagios-monitoring:/tmp$

#----- Descompresión -----#
ubuntu@nagios-monitoring:/tmp$ tar xzf xi-latest.tar.gz

#----- Instalación -----#
ubuntu@nagios-monitoring:/tmp/nagiosxi$ sudo ./fullinstall
========================
Nagios XI Full Installer
========================

This script will do a complete install of Nagios XI by executing all necessary sub-scripts.

IMPORTANT: This script should only be used on a 'clean' install of CentOS, RHEL, Ubuntu LTS, Debian, or Oracle. Do NOT use this on a system
that has been tasked with other purposes or has an existing install of Nagios Core. To create such a clean install you should have selected
only the base package in the OS installer.
Do you want to continue? [Y/n] Y
...

~~~