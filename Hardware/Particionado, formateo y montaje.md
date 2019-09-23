# Esquema Windows.
- Disco duro: 1 GB
- Partición primaria: 1 GB, Formato NTFS, Etiqueta "WXP", Letra Z
- Redimensión: Partición primaria de 1024 MB a 512 MB
- Partición primaria: 256 MB, Formato FAT32, Etiqueta "Datos", Letra Y
- Partición primaria: 256 MB, Formato NTFS, Letra X


### Formateo con diskpart.
Creación y formateo de la partición primaria.
~~~
Microsoft DiskPart versión 6.1.7600
Copyright (C) 1999-2008 Microsoft Corporation.
En el equipo: JESUS-PC

DISKPART> list disk

  Núm Disco  Estado      Tamaño   Disp     Din  Gpt
  ---------- ----------  -------  -------  ---  ---
  Disco 0    En línea      32 GB      0 B
  Disco 1    En línea     800 MB   199 MB
  Disco 2    En línea    1024 MB  1022 MB

DISKPART> select disk 2

El disco 2 es ahora el disco seleccionado.

DISKPART> create partition primary

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> list partition
  
  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
* Partición 1    Principal         1022 MB    64 KB

DISKPART> format fs=ntfs label=WXP

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART> assign letter=Z

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART> shrink desired=510
~~~


Reducción de tamaño de la partición primaria.
~~~
DISKPART> shrink desired=510

DiskPart redujo correctamente el volumen en:  510 MB

DISKPART> list partition

  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
* Partición 1    Principal          512 MB    64 KB

DISKPART> create partition primary size=256
~~~


Creación y formateo del resto de particiones primarias.
~~~
DISKPART> create partition primary size=256

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> list partition

  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
  Partición 1    Principal          512 MB    64 KB
* Partición 2    Principal          256 MB   513 MB

DISKPART> format fs=FAT32 label=Datos

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART> assign letter=Y

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART> create partition primary

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> list partition

  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
  Partición 1    Principal          512 MB    64 KB
  Partición 2    Principal          256 MB   513 MB
* Partición 3    Principal          254 MB   769 MB

DISKPART> format fs=ntfs

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART> assign letter=X

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART>
~~~


# Esquema Linux.
- Disco duro: 1 GB
- Partición primaria: 256 MB, Formato NTFS
- Partición extendida: 768 MB
- Partición lógica: 192 MB, Formato EXT3, Montaje /mnt.
- Partición lógica: 512 MB, Formato SWAP
- Partición lógica: Formato FAT32, Montaje "/home/jesus/compartido"


### Formateo con fdisk.
Creación de la partición primaria.
~~~
root@debian:~# fdisk /dev/sdc

Bienvenido a fdisk (util-linux 2.29.2).
Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
Tenga cuidado antes de utilizar la orden de escritura.

El dispositivo no contiene una tabla de particiones reconocida.
Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0x550d9f83.

Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (0 primaria(s), 0 extendida(s), 4 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): p	
Número de partición (1-4, valor predeterminado 1):    
Primer sector (2048-2097151, valor predeterminado 2048): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): +256M

Crea una nueva partición 1 de tipo 'Linux' y de tamaño 256 MiB.

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
Tipo de partición (teclee L para ver todos los tipos): 7
Se ha cambiado el tipo de la partición 'Linux' a 'HPFS/NTFS/exFAT'.

Orden (m para obtener ayuda):
~~~


Creación de las distintas particiones logicas.
~~~
Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (1 primaria(s), 0 extendida(s), 3 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): e
Número de partición (2-4, valor predeterminado 2): 
Primer sector (526336-2097151, valor predeterminado 526336): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (526336-2097151, valor predeterminado 2097151): 

Crea una nueva partición 2 de tipo 'Extended' y de tamaño 767 MiB.

Orden (m para obtener ayuda): n
Se está utilizando todo el espacio para particiones primarias.
Se añade la partición lógica 5
Primer sector (528384-2097151, valor predeterminado 528384): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (528384-2097151, valor predeterminado 2097151): +192M

Crea una nueva partición 5 de tipo 'Linux' y de tamaño 192 MiB.

Orden (m para obtener ayuda): n
Se está utilizando todo el espacio para particiones primarias.
Se añade la partición lógica 6
Primer sector (923648-2097151, valor predeterminado 923648): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (923648-2097151, valor predeterminado 2097151): +512M

Crea una nueva partición 6 de tipo 'Linux' y de tamaño 512 MiB.

Orden (m para obtener ayuda): t
Número de partición (1,2,5,6, valor predeterminado 6): 6
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
Tipo de partición (teclee L para ver todos los tipos): 82

Se ha cambiado el tipo de la partición 'Linux' a 'Linux swap / Solaris'.

Orden (m para obtener ayuda): n
Se está utilizando todo el espacio para particiones primarias.
Se añade la partición lógica 7
Primer sector (1974272-2097151, valor predeterminado 1974272): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (1974272-2097151, valor predeterminado 2097151): 

Crea una nueva partición 7 de tipo 'Linux' y de tamaño 60 MiB.

Orden (m para obtener ayuda): t
Número de partición (1,2,5-7, valor predeterminado 7): 7
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
Tipo de partición (teclee L para ver todos los tipos): b

Se ha cambiado el tipo de la partición 'Linux' a 'W95 FAT32'.

Orden (m para obtener ayuda): w
Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.

root@debian:~#
~~~


Formateo y montaje de las distintas particiones.
~~~
root@debian:~# mkfs.ntfs /dev/sdc1
Cluster size has been automatically set to 4096 bytes.
Initializing device with zeroes: 100% - Done.
Creating NTFS volume structures.
mkntfs completed successfully. Have a nice day.
root@debian:/home/jesus# mkfs.ext3 /dev/sdc5
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 196608 bloques de 1k y 49152 nodos-i
UUID del sistema de ficheros: e66b4957-b8fb-4430-931a-973142612a53
Respaldo del superbloque guardado en los bloques: 
	8193, 24577, 40961, 57345, 73729

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

root@debian:/home/jesus# mount /dev/sdc5 /mnt
root@debian:/home/jesus# mkswap /dev/sdc6
Configurando espacio de intercambio versión 1, tamaño = 512 MiB (536866816 bytes)
sin etiqueta, UUID=cc692027-ed22-4dcd-a44f-303fd206a9f8
root@debian:/home/jesus# mkfs.vfat /dev/sdc7
mkfs.fat 4.1 (2017-01-24)
root@debian:/home/jesus# mount /dev/sdc7 /home/jesus/compartido
root@debian:/home/jesus# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sda                                                      
├─sda1 ext4         9bb748be-c081-4450-8a0e-51903495fc92 /
├─sda2                                                   
└─sda5 swap         bff0697e-82c1-4182-bd1c-cac74dd0e016 [SWAP]
sdb                                                      
└─sdb1 ext4         95e95c59-d8ab-4af0-9da4-a31ef54f5037 /mnt/QUOTA
sdc                                                      
├─sdc1 ntfs         563E32A61E693BB5                     
├─sdc2                                                   
├─sdc5 ext3         e66b4957-b8fb-4430-931a-973142612a53 /mnt
├─sdc6 swap         cc692027-ed22-4dcd-a44f-303fd206a9f8 
└─sdc7 vfat         5A83-8C3B                            /home/jesus/compartido
sr0                                                      
root@debian:~# 
~~~