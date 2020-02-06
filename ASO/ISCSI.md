# ISCSI
Para esta práctica disponemos de 2 máquinas, una que actuará como servidor (**IP: 192.168.1.10**) y otra que actuará como cliente (**IP: 192.168.1.11**).
La máquina servidor dispone de 3 discos adicionales de 500MB (`sdb`, `sdc` y `sdd`):
~~~
vagrant@iscsi-server:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 19.8G  0 disk 
├─sda1   8:1    0 18.8G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1021M  0 part [SWAP]
sdb      8:16   0  500M  0 disk 
sdc      8:32   0  500M  0 disk 
sdd      8:48   0  500M  0 disk 
vagrant@iscsi-server:~$
~~~

### Crea un target con una LUN y conéctala a un cliente GNU/Linux. Explica cómo escaneas desde el cliente buscando los targets disponibles y utiliza la unidad lógica proporcionada, formateándola si es necesario y montándola.
En este caso crearemos un target (`ejercicio1`) y le añadiremos un nuevo disco o `LUN` (`sdb`), por último, lo activaremos para que los clientes tengan acceso a el:
~~~
#----- Creación del target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2020-01.org.jesus:ejercicio1

#----- Añadido de una LUN al target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /dev/sdb

#----- Activación del target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL

#----- Comprobación -----#
root@iscsi-server:~# tgtadm --lld iscsi --op show --mode target
Target 1: iqn.2020-01.org.jesus:ejercicio1
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags: 
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 524 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: rdwr
            Backing store path: /dev/sdb
            Backing store flags: 
    Account information:
    ACL information:
        ALL
root@iscsi-server:~# 

# Nota: Como podemos apreciar, el target contiene 2 LUN, una es el disco que acabamos de añadir y la otra es la controladora del target.
~~~

Con el target creado ya podemos acceder a el desde el cliente, primero realizaremos un scaneo para ver la lista de targets disponibles y luego montaremos el target creado anteriormente.
Por último, daremos formato y uso al disco:
~~~
#----- Scaneo -----#
root@iscsi-client:~# iscsiadm --mode discovery --type sendtargets --portal 192.168.1.10
192.168.1.10:3260,1 iqn.2020-01.org.jesus:ejercicio1
root@iscsi-client:~#

#----- Montaje del target -----#
root@iscsi-client:~# iscsiadm --mode node --targetname iqn.2020-01.org.jesus:ejercicio1 --portal 192.168.1.10 --login
Logging in to [iface: default, target: iqn.2020-01.org.jesus:ejercicio1, portal: 192.168.1.10,3260] (multiple)
Login to [iface: default, target: iqn.2020-01.org.jesus:ejercicio1, portal: 192.168.1.10,3260] successful.
root@iscsi-client:~# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 19.8G  0 disk 
├─sda1   8:1    0 18.8G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1021M  0 part [SWAP]
sdb      8:16   0  500M  0 disk 
root@iscsi-client:~#

#---- Formateo y utilización del target -----#
root@iscsi-client:~# mkfs.ext4 /dev/sdb
mke2fs 1.44.5 (15-Dec-2018)
Creating filesystem with 512000 1k blocks and 128016 inodes
Filesystem UUID: 01226903-6147-490a-9eb6-2f7960ddea0d
Superblock backups stored on blocks: 
	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done 

root@iscsi-client:~# mount /dev/sdb /mnt
root@iscsi-client:~# cd /mnt
root@iscsi-client:/mnt# mkdir -p dprueba1/dprueba2
root@iscsi-client:/mnt# touch prueba1.txt
root@iscsi-client:/mnt# ls -l
total 13
drwxr-xr-x 3 root root  1024 Feb  5 08:31 dprueba1
drwx------ 2 root root 12288 Feb  5 08:31 lost+found
-rw-r--r-- 1 root root     0 Feb  5 08:31 prueba1.txt
root@iscsi-client:/mnt# 
~~~

### Utiliza systemd mount para que el target se monte automáticamente al arrancar el cliente.
Ya que para montar el target es necesario hacer un login en servidor, el primer paso será automatizar este proceso:
~~~
root@iscsi-client:~# iscsiadm --mode node --targetname iqn.2020-01.org.jesus:ejercicio1 --portal 192.168.1.10 -o update -n node.startup -v automatic
~~~

Una vez hecho, crearemos la unidad de montaje en systemd (`/etc/systemd/system/mnt-target.mount`):
~~~
# iscsi.mount
[Unit]
Description=Target ISCSI

[Mount]
What=/dev/sdb
Where=/mnt
Options=_netdev

[Install]
WantedBy=multi-user.target
~~~

Con las unidades creadas, reiniciamos los demonios y las habilitamos en el arranque:
~~~
root@iscsi-client:/etc/systemd/system# systemctl daemon-reload
root@iscsi-client:/etc/systemd/system# systemctl enable mnt-target.mount
Created symlink /etc/systemd/system/multi-user.target.wants/mnt-target.mount → /etc/systemd/system/mnt-target.mount.
root@iscsi-client:/etc/systemd/system# 
~~~

Por último, reiniciamos la máquina y comprobamos si se ha montado automáticamente:
~~~
root@iscsi-client:~# reboot
root@iscsi-client:~# Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.
jesus@jesus:~/Documentos/ASIR/Vagrant/ASO/ISCSI$ vagrant ssh iscsi_client
Linux iscsi-client 4.19.0-6-amd64 #1 SMP Debian 4.19.67-2+deb10u2 (2019-11-11) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Feb  5 18:35:49 2020 from 10.0.2.2
vagrant@iscsi-client:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 19.8G  0 disk 
├─sda1   8:1    0 18.8G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1021M  0 part [SWAP]
sdb      8:16   0  500M  0 disk /mnt/target
vagrant@iscsi-client:~$ sudo su -
root@iscsi-client:~# cd /mnt/target
root@iscsi-client:/mnt/target# touch prueba2.txt
root@iscsi-client:/mnt/target# touch prueba3.txt
root@iscsi-client:/mnt/target# ls -l
total 13
drwxr-xr-x 3 root root  1024 Feb  5 08:31 dprueba1
drwx------ 2 root root 12288 Feb  5 08:31 lost+found
-rw-r--r-- 1 root root     0 Feb  5 08:31 prueba1.txt
-rw-r--r-- 1 root root     0 Feb  5 18:37 prueba2.txt
-rw-r--r-- 1 root root     0 Feb  5 18:37 prueba3.txt
root@iscsi-client:/mnt/target#
~~~

### Crea un target con 2 LUN y autenticación por CHAP y conéctala a un cliente windows. Explica cómo se escanea la red en windows y cómo se utilizan las unidades nuevas (formateándolas con NTFS).
En este caso crearemos un target (`ejercicio2`) igual que hemos hecho anteriormente, solo que en este caso estará compuesto de 2 LUNs (`sdc` y `sdd`) y contará con autenticación:
~~~
#----- Creación del target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2020-01.org.jesus:ejercicio2

#----- Creación de la cuenta para la autenticación -----#
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode account --user jesus --password jesusgarciamun

#----- Asignación de la cuenta al target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op bind --mode account --tid 1 --user jesus

#----- Añadido de las distintas LUN -----#
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /dev/sdc
root@iscsi-server:~# tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 2 -b /dev/sdd

#----- Activación del target -----#
root@iscsi-server:~# tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL

#----- Comprobación -----#
root@iscsi-server:~# tgtadm --lld iscsi --op show --mode target
Target 1: iqn.2020-01.org.jesus:ejercicio2
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags: 
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 524 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: rdwr
            Backing store path: /dev/sdc
            Backing store flags: 
        LUN: 2
            Type: disk
            SCSI ID: IET     00010002
            SCSI SN: beaf12
            Size: 524 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: rdwr
            Backing store path: /dev/sdd
            Backing store flags: 
    Account information:
        jesus
    ACL information:
        ALL
root@iscsi-server:~# 
~~~

Ahora, montaremos el target desde el cliente Windows



Accedemos a **Herramientas administrativas** y lanzamos **Iniciador ISCSI**: 1

En la pestaña **Detección** seleccionamos **Detectar portal...** e indicamos los datos del servidor: 2-3

Una vez configurada la conexión, en la pestaña **Destinos** aparecerán los targets disponibles, nos conectamos y, en **Opciones Avanzadas** habilitamos el inicio de sesión CHAP e indicamos nuestras credenciales: 4-5

Con esto, los discos ya se encuentran en el sistema por lo que podemos darle formato y utilizarlos: 6-8
