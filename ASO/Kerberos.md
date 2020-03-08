### LDAP.
Definimos los nuevos usuarios y en el nuevo grupo (`usuarios.ldif`):
~~~
dn: cn=ucentralizados, ou=Groups, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: posixGroup
objectClass: top
cn: ucentralizados
gidNumber: 9000

dn: uid=croqueta, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: account
objectClass: posixAccount
objectClass: top
cn: croqueta
uid: croqueta
loginShell: /bin/bash
uidNumber: 9501
gidNumber: 9000
homeDirectory: /home/usuarios/croqueta

dn: uid=tortilla, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: account
objectClass: posixAccount
objectClass: top
cn: tortilla
uid: tortilla
loginShell: /bin/bash
uidNumber: 9502
gidNumber: 9000
homeDirectory: /home/usuarios/tortilla
~~~

Añadimos los cambios a `LDAP`:
~~~
debian@croqueta:~/Kerberos/LDAP$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f usuarios.ldif -W
Enter LDAP Password: 
adding new entry "cn=ucentralizados, ou=Groups, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "uid=croqueta, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "uid=tortilla, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

debian@croqueta:~/Kerberos/LDAP$ 
~~~

Creamos los directorios `home` de los nuevos usuarios:
~~~
#----- Croqueta -----#
root@croqueta:~# mkdir -p /home/usuarios/croqueta
root@croqueta:~# cp /etc/skel/.* /home/usuarios/croqueta
cp: -r not specified; omitting directory '/etc/skel/.'
cp: -r not specified; omitting directory '/etc/skel/..'
root@croqueta:~# chown -R 9501:9000 /home/usuarios/croqueta
root@croqueta:~# ls -la /home/usuarios/croqueta/
total 20
drwxr-xr-x 2 9501 9000 4096 Feb 24 18:09 .
drwxr-xr-x 4 root root 4096 Feb 24 17:57 ..
-rw-r--r-- 1 9501 9000  220 Feb 24 18:02 .bash_logout
-rw-r--r-- 1 9501 9000 3526 Feb 24 18:02 .bashrc
-rw-r--r-- 1 9501 9000  807 Feb 24 18:02 .profile
root@croqueta:~# 

#----- Tortilla -----#
root@croqueta:~# mkdir -p /home/usuarios/tortilla
root@croqueta:~# cp /etc/skel/.* /home/usuarios/tortilla
cp: -r not specified; omitting directory '/etc/skel/.'
cp: -r not specified; omitting directory '/etc/skel/..'
root@croqueta:~# chown -R 9502:9000 /home/usuarios/tortilla
root@croqueta:~# ls -la /home/usuarios/tortilla/
total 20
drwxr-xr-x 2 9502 9000 4096 Feb 24 18:05 .
drwxr-xr-x 4 root root 4096 Feb 24 17:57 ..
-rw-r--r-- 1 9502 9000  220 Feb 24 18:05 .bash_logout
-rw-r--r-- 1 9502 9000 3526 Feb 24 18:05 .bashrc
-rw-r--r-- 1 9502 9000  807 Feb 24 18:05 .profile
root@croqueta:~#
~~~

### Name Service Switch (NSS).
Instalamos de `libnss-ldadp` para permitir consultas al servidor `LDAP`:
~~~
# Croqueta
root@croqueta:~# apt install --no-install-recommends libnss-ldapd

# Tortilla
root@tortilla:~# apt install --no-install-recommends libnss-ldapd
~~~

Configuramos `nss` en ambas máquinas (`/etc/nsswitc.conf`):
~~~
# Croqueta
passwd:         files ldap
group:          files ldap

# Tortilla
passwd:         compat systemd ldap
group:          compat systemd ldap
~~~

Comprobamos el funcionamiento:
~~~
root@croqueta:~# ls -la /home/usuarios/
total 16
drwxr-xr-x 4 root     root           4096 Mar  5 10:58 .
drwxr-xr-x 5 root     root           4096 Mar  5 11:19 ..
drwxr-xr-x 4 croqueta ucentralizados 4096 Mar  5 11:08 croqueta
drwxr-xr-x 2 tortilla ucentralizados 4096 Mar  5 10:59 tortilla
root@croqueta:~# getent passwd croqueta
croqueta:*:9501:9000:croqueta:/home/usuarios/croqueta:/bin/bash
root@croqueta:~# getent passwd tortilla
tortilla:*:9502:9000:tortilla:/home/usuarios/tortilla:/bin/bash
root@croqueta:~# getent group ucentralizados
ucentralizados:*:9000:
root@croqueta:~# 
~~~

Por último instalaremos el paquete `nscd` que permite cachear dicha resolución:
~~~
root@croqueta:~# apt install nscd
~~~

### Kerberos.
Instalamos el servidor:
~~~
root@croqueta:~# apt install krb5-kdc krb5-admin-server
~~~

Configuramos `krb5-kdc` (`/etc/krb5kdc/kdc.conf`):
~~~
[ kdcdefaults ]
  kdc_ports = 88

[ realms ]
  JESUS.GONZALONAZARENO.ORG = {
    database_name = /var/lib/krb5kdc/principal
    admin_keytab = FILE:/etc/krb5kdc/kadm5.keytab
    acl_file = /etc/krb5kdc/kadm5.acl
    key_stash_file = /etc/krb5kdc/stash
    kdc_ports = 88
    max_life = 10h 0m 0s
    max_renewable_life = 7d 0h 0m 0s
    master_key_type = des3-hmac-sha1
    supported_enctypes = aes256-cts:normal arcfour-hmac:normal des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm des:afs3
    default_principal_flags = +preauth
  }
~~~

Desactivamos `krb4` (`/etc/default/krb5-kdc`):
~~~
KRB4_MODE=disable
RUN_KRB524D=false
~~~

Configuramos `krb5` (`/etc/krb5.conf`):
~~~
[libdefaults]
        default_realm = JESUS.GONZALONAZARENO.ORG
...
[realms]
        JESUS.GONZALONAZARENO.ORG = {
                kdc = kerberos.jesus.gonzalonazareno.org
                admin_server = kerberos.jesus.gonzalonazareno.org
        }
...
[domain_realm]
        .jesus.gonzalonazareno.org = JESUS.GONZALONAZARENO.ORG
        jesus.gonzalonazareno.org = JESUS.GONZALONAZARENO.ORG
~~~

Definimos nuestro reino y creamos la clave maestra:
~~~
root@croqueta:~# krb5_newrealm
...
Loading random data
Initializing database '/var/lib/krb5kdc/principal' for realm 'JESUS.GONZALONAZARENO.ORG',
master key name 'K/M@JESUS.GONZALONAZARENO.ORG'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 
...
root@croqueta:~# 
~~~

Reiniciamos los servicios:
~~~
root@croqueta:~# systemctl start krb5-kdc
root@croqueta:~# systemctl status krb5-kdc
● krb5-kdc.service - Kerberos 5 Key Distribution Center
   Loaded: loaded (/lib/systemd/system/krb5-kdc.service; disabled; vendor 
   Active: active (running) since Sun 2020-03-08 16:33:54 UTC; 1min 25s ag
  Process: 7779 ExecStart=/usr/sbin/krb5kdc -P /var/run/krb5-kdc.pid $DAEM
 Main PID: 7780 (krb5kdc)
    Tasks: 1 (limit: 562)
   Memory: 1.0M
   CGroup: /system.slice/krb5-kdc.service
           └─7780 /usr/sbin/krb5kdc -P /var/run/krb5-kdc.pid

Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: Setting 
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: setsocko
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: Setting 
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: Setting 
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: Setting 
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: setsocko
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7779]: set up 4
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org systemd[1]: krb5-kdc.se
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org systemd[1]: Started Ker
Mar 08 16:33:54 croqueta.jesus.gonzalonazareno.org krb5kdc[7780]: commenci
root@croqueta:~# systemctl start krb5-admin-server
root@croqueta:~# systemctl status krb5-admin-server
● krb5-admin-server.service - Kerberos 5 Admin Server
   Loaded: loaded (/lib/systemd/system/krb5-admin-server.service; disabled
   Active: active (running) since Sun 2020-03-08 16:33:55 UTC; 1min 37s ag
 Main PID: 7804 (kadmind)
    Tasks: 1 (limit: 562)
   Memory: 784.0K
   CGroup: /system.slice/krb5-admin-server.service
           └─7804 /usr/sbin/kadmind -nofork

Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: Setting 
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: Setting 
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: setsocko
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: Setting 
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: Setting 
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: setsocko
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: set up 6
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: Seeding 
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: starting
Mar 08 16:33:55 croqueta.jesus.gonzalonazareno.org kadmind[7804]: kadmind:
root@croqueta:~# 
~~~

Comprobamos el funcionamiento:
~~~
root@croqueta:~# netstat -putan |grep "krb5kdc\|kadmind"
tcp        0      0 0.0.0.0:749             0.0.0.0:*               LISTEN      7804/kadmind        
tcp        0      0 0.0.0.0:464             0.0.0.0:*               LISTEN      7804/kadmind        
tcp        0      0 0.0.0.0:88              0.0.0.0:*               LISTEN      7780/krb5kdc        
tcp6       0      0 :::749                  :::*                    LISTEN      7804/kadmind        
tcp6       0      0 :::464                  :::*                    LISTEN      7804/kadmind        
tcp6       0      0 :::88                   :::*                    LISTEN      7780/krb5kdc        
udp        0      0 0.0.0.0:88              0.0.0.0:*                           7780/krb5kdc        
udp        0      0 0.0.0.0:464             0.0.0.0:*                           7804/kadmind        
udp6       0      0 :::88                   :::*                                7780/krb5kdc        
udp6       0      0 :::464                  :::*                                7804/kadmind        
root@croqueta:~# 
~~~

Creamos los principales a través de `kadmin`:
~~~
# Usuarios
kadmin.local:  add_principal croqueta
WARNING: no policy specified for croqueta@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Enter password for principal "croqueta@JESUS.GONZALONAZARENO.ORG": 
Re-enter password for principal "croqueta@JESUS.GONZALONAZARENO.ORG": 
Principal "croqueta@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal tortilla
WARNING: no policy specified for tortilla@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Enter password for principal "tortilla@JESUS.GONZALONAZARENO.ORG": 
Re-enter password for principal "tortilla@JESUS.GONZALONAZARENO.ORG": 
Principal "tortilla@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  

# Equipos
kadmin.local:  add_principal -randkey host/croqueta.jesus.gonzalonazareno.org
WARNING: no policy specified for host/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "host/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal -randkey host/tortilla.jesus.gonzalonazareno.org
WARNING: no policy specified for host/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "host/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  

# Servicios
kadmin.local:  add_principal -randkey ldap/ldap.jesus.gonzalonazareno.org
WARNING: no policy specified for ldap/ldap.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "ldap/ldap.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local: 
~~~

Generamos un fichero keytab para los principales del servidor:
~~~
kadmin.local:  ktadd host/croqueta.jesus.gonzalonazareno.org
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  ktadd ldap/ldap.jesus.gonzalonazareno.org
Entry for principal ldap/ldap.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/ldap.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/ldap.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/ldap.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  
~~~

### Kerberos (Cliente)
Instalamos el client:
~~~
# Croqueta
root@croqueta:~# apt install krb5-config krb5-user

# Tortilla
root@tortilla:~# apt install krb5-config krb5-user
## Configuración (/etc/krb5.conf).
[libdefaults]
        default_realm = JESUS.GONZALONAZARENO.ORG
...
[realms]
        JESUS.GONZALONAZARENO.ORG = {
                kdc = kerberos.jesus.gonzalonazareno.org
                admin_server = kerberos.jesus.gonzalonazareno.org
        }
...
[domain_realm]
        .jesus.gonzalonazareno.org = JESUS.GONZALONAZARENO.ORG
        jesus.gonzalonazareno.org = JESUS.GONZALONAZARENO.ORG

## Prueba de funcionamiento.
root@tortilla:~# kinit tortilla
Password for tortilla@JESUS.GONZALONAZARENO.ORG: 
root@tortilla:~# klist -5
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: tortilla@JESUS.GONZALONAZARENO.ORG

Valid starting     Expires            Service principal
03/08/20 17:39:47  03/09/20 03:39:47  krbtgt/JESUS.GONZALONAZARENO.ORG@JESUS.GONZALONAZARENO.ORG
    renew until 03/09/20 17:39:43
root@tortilla:~# 
~~~

### GSSAPI.
Instalación:
~~~
root@croqueta:~# apt install libsasl2-modules-gssapi-mit
~~~

Modificamos los permisos de `/etc/krb5.keytab` para permitir a LDAP acceder al mismo:
~~~
root@croqueta:~# chmod 640 /etc/krb5.keytab
root@croqueta:~# chgrp openldap /etc/krb5.keytab
root@croqueta:~# 
~~~

Configuración:
~~~
# /etc/ldap/sasl2/slapd.conf
mech_list: GSSAPI

# /etc/ldap/ldap.conf
SASL_MECH GSSAPI
SASL_REALM JESUS.GONZALONAZARENO.ORG
~~~

Comprobación:
~~~
root@croqueta:~# ldapsearch -x -b "" -s base -LLL supportedSASLMechanisms
dn:
supportedSASLMechanisms: GSSAPI

root@croqueta:~#
~~~

### Configuración de PAM.
Instalamos en todos los equipos el paquete que permite la autenticación a través de Kerberos:
~~~
# Croqueta
root@croqueta:~# apt install libpam-krb5

# Tortilla
root@tortilla:~# apt install libpam-krb5
~~~

Configuramos PAM (`/etc/pam.d`):
~~~
# common-auth
auth sufficient pam_krb5.so minimum_uid=9500
auth required pam_unix.so try_first_pass nullok_secure

# common-session
session optional pam_krb5.so minimum_uid=9500
session required pam_unix.so

# common-account
account sufficient pam_krb5.so minimum_uid=9500
account required pam_unix.so

# common-password
password sufficient pam_krb5.so minimum_uid=9500
password required pam_unix.so nullok obscure min=4 max=8 md5

# Prueba de funcionamiento.
root@tortilla:~# login tortilla
Password: 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-88-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Mar  8 18:13:27 UTC 2020

  System load:  0.19              Processes:           93
  Usage of /:   20.9% of 9.52GB   Users logged in:     1
  Memory usage: 56%               IP address for ens3: 10.0.0.10
  Swap usage:   0%

 * Latest Kubernetes 1.18 beta is now available for your laptop, NUC, cloud
   instance or Raspberry Pi, with automatic updates to the final GA release.

     sudo snap install microk8s --channel=1.18/beta --classic

 * Multipass 1.1 adds proxy support for developers behind enterprise
   firewalls. Rapid prototyping for cloud operations just got easier.

     https://multipass.run/

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

0 packages can be updated.
0 updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

No directory, logging in with HOME=/
tortilla@tortilla:/$
~~~

### NFS4
Instalamos el servidor:
~~~
root@croqueta:~# apt install nfs-kernel-server
~~~

Configuramos el servidor:
~~~
# /etc/default/nfs-common
NEED_IDMAPD=yes
NEED_GSSD=yes

# /etc/default/nfs-kernel-server
NEED_SVCGSSD=yes

# /etc/idmapd.conf
Domain = jesus.gonzalonazareno.org
~~~

Añadimos los principales a `krb5`:
~~~
# Creación de los principales.
kadmin.local:  add_principal -randkey nfs/croqueta.jesus.gonzalonazareno.org
WARNING: no policy specified for nfs/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "nfs/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal -randkey nfs/tortilla.jesus.gonzalonazareno.org
WARNING: no policy specified for nfs/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "nfs/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:

# Creación de los ficheros keytab
kadmin.local:  ktadd nfs/croqueta.jesus.gonzalonazareno.org
Entry for principal nfs/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal nfs/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal nfs/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal nfs/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  ktadd -k /tmp/krb5.keytab nfs/tortilla.jesus.gonzalonazareno.org
Entry for principal nfs/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab WRFILE:/tmp/krb5.keytab.
Entry for principal nfs/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab WRFILE:/tmp/krb5.keytab.
Entry for principal nfs/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab WRFILE:/tmp/krb5.keytab.
Entry for principal nfs/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab WRFILE:/tmp/krb5.keytab.
kadmin.local:  

# Pasamos el fichero keytab al cliente y lo borramos del servidor.
root@croqueta:~# scp /tmp/krb5.keytab tortilla:/etc/krb5.keytab
root@tortilla's password: 
krb5.keytab                                                                                                         100%  446   416.3KB/s   00:00    
root@croqueta:~# rm /tmp/krb5.keytab
root@croqueta:~# 
~~~

Configuramos la exportación de directorios (`/etc/exports`):
~~~
/srv/nfs4 gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
/srv/nfs4/ucentralizados gss/krb5i(rw,sync,no_subtree_check)
~~~

Reiniciamos los servicios y comprobamos si se han montado:
~~~
root@croqueta:~# systemctl restart nfs-common
root@croqueta:~# systemctl restart nfs-kernel-server

# En caso de que el servicio nfs-common esté enmascarado, haremos lo siguiente:
root@croqueta:~# rm /lib/systemd/system/nfs-common.service
root@croqueta:~# systemctl daemon-reload

# Comprobación.
root@croqueta:~# showmount -e
Export list for croqueta.jesus.gonzalonazareno.org:
/srv/nfs4/ucentralizados gss/krb5i
/srv/nfs4                gss/krb5i
root@croqueta:~# 
~~~

Instalamos el cliente:
~~~
root@tortilla:~# apt install nfs-common
~~~

Configuramos el cliente:
~~~
# /etc/default/nfs-common
NEED_IDMAPD=yes
NEED_GSSD=yes

# /etc/idmapd.conf
Domain = jesus.gonzalonazareno.org
~~~

Modificamos el fichero `/etc/fstab` en ambos equipos para permitir montajes automáticos:
~~~
# Croqueta
/home/usuarios /srv/nfs4/ucentralizados none rw,bind 0 0

# Tortilla
croqueta:/ucentralizados /home/usuarios nfs4 rw,sec=krb5i 0 0

# Comprobación.
root@tortilla:~# ls -l /home/usuarios/
total 8
drwxr-xr-x 4 croqueta ucentralizados 4096 Mar  5 11:08 croqueta
drwxr-xr-x 2 tortilla ucentralizados 4096 Mar  5 10:59 tortilla
root@tortilla:~# 
~~~

## Correción de la tarea.
*Se hace login en tortilla con un usuario que esté en kerberos para lo que hay que facilitar la contraseña del principal:*
~~~
root@tortilla:~# login tortilla
Password: 
Last login: Sun Mar  8 18:13:27 UTC 2020 on pts/0
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-88-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Mar  8 19:22:06 UTC 2020

  System load:  0.0               Processes:           96
  Usage of /:   20.9% of 9.52GB   Users logged in:     1
  Memory usage: 42%               IP address for ens3: 10.0.0.10
  Swap usage:   0%

 * Latest Kubernetes 1.18 beta is now available for your laptop, NUC, cloud
   instance or Raspberry Pi, with automatic updates to the final GA release.

     sudo snap install microk8s --channel=1.18/beta --classic

 * Multipass 1.1 adds proxy support for developers behind enterprise
   firewalls. Rapid prototyping for cloud operations just got easier.

     https://multipass.run/

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

0 packages can be updated.
0 updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

tortilla@tortilla:~$ pwd
/home/usuarios/tortilla
tortilla@tortilla:~$
~~~

*Se comprueba que al hacer login se crea el TGT de kerberos y el TGS de LDAP mediante "klist -5":*
~~~
tortilla@tortilla:~$ klist -5
Ticket cache: FILE:/tmp/krb5cc_9502_Zzrp5w
Default principal: tortilla@JESUS.GONZALONAZARENO.ORG

Valid starting     Expires            Service principal
03/08/20 19:22:06  03/09/20 05:22:06  krbtgt/JESUS.GONZALONAZARENO.ORG@JESUS.GONZALONAZARENO.ORG
  renew until 03/09/20 19:22:06
03/08/20 19:22:07  03/09/20 05:22:06  nfs/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG
  renew until 03/09/20 19:22:06
tortilla@tortilla:~$ 
~~~

*El directorio home del usuario debe estar disponible a través de NFS4y se comprueba creando un fichero:*
~~~
# Tortilla
tortilla@tortilla:~$ touch prueba1.txt
tortilla@tortilla:~$ ls -l
total 0
-rw-r--r-- 1 tortilla ucentralizados 0 Mar  8 19:24 prueba1.txt
tortilla@tortilla:~$ 

# Croqueta
root@croqueta:~# ls -l /home/usuarios/tortilla/
total 0
-rw-r--r-- 1 tortilla ucentralizados 0 Mar  8 19:24 prueba1.txt
root@croqueta:~# 
~~~