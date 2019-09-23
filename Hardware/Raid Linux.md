### Esquema 1.
- Raid 1.
- 2 discos de 1 GB.


Creación de la partición primaria con identificador Linux Raid Autodetect en el primer disco.
~~~
root@debian:~# fdisk /dev/sdb

Bienvenido a fdisk (util-linux 2.29.2).
Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
Tenga cuidado antes de utilizar la orden de escritura.

El dispositivo no contiene una tabla de particiones reconocida.
Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0x7348224d.

Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (0 primaria(s), 0 extendida(s), 4 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): p
Número de partición (1-4, valor predeterminado 1): 
Primer sector (2048-2097151, valor predeterminado 2048): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): 

Crea una nueva partición 1 de tipo 'Linux' y de tamaño 1023 MiB.

Orden (m para obtener ayuda): t
Se ha seleccionado la partición 1
Tipo de partición (teclee L para ver todos los tipos): l

 0  Vacía           24  DOS de NEC      81  Minix / Linux a bf  Solaris        
 1  FAT12           27  NTFS de WinRE o 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 oculto o h c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extendida c7  Syrinx         
 5  Extendida       41  PPC PReP Boot   86  Conjunto de vol da  Datos sin SF   
 6  FAT16           42  SFS             87  Conjunto de vol db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Utilidad Dell  
 8  AIX             4e  QNX4.x segunda  8e  Linux LVM       df  BootIt         
 9  AIX arrancable  4f  QNX4.x tercera  93  Amoeba          e1  DOS access     
 a  Gestor de arran 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  Hibernación de  ea  alineamiento Ru
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
11  FAT12 oculta    56  Golden Bow      a8  UFS de Darwin   f0  inicio Linux/PA
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
14  FAT16 oculta <3 61  SpeedStor       ab  arranque de Dar f4  SpeedStor      
16  FAT16 oculta    63  GNU HURD o SysV af  HFS / HFS+      f2  DOS secondary  
17  HPFS/NTFS ocult 64  Novell Netware  b7  BSDI fs         fb  VMFS de VMware 
18  SmartSleep de A 65  Novell Netware  b8  BSDI swap       fc  VMKCORE de VMwa
1b  FAT32 de W95 oc 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
1c  FAT32 de W95 (L 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
1e  FAT16 de W95 (L 80  Minix antiguo   be  arranque de Sol ff  BBT            
Tipo de partición (teclee L para ver todos los tipos): fd
Se ha cambiado el tipo de la partición 'Linux' a 'Linux raid autodetect'.

Orden (m para obtener ayuda): w
Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.

root@debian:~# 
~~~


Copia de la tabla de particiones al segundo disco.
~~~
root@debian:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Comprobando que nadie esté utilizando este disco en este momento... Correcto

Disco /dev/sdc: 8 GiB, 8589934592 bytes, 16777216 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes

>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0x7348224d.
/dev/sdc1: Crea una nueva partición 1 de tipo 'Linux raid autodetect' y de tamaño 1023 MiB.
/dev/sdc2: Hecho.

Situación nueva:

Disposit.  Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/sdc1             2048 2097151  2095104  1023M fd Linux raid autodetect

Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.
root@debian:/home/jesus# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sda                                                      
├─sda1 ext4         9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                   
└─sda5 swap         bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                      
└─sdb1                                                   
sdc                                                      
└─sdc1                                                                                                       
sr0                                                      
root@debian:~# 
~~~


Creación del raid md1.
~~~
root@debian:~# mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@debian:/home/jesus# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1                                                                 
sdc                                                                     
└─sdc1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1                                                                                                                                    
sr0                                                                     
root@debian:~# 	
~~~


Comprobación de las características del raid (Capacidad: 1072 MB).
~~~
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 19:40:49 2018
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
root@debian:~# 
~~~


Formateo en ext3 y montaje del raid en /mnt/raid1.
~~~
root@debian:~# mkfs.ext3 /dev/md1
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 261744 bloques de 4k y 65536 nodos-i
UUID del sistema de ficheros: 87b63337-a49b-4200-b241-1fbc2162e494
Respaldo del superbloque guardado en los bloques: 
	32768, 98304, 163840, 229376

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

root@debian:/home/jesus# mount /dev/md1 /mnt/raid1
root@debian:/home/jesus# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1 ext3                       87b63337-a49b-4200-b241-1fbc2162e494 /mnt/raid1
sdc                                                                     
└─sdc1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1 ext3                       87b63337-a49b-4200-b241-1fbc2162e494 /mnt/raid1
sdd                                                                     
sde                                                                     
sdf                                                                     
sdg                                                                     
sr0                                                                     
root@debian:~# 
~~~


Marcar como estropeado uno de los discos del raid (El directorio montado sigue funcionando correctamente).
~~~
root@debian:~# mdadm /dev/md1 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 19:55:45 2018
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 49

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       2       8       17        -      faulty   /dev/sdb1
root@debian:/mnt/raid1# 
                                          
root@debian:~# cd /mnt/raid1
root@debian:/mnt/raid1# touch prueba
root@debian:/mnt/raid1# ls
prueba  lost+found
root@debian:/mnt/raid1#
~~~


Retirada del disco estropeado.
~~~
root@debian:~# mdadm /dev/md1 --remove /dev/sdb1
mdadm: hot removed /dev/sdb1 from /dev/md1
root@debian:~# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
sdc                                                                     
└─sdc1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1 ext3                       87b63337-a49b-4200-b241-1fbc2162e494 /mnt/raid1
sdd                                                                     
sde                                                                     
sdf                                                                     
sdg                                                                     
sr0                                                                     
root@debian:/mnt/raid1# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 19:57:32 2018
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 50

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
root@debian:~#
~~~


Añadir un nuevo disco al raid.
~~~
root@debian:~# mdadm /dev/md1 --add /dev/sdd1
mdadm: added /dev/sdd1
root@debian:~# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
sdc                                                                     
└─sdc1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1 ext3                       87b63337-a49b-4200-b241-1fbc2162e494 /mnt/raid1
sdd                                                                     
└─sdd1  linux_raid_member debian:1 c44d244d-84db-03b8-be3b-7ebd7a1b3f3c 
  └─md1 ext3                       87b63337-a49b-4200-b241-1fbc2162e494 /mnt/raid1
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 20:06:58 2018
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 73

    Number   Major   Minor   RaidDevice State
       2       8       49        0      active sync   /dev/sdd1
       1       8       33        1      active sync   /dev/sdc1
root@debian:~#
~~~


Añadir un disco de reserva, marcar un disco como estropeado y comprobar la sincronización entre discos.
~~~
root@debian:~# mdadm /dev/md1 -a /dev/sdb1
mdadm: added /dev/sdb1
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 20:08:28 2018
          State : clean 
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 74

    Number   Major   Minor   RaidDevice State
       2       8       49        0      active sync   /dev/sdd1
       1       8       33        1      active sync   /dev/sdc1

       3       8       17        -      spare   /dev/sdb1
root@debian:~# mdadm /dev/md1 -f /dev/sdd1
mdadm: set /dev/sdd1 faulty in /dev/md1
root@debian:/mnt/raid1# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 20:09:07 2018
          State : clean, degraded, recovering 
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1

 Rebuild Status : 49% complete

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 83

    Number   Major   Minor   RaidDevice State
       3       8       17        0      spare rebuilding   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

       2       8       49        -      faulty   /dev/sdd1
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 19:40:44 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 2
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 20:09:10 2018
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : c44d244d:84db03b8:be3b7ebd:7a1b3f3c
         Events : 93

    Number   Major   Minor   RaidDevice State
       3       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

       2       8       49        -      faulty   /dev/sdd1
root@debian:~#
~~~


Creación del raid con 3 discos (La capacidad del raid sigue siendo 1072 MB, ya que la información se copia en todos los discos, al menos uno de los discos debe estar funcionando correctamente para así poder copiar la información al resto de discos).
~~~
root@debian:~# mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Mar  5 20:25:39 2018
     Raid Level : raid1
     Array Size : 1046976 (1022.44 MiB 1072.10 MB)
  Used Dev Size : 1046976 (1022.44 MiB 1072.10 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 20:25:45 2018
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : debian:1  (local to host debian)
           UUID : a1aba2dc:aa5242ac:8e83aecb:029e1d91
         Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
root@debian:~#
~~~


### Esquema 2.
- Raid 5.
- 3 discos de 1 GB.


Creación de la partición primaria con identificador Linux Raid Autodetect en el primer disco.
~~~
root@debian:~# fdisk /dev/sdb

Bienvenido a fdisk (util-linux 2.29.2).
Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
Tenga cuidado antes de utilizar la orden de escritura.

El dispositivo no contiene una tabla de particiones reconocida.
Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0xf2f2fe2a.

Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (0 primaria(s), 0 extendida(s), 4 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): p
Número de partición (1-4, valor predeterminado 1): 
Primer sector (2048-2097151, valor predeterminado 2048): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): 

Crea una nueva partición 1 de tipo 'Linux' y de tamaño 1023 MiB.

Orden (m para obtener ayuda): t
Se ha seleccionado la partición 1
Tipo de partición (teclee L para ver todos los tipos): l

 0  Vacía           24  DOS de NEC      81  Minix / Linux a bf  Solaris        
 1  FAT12           27  NTFS de WinRE o 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 oculto o h c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extendida c7  Syrinx         
 5  Extendida       41  PPC PReP Boot   86  Conjunto de vol da  Datos sin SF   
 6  FAT16           42  SFS             87  Conjunto de vol db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Utilidad Dell  
 8  AIX             4e  QNX4.x segunda  8e  Linux LVM       df  BootIt         
 9  AIX arrancable  4f  QNX4.x tercera  93  Amoeba          e1  DOS access     
 a  Gestor de arran 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  Hibernación de  ea  alineamiento Ru
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
11  FAT12 oculta    56  Golden Bow      a8  UFS de Darwin   f0  inicio Linux/PA
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
14  FAT16 oculta <3 61  SpeedStor       ab  arranque de Dar f4  SpeedStor      
16  FAT16 oculta    63  GNU HURD o SysV af  HFS / HFS+      f2  DOS secondary  
17  HPFS/NTFS ocult 64  Novell Netware  b7  BSDI fs         fb  VMFS de VMware 
18  SmartSleep de A 65  Novell Netware  b8  BSDI swap       fc  VMKCORE de VMwa
1b  FAT32 de W95 oc 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
1c  FAT32 de W95 (L 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
1e  FAT16 de W95 (L 80  Minix antiguo   be  arranque de Sol ff  BBT            
Tipo de partición (teclee L para ver todos los tipos): fd
Se ha cambiado el tipo de la partición 'Linux' a 'Linux raid autodetect'.

Orden (m para obtener ayuda): w
Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.

root@debian:~#
~~~


Copia de la tabla de particiones al segundo y al tercer disco.
~~~
root@debian:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Comprobando que nadie esté utilizando este disco en este momento... Correcto

Disco /dev/sdc: 1 GiB, 1073741824 bytes, 2097152 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes

>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0xf2f2fe2a.
/dev/sdc1: Crea una nueva partición 1 de tipo 'Linux raid autodetect' y de tamaño 1023 MiB.
/dev/sdc2: Hecho.

Situación nueva:

Disposit.  Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/sdc1             2048 2097151  2095104  1023M fd Linux raid autodetect

Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.
root@debian:~# sfdisk -d /dev/sdb | sfdisk /dev/sdd
Comprobando que nadie esté utilizando este disco en este momento... Correcto

Disco /dev/sdd: 1 GiB, 1073741824 bytes, 2097152 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes

>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Cabecera del script aceptada.
>>> Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0xf2f2fe2a.
/dev/sdd1: Crea una nueva partición 1 de tipo 'Linux raid autodetect' y de tamaño 1023 MiB.
/dev/sdd2: Hecho.

Situación nueva:

Disposit.  Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/sdd1             2048 2097151  2095104  1023M fd Linux raid autodetect

Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.
root@debian:~# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sda                                                      
├─sda1 ext4         9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                   
└─sda5 swap         bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                      
└─sdb1                                                   
sdc                                                      
└─sdc1                                                   
sdd                                                      
└─sdd1                                                   
sde                                                      
sdf                                                      
sr0                                                      
root@debian:~# 

~~~


Creación del raid md5.
~~~
root@debian:~# mdadm --create /dev/md5 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md5 started.
root@debian:~# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5                                                                 
sdc                                                                     
└─sdc1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5                                                                 
sdd                                                                     
└─sdd1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5                                                                 
sde                                                                     
sdf                                                                     
sr0                                                                     
root@debian:~# 
~~~


Comprobación de las características del raid (Capacidad: 2143 MB).
~~~
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:35:15 2018
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
root@debian:~#
~~~


Formateo en ext3 y montaje del raid en /mnt/raid5.
~~~
root@debian:~# mkfs.ext3 /dev/md5
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 523264 bloques de 4k y 130816 nodos-i
UUID del sistema de ficheros: 8252099c-8a01-49b9-8fdf-0b1380640f4f
Respaldo del superbloque guardado en los bloques: 
	32768, 98304, 163840, 229376, 294912

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (8192 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

root@debian:~# mount /dev/md5 /mnt/raid5
root@debian:~# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5 ext3                       8252099c-8a01-49b9-8fdf-0b1380640f4f /mnt/raid5
sdc                                                                     
└─sdc1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5 ext3                       8252099c-8a01-49b9-8fdf-0b1380640f4f /mnt/raid5
sdd                                                                     
└─sdd1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5 ext3                       8252099c-8a01-49b9-8fdf-0b1380640f4f /mnt/raid5
sde                                                                     
sdf                                                                     
sr0                                                                     
root@debian:~# 
~~~


Marcar como estropeado uno de los discos del raid (El directorio montado sigue funcionando correctamente).
~~~
root@debian:/mnt/raid5# touch prueba1
root@debian:/mnt/raid5# ls
lost+found  prueba1
root@debian:/mnt/raid5# mdadm /dev/md5 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md5
root@debian:/mnt/raid5# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:39:30 2018
          State : clean, degraded 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 20

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       0       8       17        -      faulty   /dev/sdb1
root@debian:/mnt/raid5# touch prueba2
root@debian:/mnt/raid5# ls
lost+found  prueba1  prueba2
root@debian:/mnt/raid5# 

~~~


Retirada del disco estropeado.
~~~
root@debian:~# mdadm /dev/md5 --remove /dev/sdb1 
mdadm: hot removed /dev/sdb1 from /dev/md5
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:40:39 2018
          State : clean, degraded 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 27

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
root@debian:~# lsblk -f
NAME    FSTYPE            LABEL    UUID                                 MOUNTPOINT
sda                                                                     
├─sda1  ext4                       9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                                  
└─sda5  swap                       bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                                     
└─sdb1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
sdc                                                                     
└─sdc1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5 ext3                       8252099c-8a01-49b9-8fdf-0b1380640f4f /mnt/raid5
sdd                                                                     
└─sdd1  linux_raid_member debian:5 551d339f-309b-1fac-ef18-b70d2e0b0778 
  └─md5 ext3                       8252099c-8a01-49b9-8fdf-0b1380640f4f /mnt/raid5
sde                                                                     
sdf                                                                     
sr0                                                                     
root@debian:~# 
~~~


Añadir un nuevo disco y comprobar su sincronización.
~~~
root@debian:~# mdadm /dev/md5 --add /dev/sde1
mdadm: added /dev/sde1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:44:29 2018
          State : clean, degraded, recovering 
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 33% complete

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 29

    Number   Major   Minor   RaidDevice State
       4       8       65        0      spare rebuilding   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:44:36 2018
          State : clean, degraded, recovering 
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 87% complete

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 42

    Number   Major   Minor   RaidDevice State
       4       8       65        0      spare rebuilding   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:44:37 2018
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 46

    Number   Major   Minor   RaidDevice State
       4       8       65        0      active sync   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
root@debian:~# 
~~~


Añadir un disco de reserva, marcar un disco como estropeado y comprobar la sincronización entre discos.
~~~
root@debian:~# mdadm /dev/md5 -a /dev/sdb1
mdadm: added /dev/sdb1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:47:25 2018
          State : clean 
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 47

    Number   Major   Minor   RaidDevice State
       4       8       65        0      active sync   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       5       8       17        -      spare   /dev/sdb1
root@debian:~# mdadm /dev/md5 -f /dev/sde1
mdadm: set /dev/sde1 faulty in /dev/md5
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:53:58 2018
          State : clean, degraded, recovering 
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 9% complete

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 50

    Number   Major   Minor   RaidDevice State
       5       8       17        0      spare rebuilding   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       4       8       65        -      faulty   /dev/sde1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:54:02 2018
          State : clean, degraded, recovering 
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 53% complete

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 57

    Number   Major   Minor   RaidDevice State
       5       8       17        0      spare rebuilding   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       4       8       65        -      faulty   /dev/sde1
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 16:35:05 2018
     Raid Level : raid5
     Array Size : 2093056 (2044.00 MiB 2143.29 MB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 16:54:07 2018
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 551d339f:309b1fac:ef18b70d:2e0b0778
         Events : 66

    Number   Major   Minor   RaidDevice State
       5       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       4       8       65        -      faulty   /dev/sde1
root@debian:~# 
~~~


Creación del raid con 4 discos (La capacidad del raid ahora es de 3.21 GB, al menos uno de los discos debe estar funcionando correctamente para así poder reconstruir la información del resto de discos).
~~~
root@debian:~# mdadm --create /dev/md5 --level=5 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md5 started.
root@debian:~# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Mar  6 17:09:43 2018
     Raid Level : raid5
     Array Size : 3139584 (2.99 GiB 3.21 GB)
  Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Mar  6 17:09:54 2018
          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : debian:5  (local to host debian)
           UUID : 90387cfa:06cb9a20:e8c5a564:c2427e07
         Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       4       8       65        3      active sync   /dev/sde1
root@debian:~# 
~~~