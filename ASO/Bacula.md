# Servidor
- Fichero: `/etc/bacula/bacula-dir.conf`:
~~~
Messages {
  Name = Standard
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = root = all, !skipped
  operator = root = mount
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
  catalog = all
}

Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
  mail = root = all, !skipped
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}

Console {
  Name = serranito.jesus.gonzalonazareno.org-mon
  Password = "dBzEkXImoTK_BNZK1wCYjH6c7dOrT9Raw"
  CommandACL = status, .status
}

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
  Password = "password"
  Messages = Daemon
  DirAddress = 127.0.0.1
}

########
# Pool #
########
## Serranito
Pool {
  Name = FSerranito
  Pool Type = Backup
  Recycle = yes                   
  AutoPrune = yes    
  Volume Retention = 120 days         
  Maximum Volume Bytes = 10G
  Maximum Volumes = 8           
  LabelFormat = "SerranitoFull-"               
}

Pool {
  Name = DSerranito
  Pool Type = Backup
  Recycle = yes               
  AutoPrune = yes
  Volume Retention = 7 days
  Maximum Volume Bytes = 1G
  Maximum Volumes = 6 
  LabelFormat = "SerranitoDiff-"
}





## Croqueta
Pool {
  Name = FCroqueta
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 120 days
  Maximum Volume Bytes = 10G
  Maximum Volumes = 8
  LabelFormat = "CroquetaFull-"
}

Pool {
  Name = DCroqueta
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 7 days
  Maximum Volume Bytes = 1G
  Maximum Volumes = 6
  LabelFormat = "CroquetaDiff-"
}




## Tortilla
Pool {
  Name = FTortilla
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 120 days
  Maximum Volume Bytes = 10G
  Maximum Volumes = 8
  LabelFormat = "TortillaFull-"
}

Pool {
  Name = DTortilla
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 7 days
  Maximum Volume Bytes = 1G
  Maximum Volumes = 6
  LabelFormat = "TortillaDiff-"
}





## Salmorejo
Pool {
  Name = FSalmorejo
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 120 days
  Maximum Volume Bytes = 10G
  Maximum Volumes = 8
  LabelFormat = "SalmorejoFull-"
}

Pool {
  Name = DSalmorejo
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 7 days
  Maximum Volume Bytes = 1G
  Maximum Volumes = 6
  LabelFormat = "SalmorejoDiff-"
}

############
# Catálogo #
############
Catalog {
  Name = Catalogo
  dbname = "bacula"; 
  DB Address = "127.0.0.1"; 
  dbuser = "bacula"; 
  dbpassword = "password"
}

##################
# Almacenamiento #
##################
# Indica donde se va a almacenar la copia, debe coincidir con la directiva "Device" definida en 'bacula-sd.conf'.
Storage {
  Name = Backups
  Address = 10.0.0.13
  SDPort = 9103
  Device = VolBackups
  Media Type = BackupDisk
  Maximum Concurrent Jobs = 20
  Password = "password"
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
  Password = "password"
  File Retention = 30 days          
  Job Retention = 2 months   
  AutoPrune = yes  
}

Client {
  Name = Croqueta
  Address = 10.0.0.6
  FDPort = 9102
  Catalog = Catalogo
  Password = "password"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Tortilla 
  Address = 10.0.0.10
  FDPort = 9102
  Catalog = Catalogo
  Password = "password"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Salmorejo
  Address = 10.0.0.5
  FDPort = 9102
  Catalog = Catalogo
  Password = "password"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

Client {
  Name = Pruebas
  Address = 10.0.0.16
  FDPort = 9102
  Catalog = Catalogo
  Password = "password"
  File Retention = 30 days
  Job Retention = 2 months
  AutoPrune = yes
}

##############################
# Jobs, FileSets y Schedules #
##############################
# Job: Define las distintas tareas que se van a realizar.
# FileSet: Define los ficheros afectados.
# Schedule: Define cuando se ejecutarán los distintos jobs.

Schedule {
  Name = "Completa"
  Run = sun at 23:55
}

Schedule {
  Name = "Diferencial"
  Run = mon-sat at 23:55
}

## Serranito
FileSet {
  Name = "Serranito-FS"
  Include {
    Options {
      compression=GZIP
    }
    File = /var/lib
    File = /var/log
    File = /etc
  }
}

Job {
  Name = "Full-Serranito"
  Schedule = "Completa"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Serranito
  FileSet = "Serranito-FS"
  Storage = Backups
  Messages = Standard
  Pool = FSerranito
}

Job {
  Name = "Dif-Serranito"
  Schedule = "Diferencial" 
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Serranito
  FileSet = "Serranito-FS"
  Storage = Backups
  Messages = Standard
  Pool = DSerranito
}

Job {
 Name = "RestoreFull-Serranito"
 Type = Restore
 Client= Serranito
 FileSet="Serranito-FS"
 Storage = Backups
 Pool = FSerranito
 Messages = Standard
}

Job {
 Name = "RestoreDiff-Serranito"
 Type = Restore
 Client= Serranito
 FileSet="Serranito-FS"
 Storage = Backups
 Pool = DSerranito
 Messages = Standard
}





## Croqueta
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

Job {
  Name = "Full-Croqueta"
  Schedule = "Completa"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Croqueta
  FileSet = "Croqueta-FS"
  Storage = Backups
  Messages = Standard
  Pool = FCroqueta
}

Job {
  Name = "Dif-Croqueta"
  Schedule = "Diferencial" 
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Croqueta
  FileSet = "Croqueta-FS"
  Storage = Backups
  Messages = Standard
  Pool = DCroqueta
}

Job {
 Name = "RestoreFull-Croqueta"
 Type = Restore
 Client= Croqueta
 FileSet="Croqueta-FS"
 Storage = Backups
 Pool = FCroqueta
 Messages = Standard
}

Job {
 Name = "RestoreDiff-Croqueta"
 Type = Restore
 Client= Croqueta
 FileSet="Croqueta-FS"
 Storage = Backups
 Pool = DCroqueta
 Messages = Standard
}





## Tortilla
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

Job {
  Name = "Full-Tortilla"
  Schedule = "Completa"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Tortilla
  FileSet = "Tortilla-FS"
  Storage = Backups
  Messages = Standard
  Pool = FTortilla
}

Job {
  Name = "Dif-Tortilla"
  Schedule = "Diferencial"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Tortilla
  FileSet = "Tortilla-FS"
  Storage = Backups
  Messages = Standard
  Pool = DTortilla
}

Job {
 Name = "RestoreFull-Tortilla"
 Type = Restore
 Client= Tortilla
 FileSet="Tortilla-FS"
 Storage = Backups
 Pool = FTortilla
 Messages = Standard
}

Job {
 Name = "RestoreDiff-Tortilla"
 Type = Restore
 Client= Tortilla
 FileSet="Tortilla-FS"
 Storage = Backups
 Pool = DTortilla
 Messages = Standard
}





## Salmorejo
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

Job {
  Name = "Full-Salmorejo"
  Schedule = "Completa"
  Enabled = yes
  Type = Backup
  Level = Full
  Client = Salmorejo
  FileSet = "Salmorejo-FS"
  Storage = Backups
  Messages = Standard
  Pool = FSalmorejo
}

Job {
  Name = "Dif-Salmorejo"
  Schedule = "Diferencial"
  Enabled = yes
  Type = Backup
  Level = Differential
  Client = Salmorejo
  FileSet = "Salmorejo-FS"
  Storage = Backups
  Messages = Standard
  Pool = DSalmorejo
}

Job {
 Name = "RestoreFull-Salmorejo"
 Type = Restore
 Client= Salmorejo
 FileSet="Salmorejo-FS"
 Storage = Backups
 Pool = FSalmorejo
 Messages = Standard
}

Job {
 Name = "RestoreDiff-Salmorejo"
 Type = Restore
 Client= Salmorejo
 FileSet="Salmorejo-FS"
 Storage = Backups
 Pool = DSalmorejo
 Messages = Standard
}
~~~

- Fichero `/etc/bacula/bacula-sd.conf`:
~~~
Messages {
  Name = Standard
  director = serranito.jesus.gonzalonazareno.org-dir = all
}

#################
# Configuración #
#################
# Define el/los dispositivo/s donde se van a guardar las copias.
Device {
  Name = VolBackups
  Media Type = BackupDisk
  Archive Device = /bacula
  Label Media = yes;
  Random Access = yes;
  Automatic Mount = yes;
  Removable Media = no;
  Always Open = no;
  Maximum Concurrent Jobs = 20
}

Storage {
  Name = Backups
  SDPort = 9103
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/run/bacula"
  Plugin Directory = "/usr/lib/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = 10.0.0.13
}

Director {
  Name = serranito-dir
  Password = "password" 
}
~~~

- Fichero `/etc/bacula/bacula-fd.conf`:
~~~
Messages {
  Name = Standard
  director = serranito.jesus.gonzalonazareno.org-dir = all, !skipped, !restored
}

#################
# Configuración #
#################
Director {
  Name = serranito-dir
  Password = "password"
}

FileDaemon {
  Name = Serranito
  FDport = 9102
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 127.0.0.1
}
~~~

# Clientes.
- Croqueta (`/etc/bacula/bacula-fd.conf`):
~~~
Messages {
  Name = Standard
  director = croqueta.jesus.gonzalonazareno.org-dir = all, !skipped, !restored
}

#################
# Configuración #
#################
Director {
  Name = serranito-dir
  Password = "password"
}

FileDaemon {
  Name = Croqueta
  FDport = 9102
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.0.6
}
~~~

- Tortilla (`/etc/bacula/bacula-fd.conf`):
~~~
Messages {
  Name = Standard
  director = tortilla.jesus.gonzalonazareno.org-dir = all, !skipped, !restored
}

#################
# Configuración #
#################
Director {
  Name = serranito-dir
  Password = "password"
}

FileDaemon {
  Name = Tortilla
  FDport = 9102
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.0.10
}
~~~

- Salmorejo (`/etc/bacula/bacula-fd.conf`):
~~~
Messages {
  Name = Standard
  director = bacula-dir = all, !skipped, !restored
}

#################
# Configuración #
#################
Director {
  Name = serranito-dir
  Password = "password"
}

FileDaemon {
  Name = Salmorejo
  FDport = 9102
  WorkingDirectory = /var/spool/bacula
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib64/bacula
  FDAddress = 10.0.0.5
}
~~~