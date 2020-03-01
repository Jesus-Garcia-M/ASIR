# Kerberos

### LDAP.
Usuarios ldap:
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

Añadir usuarios:
~~~
debian@croqueta:~/Kerberos/LDAP$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f usuarios.ldif -W
Enter LDAP Password: 
adding new entry "cn=ucentralizados, ou=Groups, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "uid=croqueta, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "uid=tortilla, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

debian@croqueta:~/Kerberos/LDAP$ 
~~~

Creación de los directorios home:
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

### Name Service Switch.
Instalación de `libnss-ldapd`:
~~~
root@croqueta:~# apt install --no-install-recommends libnss-ldapd
~~~

Configuración (`/etc/nsswitch.conf`):
~~~
passwd: files ldap
group: files ldap
~~~

Comprobación:
~~~
root@croqueta:~# ls -la /home/usuarios/croqueta/
total 20
drwxr-xr-x 2 croqueta ucentralizados 4096 Feb 24 18:09 .
drwxr-xr-x 4 root     root           4096 Feb 24 17:57 ..
-rw-r--r-- 1 croqueta ucentralizados  220 Feb 24 18:02 .bash_logout
-rw-r--r-- 1 croqueta ucentralizados 3526 Feb 24 18:02 .bashrc
-rw-r--r-- 1 croqueta ucentralizados  807 Feb 24 18:02 .profile
root@croqueta:~# 
~~~

Adicionalmente instalaremos el paquete `nscd` que cacheará la resolución UID/GID con sus respectivos nombres para una resolución más rápida:
~~~
root@croqueta:~# apt install nscd
~~~

### Kerberos (Server).
Instalación:
~~~
root@croqueta:~# apt install krb5-kdc krb5-admin-server
~~~

Configuración (`/etc/krb5kdc/kdc.conf`):
~~~
[kdcdefaults]
    # Dejamos únicamente el puerto 88, ya que el 750 es utilizado por Kerberos 4.
    kdc_ports = 88

[realms]
    JESUS.GONZALONAZARENO.ORG = {
        database_name = /var/lib/krb5kdc/principal
        admin_keytab = FILE:/etc/krb5kdc/kadm5.keytab
        acl_file = /etc/krb5kdc/kadm5.acl
        key_stash_file = /etc/krb5kdc/stash
        kdc_ports = 750,88
        max_life = 10h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = des3-hmac-sha1
        # Habilitamos distintos tipos de encriptación.
        supported_enctypes = aes256-cts:normal arcfour-hmac:normal des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm des:afs3
        default_principal_flags = +preauth
    }
~~~

Configuración del cliente (`/etc/krb5.conf`):
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

Inicio de los servicios:
~~~
root@croqueta:~# krb5_newrealm
This script should be run on the master KDC/admin server to initialize
a Kerberos realm.  It will ask you to type in a master key password.
This password will be used to generate a key that is stored in
/etc/krb5kdc/stash.  You should try to remember this password, but it
is much more important that it be a strong password than that it be
remembered.  However, if you lose the password and /etc/krb5kdc/stash,
you cannot decrypt your Kerberos database.
Loading random data
Initializing database '/var/lib/krb5kdc/principal' for realm 'JESUS.GONZALONAZARENO.ORG',
master key name 'K/M@JESUS.GONZALONAZARENO.ORG'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 


Now that your realm is set up you may wish to create an administrative
principal using the addprinc subcommand of the kadmin.local program.
Then, this principal can be added to /etc/krb5kdc/kadm5.acl so that
you can use the kadmin program on other computers.  Kerberos admin
principals usually belong to a single user and end in /admin.  For
example, if jruser is a Kerberos administrator, then in addition to
the normal jruser principal, a jruser/admin principal should be
created.

Don't forget to set up DNS information so your clients can find your
KDC and admin servers.  Doing so is documented in the administration
guide.
root@croqueta:~# 

#----- Comprobación del funcionamiento -----#
root@croqueta:~# netstat -putan |grep "krb5kdc\|kadmind"
tcp        0      0 0.0.0.0:749             0.0.0.0:*               LISTEN      4772/kadmind        
tcp        0      0 0.0.0.0:464             0.0.0.0:*               LISTEN      4772/kadmind        
tcp        0      0 0.0.0.0:88              0.0.0.0:*               LISTEN      4749/krb5kdc        
tcp6       0      0 :::749                  :::*                    LISTEN      4772/kadmind        
tcp6       0      0 :::464                  :::*                    LISTEN      4772/kadmind        
tcp6       0      0 :::88                   :::*                    LISTEN      4749/krb5kdc        
udp        0      0 0.0.0.0:464             0.0.0.0:*                           4772/kadmind        
udp        0      0 0.0.0.0:750             0.0.0.0:*                           4749/krb5kdc        
udp        0      0 0.0.0.0:88              0.0.0.0:*                           4749/krb5kdc        
udp6       0      0 :::464                  :::*                                4772/kadmind        
udp6       0      0 :::750                  :::*                                4749/krb5kdc        
udp6       0      0 :::88                   :::*                                4749/krb5kdc        
root@croqueta:~# 
~~~

Creación de los principales:
~~~
kadmin.local:  add_principal croqueta
WARNING: no policy specified for croqueta@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Enter password for principal "croqueta@JESUS.GONZALONAZARENO.ORG": 
Re-enter password for principal "croqueta@JESUS.GONZALONAZARENO.ORG": 
Principal "croqueta@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal -randkey host/croqueta.jesus.gonzalonazareno.org
WARNING: no policy specified for host/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "host/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal -randkey host/tortilla.jesus.gonzalonazareno.org
WARNING: no policy specified for host/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "host/tortilla.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:  add_principal -randkey ldap/croqueta.jesus.gonzalonazareno.org
WARNING: no policy specified for ldap/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG; defaulting to no policy
Principal "ldap/croqueta.jesus.gonzalonazareno.org@JESUS.GONZALONAZARENO.ORG" created.
kadmin.local:
~~~

Creación de un fichero `keytab` para almacenar las claves de los usuarios:
~~~
kadmin.local:  ktadd host/croqueta.jesus.gonzalonazareno.org
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  ktadd host/tortilla.jesus.gonzalonazareno.org
Entry for principal host/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/tortilla.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  ktadd ldap/croqueta.jesus.gonzalonazareno.org
Entry for principal ldap/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal ldap/croqueta.jesus.gonzalonazareno.org with kvno 2, encryption type des-cbc-crc added to keytab FILE:/etc/krb5.keytab.
kadmin.local:  
~~~



### Kerberos (Clientes).
Instalación:
~~~
# Croqueta:
krb5-config krb5-user

# Tortilla:

~~~