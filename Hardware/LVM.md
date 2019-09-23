### Esquema 1.
- 3 discos de 500 MB.
- Grupo de volumenes vg1
- Volumen lógico primer-lv, Formato ext4


Definición de los discos como dispositivos físicos.
~~~
root@debian:~# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
root@debian:~# pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
root@debian:~# pvcreate /dev/sdd
  Physical volume "/dev/sdd" successfully created.
root@debian:~# lsblk -f
NAME   FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                             
├─sda1 ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                          
└─sda5 swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb    LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
sdc    LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
sdd    LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
sde                                                             
sdf                                                             
sdg                                                             
sr0                                                             
root@debian:~#
~~~


Creación del grupo de volúmenes vg1 con los dos primeros discos.
~~~
root@debian:~# vgcreate vg1 /dev/sdb /dev/sdc
  Volume group "vg1" successfully created
root@debian:~# vgdisplay vg1
  --- Volume group ---
  VG Name               vg1
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               992,00 MiB
  PE Size               4,00 MiB
  Total PE              248
  Alloc PE / Size       0 / 0   
  Free  PE / Size       248 / 992,00 MiB
  VG UUID               NRAr6y-Rxt8-YB58-UML6-PbtQ-f9R4-eT53qy
   
root@debian:~# 
~~~


Creación del volumen lógico primer-lv de 700MB en vg1.
~~~
root@debian:~# lvcreate --size 700m -n primer-lv vg1
  Logical volume "primer-lv" created.
root@debian:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg1/primer-lv
  LV Name                primer-lv
  VG Name                vg1
  LV UUID                TLxQy9-T6Ue-4Orh-3Rn3-QDGV-IOAc-QpycmI
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 17:53:47 +0100
  LV Status              available
  # open                 0
  LV Size                700,00 MiB
  Current LE             175
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0
   
root@debian:~#
~~~


Formateo de primer-lv con ext3.
~~~
root@debian:~# mkfs.ext3 /dev/mapper/vg1-primer--lv 
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 179200 bloques de 4k y 44832 nodos-i
UUID del sistema de ficheros: b4941efc-8dda-416c-b0c2-54f1aa3a8726
Respaldo del superbloque guardado en los bloques: 
	32768, 98304, 163840

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros:    
hecho

root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sde                                                            
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# 

~~~


Montaje de primer-lv en /mnt.
~~~
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sde                                                            
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# 
~~~


Añadir el tercer disco al volumen físico vg1.
~~~
root@debian:~# vgextend vg1 /dev/sdd
  Volume group "vg1" successfully extended
root@debian:~# vgdisplay
  --- Volume group ---
  VG Name               vg1
  System ID             
  Format                lvm2
  Metadata Areas        3
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                3
  Act PV                3
  VG Size               1,45 GiB
  PE Size               4,00 MiB
  Total PE              372
  Alloc PE / Size       175 / 700,00 MiB
  Free  PE / Size       197 / 788,00 MiB
  VG UUID               NRAr6y-Rxt8-YB58-UML6-PbtQ-f9R4-eT53qy
   
root@debian:~# 
~~~


Redimensión de primer-lv a 1.2 GB.
~~~         
root@debian:~# lvresize -L+500M /dev/mapper/vg1-primer--lv 
  Size of logical volume vg1/primer-lv changed from 700,00 MiB (175 extents) to 1,17 GiB (300 extents).
  Logical volume vg1/primer-lv successfully resized.
root@debian:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg1/primer-lv
  LV Name                primer-lv
  VG Name                vg1
  LV UUID                TLxQy9-T6Ue-4Orh-3Rn3-QDGV-IOAc-QpycmI
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 17:53:47 +0100
  LV Status              available
  # open                 1
  LV Size                1,17 GiB
  Current LE             300
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0
   
root@debian:~# 
~~~


### Esquema 2.
- 1 disco de 100 MB.
- Grupo de volúmenes vg2.
- Volumen lógico, Capacidad 48 MB, Formato ext3.
- Volumen lógico, Capacidad 48 MB, Formato xfs.


Creación del grupo de volúmenes vg2.
~~~
root@debian:~# vgcreate vg2 /dev/sde
  Physical volume "/dev/sde" successfully created.
  Volume group "vg2" successfully created
root@debian:~# vgdisplay vg2
  --- Volume group ---
  VG Name               vg2
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               96,00 MiB
  PE Size               4,00 MiB
  Total PE              24
  Alloc PE / Size       0 / 0   
  Free  PE / Size       24 / 96,00 MiB
  VG UUID               N3hpnl-60lb-8AEa-etD5-EEui-6xYt-BLJutw
   
root@debian:~# 
~~~


Creación, formateo y montaje del primer volumen lógico.
~~~
root@debian:~# lvcreate --size 48m -n segundo-lv vg2
  Logical volume "segundo-lv" created.
root@debian:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg1/primer-lv
  LV Name                primer-lv
  VG Name                vg1
  LV UUID                TLxQy9-T6Ue-4Orh-3Rn3-QDGV-IOAc-QpycmI
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 17:53:47 +0100
  LV Status              available
  # open                 1
  LV Size                1,17 GiB
  Current LE             300
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0
   
  --- Logical volume ---
  LV Path                /dev/vg2/segundo-lv
  LV Name                segundo-lv
  VG Name                vg2
  LV UUID                pMMNrn-cGQP-RD8Y-BjNB-a7Ci-20dS-HqW3hY
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 18:55:43 +0100
  LV Status              available
  # open                 0
  LV Size                48,00 MiB
  Current LE             12
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1
 
root@debian:~# mkfs.ext3 /dev/mapper/vg2-segundo--lv 
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 49152 bloques de 1k y 12288 nodos-i
UUID del sistema de ficheros: 86d6d11a-c602-465a-9302-c21eb141bf93
Respaldo del superbloque guardado en los bloques: 
	8193, 24577, 40961

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
└─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93                                                             
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# mount /dev/mapper/vg2-segundo--lv /mnt/segundo-lv
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
└─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   /mnt/segundo-lv
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# touch prueba /mnt/segundo-lv
root@debian:~# ls /mnt/segundo-lv
prueba	lost+found
root@debian:~#
~~~


Creación, formateo y montaje del segundo volumen lógico.
~~~
root@debian:~# lvcreate --size 48m -n tercer-lv vg2
  Logical volume "tercer-lv" created.
root@debian:~# mkfs.ext3 /dev/mapper/vg2-tercer--lv 
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 49152 bloques de 1k y 12288 nodos-i
UUID del sistema de ficheros: 92d8f630-7b2b-4f97-8acc-07136d7d9acf
Respaldo del superbloque guardado en los bloques: 
	8193, 24577, 40961

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   /mnt/segundo-lv
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# mount /dev/mapper/vg2-tercer--lv /mnt/tercer-lv/
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   /mnt
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   /mnt/segundo-lv
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   /mnt/tercer-lv
sdf                                                                        
sdg                                                                        
sr0                                                                        
root@debian:~# touch prueba2 /mnt/tercer-lv
root@debian:~# ls /mnt/tercer-lv
prueba2		lost+found
root@debian:~#
~~~


Redimensión de ambos discos a 96 MB.
~~~
root@debian:~# vgextend /dev/vg2 /dev/sdg
  Physical volume "/dev/sdg" successfully created.
  Volume group "vg2" successfully extended
root@debian:~# vgdisplay vg2
  --- Volume group ---
  VG Name               vg2
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  12
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               192,00 MiB
  PE Size               4,00 MiB
  Total PE              48
  Alloc PE / Size       24 / 96,00 MiB
  Free  PE / Size       24 / 96,00 MiB
  VG UUID               N3hpnl-60lb-8AEa-etD5-EEui-6xYt-BLJutw
   
root@debian:~# lvresize -L+48M /dev/mapper/vg2-segundo--lv 
  Size of logical volume vg2/segundo-lv changed from 48,00 MiB (12 extents) to 96,00 MiB (24 extents).
  Logical volume vg2/segundo-lv successfully resized.
root@debian:~# lvresize -L+48M /dev/mapper/vg2-tercer--lv 
  Size of logical volume vg2/tercer-lv changed from 48,00 MiB (12 extents) to 96,00 MiB (24 extents).
  Logical volume vg2/tercer-lv successfully resized.
root@debian:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg1/primer-lv
  LV Name                primer-lv
  VG Name                vg1
  LV UUID                TLxQy9-T6Ue-4Orh-3Rn3-QDGV-IOAc-QpycmI
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 17:53:47 +0100
  LV Status              available
  # open                 1
  LV Size                1,17 GiB
  Current LE             300
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0
   
  --- Logical volume ---
  LV Path                /dev/vg2/segundo-lv
  LV Name                segundo-lv
  VG Name                vg2
  LV UUID                pMMNrn-cGQP-RD8Y-BjNB-a7Ci-20dS-HqW3hY
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 18:55:43 +0100
  LV Status              available
  # open                 1
  LV Size                96,00 MiB
  Current LE             24
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1
   
  --- Logical volume ---
  LV Path                /dev/vg2/tercer-lv
  LV Name                tercer-lv
  VG Name                vg2
  LV UUID                lDbtb2-hXtz-Uw5T-jQNn-WjOq-j8aq-xLrXuo
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 18:55:52 +0100
  LV Status              available
  # open                 1
  LV Size                96,00 MiB
  Current LE             24
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:2
   
root@debian:~# 
~~~


### Esquema 3.
- Disco 1 GB. Partición 1, Capacidad 100MB, Formato ntfs, Partición 2, Capacidad 900MB.
- Volumen Lógico, Capacidad 300 MB, Formato ext3, Punto de montaje /mnt/disco.


Particionado y formateo del disco duro.
~~~
root@debian:~# fdisk /dev/sdf

Bienvenido a fdisk (util-linux 2.29.2).
Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
Tenga cuidado antes de utilizar la orden de escritura.

El dispositivo no contiene una tabla de particiones reconocida.
Se ha creado una nueva etiqueta de disco DOS con el identificador de disco 0x3319f08c.

Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (0 primaria(s), 0 extendida(s), 4 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): p
Número de partición (1-4, valor predeterminado 1): 
Primer sector (2048-2097151, valor predeterminado 2048): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): +100M

Crea una nueva partición 1 de tipo 'Linux' y de tamaño 100 MiB.

Orden (m para obtener ayuda): n
Tipo de partición
   p   primaria (1 primaria(s), 0 extendida(s), 3 libre(s))
   e   extendida (contenedor para particiones lógicas)
Seleccionar (valor predeterminado p): p
Número de partición (2-4, valor predeterminado 2): 
Primer sector (206848-2097151, valor predeterminado 206848): 
Último sector, +sectores o +tamaño{K,M,G,T,P} (206848-2097151, valor predeterminado 2097151): 

Crea una nueva partición 2 de tipo 'Linux' y de tamaño 923 MiB.

Orden (m para obtener ayuda): p
Disco /dev/sdf: 1 GiB, 1073741824 bytes, 2097152 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x3319f08c

Disposit.  Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/sdf1             2048  206847   204800   100M 83 Linux
/dev/sdf2           206848 2097151  1890304   923M 83 Linux

Orden (m para obtener ayuda): w
Se ha modificado la tabla de particiones.
Llamando a ioctl() para volver a leer la tabla de particiones.
Se están sincronizando los discos.

root@debian:~# mkfs.ntfs /dev/sdf1
Cluster size has been automatically set to 4096 bytes.
Initializing device with zeroes: 100% - Done.
Creating NTFS volume structures.
mkntfs completed successfully. Have a nice day.
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sdf                                                                        
├─sdf1            ntfs              0F02C9014F6A0C97                       
└─sdf2                                                                     
sdg               LVM2_member       fPEN1C-hevl-RwcN-S27y-lxuf-TEbN-TTqGnz 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sr0                                                                        
root@debian:~# 
~~~


Creación de la segunda partición en volumen físico y creación de un grupo de volumenes.
~~~
root@debian:~# pvcreate /dev/sdf2
  Physical volume "/dev/sdf2" successfully created.
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sdf                                                                        
├─sdf1            ntfs              0F02C9014F6A0C97                       
└─sdf2            LVM2_member       LZk7V5-icn0-bSbu-X6nM-7hKc-HTYB-VVchPD 
sdg               LVM2_member       fPEN1C-hevl-RwcN-S27y-lxuf-TEbN-TTqGnz 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sr0                                                                        
root@debian:~# vgcreate vg3 /dev/sdf2
  Volume group "vg3" successfully created
root@debian:~# lsblk -f
NAME              FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                        
├─sda1            ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                     
└─sda5            swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb               LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdc               LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdd               LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv  ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sde               LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sdf                                                                        
├─sdf1            ntfs              0F02C9014F6A0C97                       
└─sdf2            LVM2_member       LZk7V5-icn0-bSbu-X6nM-7hKc-HTYB-VVchPD 
sdg               LVM2_member       fPEN1C-hevl-RwcN-S27y-lxuf-TEbN-TTqGnz 
├─vg2-segundo--lv ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv  ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sr0                                                                        
root@debian:~# vgdisplay vg3
  --- Volume group ---
  VG Name               vg3
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               920,00 MiB
  PE Size               4,00 MiB
  Total PE              230
  Alloc PE / Size       0 / 0   
  Free  PE / Size       230 / 920,00 MiB
  VG UUID               733Bz0-cHFj-jFnj-w3yq-01ue-OewS-gGk1qv
   
root@debian:~# 
~~~


Creación, formateo y montaje del volumen lógico.
~~~
root@debian:~# lvcreate --size 300m -n cuarto-lv vg3
  Logical volume "cuarto-lv" created.
root@debian:~# lvdisplay vg3
  --- Logical volume ---
  LV Path                /dev/vg3/cuarto-lv
  LV Name                cuarto-lv
  VG Name                vg3
  LV UUID                uPe0bq-rZDI-I7TV-oJ5i-VgeP-kTyL-YWthmm
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 19:36:56 +0100
  LV Status              available
  # open                 0
  LV Size                300,00 MiB
  Current LE             75
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:3
   
root@debian:~# mkfs.ext3 /dev/mapper/vg3-cuarto--lv 
mke2fs 1.43.4 (31-Jan-2017)
Se está creando un sistema de ficheros con 307200 bloques de 1k y 76912 nodos-i
UUID del sistema de ficheros: c2ed5139-3bad-44aa-9fe4-73325ac71e3a
Respaldo del superbloque guardado en los bloques: 
	8193, 24577, 40961, 57345, 73729, 204801, 221185

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (8192 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho
          
root@debian:~# mount /dev/mapper/vg3-cuarto--lv /mnt/disco
root@debian:~# lsblk -f
NAME               FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                         
├─sda1             ext4              9bb748be-c081-4450-8a0e-51903495fc92   /
├─sda2                                                                      
└─sda5             swap              bff0697e-82c1-4182-bd1c-cac74dd0e016   [SWAP]
sdb                LVM2_member       0ceDmn-2f3y-XlPT-5euG-NDFy-35V3-F1VhoF 
└─vg1-primer--lv   ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdc                LVM2_member       ik9PXi-HC64-X5X8-neGB-odTS-K1QL-gIXXb1 
└─vg1-primer--lv   ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sdd                LVM2_member       zgnhem-aReC-Ngix-rX8M-m9hG-ho0U-mwyVYR 
└─vg1-primer--lv   ext3              b4941efc-8dda-416c-b0c2-54f1aa3a8726   
sde                LVM2_member       0bxBjD-nIY7-O1A3-JKsC-kfU2-vhv4-i1lw6p 
├─vg2-segundo--lv  ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv   ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sdf                                                                         
├─sdf1             ntfs              0F02C9014F6A0C97                       
└─sdf2             LVM2_member       LZk7V5-icn0-bSbu-X6nM-7hKc-HTYB-VVchPD 
  └─vg3-cuarto--lv ext3              c2ed5139-3bad-44aa-9fe4-73325ac71e3a   /mnt/disco
sdg                LVM2_member       fPEN1C-hevl-RwcN-S27y-lxuf-TEbN-TTqGnz 
├─vg2-segundo--lv  ext3              86d6d11a-c602-465a-9302-c21eb141bf93   
└─vg2-tercer--lv   ext3              92d8f630-7b2b-4f97-8acc-07136d7d9acf   
sr0                                                                         
root@debian:~# touch /mnt/disco/prueba{1..5}
root@debian:~# ls /mnt/disco
lost+found  prueba1  prueba2  prueba3  prueba4	prueba5
root@debian:~#
~~~


Creación de una snapshot.
~~~
root@debian:~# lvcreate -s --size 300M -n prueba_snapshot /dev/vg3/cuarto-lv 
  Using default stripesize 64,00 KiB.
  Logical volume "prueba_snapshot" created.
root@debian:~#
~~~


Montaje y comprobación de la snapshot.
~~~
root@debian:~# touch /mnt/disco/prueba{6..10}
root@debian:~# ls /mnt/disco
lost+found  prueba1  prueba10  prueba2	prueba3  prueba4  prueba5  prueba6  prueba7  prueba8  prueba9             
root@debian:~# mount /dev/mapper/vg3-prueba_snapshot /mnt/prueba_snapshot/
root@debian:~# ls /mnt/prueba_snapshot/
lost+found  prueba1  prueba2  prueba3  prueba4	prueba5
root@debian:~# 
~~~


Destrucción de la snapshot.
~~~
root@debian:~# umount /mnt/prueba_snapshot/
root@debian:~# lvremove /dev/mapper/vg3-prueba_snapshot
Do you really want to remove active logical volume vg3/prueba_snapshot? [y/n]: y
  Logical volume "prueba_snapshot" successfully removed
root@debian:~# lvdisplay vg3
  --- Logical volume ---
  LV Path                /dev/vg3/cuarto-lv
  LV Name                cuarto-lv
  VG Name                vg3
  LV UUID                uPe0bq-rZDI-I7TV-oJ5i-VgeP-kTyL-YWthmm
  LV Write Access        read/write
  LV Creation host, time debian, 2018-03-06 19:36:56 +0100
  LV Status              available
  # open                 1
  LV Size                300,00 MiB
  Current LE             75
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:3
   
root@debian:~# 
~~~