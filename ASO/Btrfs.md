## Sistemas de ficheros avanzados: Btrfs.
En la máquina disponemos de varios discos, `sdb`, `sdc`, `sdd` y `sde`, así como `sda` en el cual se encuentra instalado el sistema operativo: 
~~~
root@btrfs:~# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   10G  0 disk 
└─sda1   8:1    0   10G  0 part /
sdb      8:16   0  1,5G  0 disk 
sdc      8:32   0  1,5G  0 disk 
sdd      8:48   0  1,5G  0 disk 
sde      8:64   0  1,5G  0 disk 
sr0     11:0    1 1024M  0 rom  
root@btrfs:~#
~~~

### Creación y pruebas de funcionamiento de un Raid6.
En este caso utilizaremos los discos `sdb`, `sdc`, `sdd` y `sde` para la creación de un `RAID 6` y utilizaremos un `RAID 10` para guardar los metadatos:
~~~
root@btrfs:~# mkfs.btrfs -d raid6 -m raid10 -L "Raid6" /dev/sdb /dev/sdc /dev/sdd /dev/sde
btrfs-progs v4.20.1 
See http://btrfs.wiki.kernel.org for more information.

WARNING: metadata has lower redundancy than data!

Label:              Raid6
UUID:               97c52b92-9b69-4987-8eec-1965e2affffd
Node size:          16384
Sector size:        4096
Filesystem size:    5.86GiB
Block group profiles:
  Data:             RAID6           300.00MiB
  Metadata:         RAID10          300.00MiB
  System:           RAID10           16.00MiB
SSD detected:       no
Incompat features:  extref, raid56, skinny-metadata
Number of devices:  4
Devices:
   ID        SIZE  PATH
    1     1.46GiB  /dev/sdb
    2     1.46GiB  /dev/sdc
    3     1.46GiB  /dev/sdd
    4     1.46GiB  /dev/sde

root@btrfs:~#  btrfs filesystem show
Label: none  uuid: 4e5f9eb2-2e10-4a59-a5c0-8abc5bdc8976
	Total devices 1 FS bytes used 1.01GiB
	devid    1 size 10.00GiB used 3.02GiB path /dev/sda1

Label: 'Raid6'  uuid: 97c52b92-9b69-4987-8eec-1965e2affffd
	Total devices 4 FS bytes used 128.00KiB
	devid    1 size 1.46GiB used 308.00MiB path /dev/sdb
	devid    2 size 1.46GiB used 308.00MiB path /dev/sdc
	devid    3 size 1.46GiB used 308.00MiB path /dev/sdd
	devid    4 size 1.46GiB used 308.00MiB path /dev/sde

root@btrfs:~# 
~~~

Con el raid creado, he eliminado un disco de la máquina para así provocar el fallo de un disco del raid:
~~~
root@btrfs:~# btrfs filesystem show
Label: none  uuid: 4e5f9eb2-2e10-4a59-a5c0-8abc5bdc8976
	Total devices 1 FS bytes used 1.02GiB
	devid    1 size 10.00GiB used 3.02GiB path /dev/sda1

warning, device 2 is missing
Label: 'Raid6'  uuid: 97c52b92-9b69-4987-8eec-1965e2affffd
	Total devices 5 FS bytes used 256.00KiB
	devid    1 size 1.46GiB used 308.00MiB path /dev/sdb
	devid    3 size 1.46GiB used 308.00MiB path /dev/sdc
	devid    4 size 1.46GiB used 308.00MiB path /dev/sdd
	*** Some devices missing

root@btrfs:~#
~~~

Para reemplazar un disco es necesario que el sistema esté montado, pero, ya que hemos eliminado uno de los discos de la máquina, queda marcado como **missing** por lo que al montarlo, utilizaremos la opción `-o degraded`:
~~~
root@btrfs:~# mount -o degraded /dev/sdb /mnt
root@btrfs:~# btrfs replace start 2 /dev/sde /mnt
root@btrfs:~# btrfs replace status /mnt
Started on 30.Jan 10:10:17, finished on 30.Jan 10:10:17, 0 write errs, 0 uncorr. read errs
root@btrfs:~# btrfs filesystem show
Label: none  uuid: 4e5f9eb2-2e10-4a59-a5c0-8abc5bdc8976
	Total devices 1 FS bytes used 1.02GiB
	devid    1 size 10.00GiB used 3.02GiB path /dev/sda1

Label: 'Raid6'  uuid: 97c52b92-9b69-4987-8eec-1965e2affffd
	Total devices 4 FS bytes used 256.00KiB
	devid    1 size 1.46GiB used 564.00MiB path /dev/sdb
	devid    2 size 1.46GiB used 308.00MiB path /dev/sde
	devid    3 size 1.46GiB used 340.00MiB path /dev/sdc
	devid    4 size 1.46GiB used 308.00MiB path /dev/sdd

root@btrfs:~# 
~~~

También podemos añadir y eliminar discos, pero al igual que para reemplazar, es necesario que el sistema esté montado, en este caso, añadiremos el disco `sdf` al raid y luego lo eliminaremos:
~~~
root@btrfs:~# mount /dev/sdb /mnt
root@btrfs:~# btrfs device add /dev/sdf /mnt
root@btrfs:~# btrfs filesystem show
Label: none  uuid: 4e5f9eb2-2e10-4a59-a5c0-8abc5bdc8976
	Total devices 1 FS bytes used 1.02GiB
	devid    1 size 10.00GiB used 3.02GiB path /dev/sda1

Label: 'Raid6'  uuid: 97c52b92-9b69-4987-8eec-1965e2affffd
	Total devices 5 FS bytes used 256.00KiB
	devid    1 size 1.46GiB used 564.00MiB path /dev/sdb
	devid    2 size 1.46GiB used 308.00MiB path /dev/sde
	devid    3 size 1.46GiB used 340.00MiB path /dev/sdc
	devid    4 size 1.46GiB used 308.00MiB path /dev/sdd
	devid    5 size 1.46GiB used 0.00B path /dev/sdf

root@btrfs:~# btrfs device delete /dev/sdf /mnt
root@btrfs:~# btrfs filesystem show
Label: none  uuid: 4e5f9eb2-2e10-4a59-a5c0-8abc5bdc8976
	Total devices 1 FS bytes used 1.02GiB
	devid    1 size 10.00GiB used 3.02GiB path /dev/sda1

Label: 'Raid6'  uuid: 97c52b92-9b69-4987-8eec-1965e2affffd
	Total devices 4 FS bytes used 256.00KiB
	devid    1 size 1.46GiB used 564.00MiB path /dev/sdb
	devid    2 size 1.46GiB used 308.00MiB path /dev/sde
	devid    3 size 1.46GiB used 340.00MiB path /dev/sdc
	devid    4 size 1.46GiB used 308.00MiB path /dev/sdd

root@btrfs:~#
~~~

### Características.
##### Copy-on-Write.
Para la prueba de funcionamiento primero generaremos un fichero de 100MiB y realizaremos distintas copias para comprobar el tamaño que realmente ocupa:
~~~
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G    17M  905M   2% /mnt
root@btrfs:/mnt# dd if=/dev/zero of=pruebaCoW.txt bs=1MiB count=100
100+0 registros leídos
100+0 registros escritos
104857600 bytes (105 MB, 100 MiB) copied, 0,0362322 s, 2,9 GB/s
root@btrfs:/mnt# ls -lh
total 100M
-rw-r--r-- 1 root root 100M ene 30 12:54 pruebaCoW.txt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G   117M  905M  13% /mnt
root@btrfs:/mnt# cp --reflink pruebaCoW.txt pruebaCoW-1.txt
root@btrfs:/mnt# cp --reflink pruebaCoW.txt pruebaCoW-2.txt
root@btrfs:/mnt# cp --reflink pruebaCoW.txt pruebaCoW-3.txt
root@btrfs:/mnt# ls -lh
total 400M
-rw-r--r-- 1 root root 100M ene 30 12:54 pruebaCoW-1.txt
-rw-r--r-- 1 root root 100M ene 30 12:54 pruebaCoW-2.txt
-rw-r--r-- 1 root root 100M ene 30 12:54 pruebaCoW-3.txt
-rw-r--r-- 1 root root 100M ene 30 12:54 pruebaCoW.txt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G   117M  905M  13% /mnt
root@btrfs:/mnt#
~~~

Al ser copias idénticas, los nuevos ficheros no ocupan apenas espacio, pero, una vez se modifican, sí que ocupan espacio adicional:
~~~
root@btrfs:/mnt# yes 1 >> pruebaCoW-1.txt
^C
root@btrfs:/mnt# ls -lh
total 616M
-rw-r--r-- 1 root root 316M ene 30 13:33 pruebaCoW-1.txt
-rw-r--r-- 1 root root 100M ene 30 13:33 pruebaCoW-2.txt
-rw-r--r-- 1 root root 100M ene 30 13:33 pruebaCoW-3.txt
-rw-r--r-- 1 root root 100M ene 30 13:32 pruebaCoW.txt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G   333M  589M  37% /mnt
root@btrfs:/mnt# 
~~~ 

##### Compresión.
Para activar la compresión será necesario montar el dispositivo con la opción `-o compress`, a continuación generaremos un fichero de 100MiB relleno de 0s y comprobaremos el tamaño que realmente ocupa:
~~~
root@btrfs:~# mount -o compress /dev/sdg /mnt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G    17M  905M   2% /mnt
root@btrfs:/mnt# dd if=/dev/zero of=pruebaCoW.txt bs=1MiB count=100
100+0 registros leídos
100+0 registros escritos
104857600 bytes (105 MB, 100 MiB) copied, 0,0273518 s, 3,8 GB/s
root@btrfs:/mnt# ls -lh
total 100M
-rw-r--r-- 1 root root 100M ene 30 13:06 pruebaCoW.txt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G    20M  902M   3% /mnt
root@btrfs:/mnt# 
~~~

Al ser un fichero relleno de 0s la compresión es muy sencilla, en este ejemplo, utilizaremos `/dev/urandom` en vez de `/dev/zero` y comprobaremos que la compresión, aunque menos eficiente, se sigue realizando:
~~~
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G    17M  905M   2% /mnt
root@btrfs:/mnt# dd if=/dev/urandom of=pruebaCoW.txt bs=1MiB count=100
100+0 registros leídos
100+0 registros escritos
104857600 bytes (105 MB, 100 MiB) copied, 0,630426 s, 166 MB/s
root@btrfs:/mnt# ls -lh
total 100M
-rw-r--r-- 1 root root 100M ene 30 14:25 pruebaCoW.txt
root@btrfs:/mnt# df -h /mnt
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdg         1,0G   100M  822M  11% /mnt
root@btrfs:/mnt# 
~~~

##### Balanceo.
Para esta comprobación utilizaremos un `RAID 5` con 3 discos, nada más crear el raid ya puede comprobarse la diferencia de tamaño entre los 3 discos, por lo que balancearemos la carga:
~~~
root@btrfs:~# mkfs.btrfs -d raid5 -f /dev/sdb /dev/sdc /dev/sdd
btrfs-progs v4.20.1 
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               3eedd3a5-cbc8-4acc-a351-c3691d23d4df
Node size:          16384
Sector size:        4096
Filesystem size:    3.00GiB
Block group profiles:
  Data:             RAID5           204.75MiB
  Metadata:         RAID1           153.56MiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, raid56, skinny-metadata
Number of devices:  3
Devices:
   ID        SIZE  PATH
    1     1.00GiB  /dev/sdb
    2     1.00GiB  /dev/sdc
    3     1.00GiB  /dev/sdd

root@btrfs:~# btrfs filesystem show
Label: none  uuid: 3eedd3a5-cbc8-4acc-a351-c3691d23d4df
	Total devices 3 FS bytes used 128.00KiB
	devid    1 size 1.00GiB used 255.94MiB path /dev/sdb
	devid    2 size 1.00GiB used 110.38MiB path /dev/sdc
	devid    3 size 1.00GiB used 263.94MiB path /dev/sdd

root@btrfs:~# mount /dev/sdb /mnt
root@btrfs:~# btrfs balance start --full-balance /mnt
Done, had to relocate 3 out of 3 chunks
root@btrfs:~# btrfs filesystem show
Label: none  uuid: 3eedd3a5-cbc8-4acc-a351-c3691d23d4df
	Total devices 3 FS bytes used 256.00KiB
	devid    1 size 1.00GiB used 448.00MiB path /dev/sdb
	devid    2 size 1.00GiB used 416.00MiB path /dev/sdc
	devid    3 size 1.00GiB used 192.00MiB path /dev/sdd

root@btrfs:~# 
~~~

##### Snapshots