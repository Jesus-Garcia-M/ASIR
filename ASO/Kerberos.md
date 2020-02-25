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
Instalación de `libnss-slapd`:
~~~
root@croqueta:~# apt install --no-install-recommends libnss-ldapd
~~~