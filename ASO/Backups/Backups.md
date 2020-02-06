# Instalación de un sistema de copias de seguridad con Bacula.
### Instalación del servidor.
~~~
ubuntu@serranito:~$ sudo apt install bacula


ubuntu@serranito:~$ systemctl status bacula-director.service
● bacula-director.service - Bacula Director Daemon service
   Loaded: loaded (/lib/systemd/system/bacula-director.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-01-22 08:06:14 UTC; 9min ago
     Docs: man:bacula-dir(8)
 Main PID: 23584 (bacula-dir)
    Tasks: 3 (limit: 1152)
   CGroup: /system.slice/bacula-director.service
           └─23584 /usr/sbin/bacula-dir -fP -c /etc/bacula/bacula-dir.conf

Jan 22 08:06:14 serranito.jesus.gonzalonazareno.org systemd[1]: Starting Bacula Director Daemon service...
Jan 22 08:06:14 serranito.jesus.gonzalonazareno.org systemd[1]: Started Bacula Director Daemon service.
ubuntu@serranito:~$ systemctl status bacula-fd.service
● bacula-fd.service - Bacula File Daemon service
   Loaded: loaded (/lib/systemd/system/bacula-fd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-01-22 08:04:09 UTC; 11min ago
     Docs: man:bacula-fd(8)
 Main PID: 19635 (bacula-fd)
    Tasks: 2 (limit: 1152)
   CGroup: /system.slice/bacula-fd.service
           └─19635 /usr/sbin/bacula-fd -fP -c /etc/bacula/bacula-fd.conf

Jan 22 08:04:09 serranito.jesus.gonzalonazareno.org systemd[1]: Starting Bacula File Daemon service...
Jan 22 08:04:09 serranito.jesus.gonzalonazareno.org systemd[1]: Started Bacula File Daemon service.
ubuntu@serranito:~$ systemctl status bacula-sd.service
● bacula-sd.service - Bacula Storage Daemon service
   Loaded: loaded (/lib/systemd/system/bacula-sd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-01-22 08:04:39 UTC; 11min ago
     Docs: man:bacula-sd(8)
 Main PID: 22044 (bacula-sd)
    Tasks: 2 (limit: 1152)
   CGroup: /system.slice/bacula-sd.service
           └─22044 /usr/sbin/bacula-sd -fP -c /etc/bacula/bacula-sd.conf

Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org systemd[1]: Starting Bacula Storage Daemon service...
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org systemd[1]: Started Bacula Storage Daemon service.
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: init_dev.c:123-0 [SE0001] Unable to stat
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: stored.c:614-0 Could not initialize SD d
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: init_dev.c:123-0 [SE0001] Unable to stat
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: stored.c:614-0 Could not initialize SD d
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: init_dev.c:123-0 [SE0001] Unable to stat
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: stored.c:614-0 Could not initialize SD d
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: init_dev.c:123-0 [SE0001] Unable to stat
Jan 22 08:04:39 serranito.jesus.gonzalonazareno.org bacula-sd[22044]: serranito.jesus.gonzalonazareno.org-sd: stored.c:614-0 Could not initialize SD d
ubuntu@serranito:~$ 
~~~

### Instalación de los clientes.
~~~
debian@baculaclient:~$ sudo apt install bacula-client
~~~

### Configuración del servidor.
Creación del directorio de montaje, asignación de permisos y montaje de un nuevo volumen.
~~~
root@serranito:~# mkdir /bacula
root@serranito:~# chown bacula:bacula -R /bacula
root@serranito:~# lsblk -f
NAME    FSTYPE LABEL           UUID                                 MOUNTPOINT
vda                                                                 
├─vda1  ext4   cloudimg-rootfs 15993e31-3f38-4b9f-bdeb-74e0541498d0 /
├─vda14                                                             
└─vda15 vfat   UEFI            323C-AF60                            /boot/efi
vdb                                                                 
└─vdb1  ext4                   d55b52c1-d7a9-4709-bb61-6afb97df4816 
root@serranito:~# mount /dev/vdb1 /bacula
~~~

Configuración de `/etc/bacula/bacula-sd.conf`, encargado del almacenamiento:
~~~
#################
# Configuración #
#################
Device {
  Name = Backups
  Media Type = BackupDisk
  Archive Device = /dev/vdb2
  Label Media = yes;
  Random Access = yes;
  Automatic Mount = yes;
  Removable Media = no;
  Always Open = no;
  Maximum Concurrent Jobs = 5
}

Storage {
  Name = serranito.jesus.gonzalonazareno.org-sd
  SDPort = 9103 
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/run/bacula"
  Plugin Directory = "/usr/lib/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = serranito.jesus.gonzalonazareno.org
}

# Comprobación:
root@serranito:/etc/bacula# bacula-sd -tc bacula-sd.conf
root@serranito:/etc/bacula# 
~~~

Configuración de `/etc/bacula/bacula-dir.conf`:
~~~
#################
# Configuración #
#################
Director {                            
  Name = serranito-dir
  DIRport = 9101                
  QueryFile = "/etc/bacula/scripts/query.sql"
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/run/bacula"
  Maximum Concurrent Jobs = 20
  Password = "8529garomun"
  Messages = Daemon
  DirAddress = serranito.jesus.gonzalonazareno.org
}

############
# Clientes #
############
# Define los distintos clientes a los que se va a acceder.
Client {
  Name = Serranito
  Address = 127.0.0.1
  FDPort = 9102
  Catalog = Catalogo
  Password = "serranito"
  File Retention = 30 days          
  Job Retention = 2 months   
  AutoPrune = yes  
}

Client {
  Name = Croqueta
  Address = croqueta.jesus.gonzalonazareno.org
  FDPort = 9102
  Catalog = Catalogo
  Password = "croqueta"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Tortilla 
  Address = tortilla.jesus.gonzalonazareno.org
  FDPort = 9102
  Catalog = Catalogo
  Password = "tortilla"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Salmorejo
  Address = salmorejo.jesus.gonzalonazareno.org
  FDPort = 9102
  Catalog = Catalogo
  Password = "salmorejo"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Pruebas
  Address = 10.0.0.16
  FDPort = 9102
  Catalog = Catalogo
  Password = "pruebas"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

##################
# Almacenamiento #
##################
# Indica donde se va a almacenar la copia, debe coincidir con la directiva "Device" definida en 'bacula-sd.conf'.
Storage {
  Name = Backups
  Address = serranito.jesus.gonzalonazareno.org                
  SDPort = 9103
  Device = BackupDevice
  Media Type = BackupDisk
  Maximum Concurrent Jobs = 5
  Password = "8529garomun"
}

###################
# Jobs y FileSets #
###################
# Job: Define las distintas tareas que se van a realizar.
# FileSet: Define los ficheros afectados.

# Croqueta
Job {
  Name = "Full-Croqueta"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Croqueta
  FileSet = "Croqueta-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

Job {
  Name = "Dif-Croqueta"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Croqueta
  FileSet = "Croqueta-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

FileSet {
  Name = "Croqueta-FS"
  Include {
    Options {
      compression=GZIP
    }
    File = /var/lib
    File = /var/log
    File = /etc
  }
}

# Tortilla
Job {
  Name = "Full-Tortilla"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Tortilla
  FileSet = "Tortilla-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

Job {
  Name = "Dif-Tortilla"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Tortilla
  FileSet = "Tortilla-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

FileSet {
  Name = "Tortilla-FS"
  Include {
    Options {
      compression=GZIP
    }
    File = /var/lib
    File = /var/log
    File = /etc
  }
}

# Salmorejo
Job {
  Name = "Full-Salmorejo"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Salmorejo
  FileSet = "Salmorejo-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

Job {
  Name = "Dif-Salmorejo"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Salmorejo
  FileSet = "Salmorejo-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

FileSet {
  Name = "Salmorejo-FS"
  Include {
    Options {
      compression=GZIP
    }
    File = /var/lib
    File = /var/log
    File = /etc
    File = /var/www
  }
}

# Pruebas.
Job {
  Name = "Full-Pruebas"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Pruebas
  FileSet = "Pruebas-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

Job {
  Name = "Dif-Pruebas"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Pruebas
  FileSet = "Pruebas-FS"
  Storage = Backups
  Messages = Standard
  Pool = Copias
}

FileSet {
  Name = "Pruebas-FS"
  Include {
    Options {
      compression=GZIP
    }
    File = /var/lib
    File = /var/log
    File = /etc
    File = /var/www
  }
}

########
# Pool #
########
Pool {
  Name = Copias
  Pool Type = Backup
  Recycle = yes                     
  AutoPrune = yes         
  Volume Retention = 365 days         
  Maximum Volume Bytes = 20G
  Maximum Volumes = 100          
  LabelFormat = "Vol-"               
}

############
# Catálogo #
############
Catalog {
  Name = Catalogo
  dbname = "bacula"; 
  DB Address = "127.0.0.1"; 
  dbuser = "bacula"; 
  dbpassword = "8529garomun"
}

# Comprobación:
root@serranito:/etc/bacula# bacula-dir -tc bacula-dir.conf
root@serranito:/etc/bacula# 
~~~

Configuración cliente (`/etc/bacula/bacula-fd.conf`):
~~~
#################
# Configuración #
#################
Director {
  Name = serranito-dir
  Password = "8529garomun"
}

FileDaemon {
  Name = pPruebas
  FDport = 9102
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.0.16
}
~~~

[root@salmorejo centos]# firewall-cmd --zone=public --add-port=9101/tcp --permanent
success
[root@salmorejo centos]# firewall-cmd --zone=public --add-port=9102/tcp --permanent
success
[root@salmorejo centos]# firewall-cmd --zone=public --add-port=9103/tcp --permanent
success
[root@salmorejo centos]# firewall-cmd --reload
success
[root@salmorejo centos]#