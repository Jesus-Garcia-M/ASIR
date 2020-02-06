#### Crea 10 usuarios con los nombres que prefieras en LDAP, esos usuarios deben ser objetos de los tipos posixAccount e inetOrgPerson. Estos usuarios tendrán un atributo userPassword.
- Generación de las contraseñas de los empleados mediante la utilidad `slappasswd`:
~~~
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}3/wPLgCaYf+veauC8ZT5Z18ZMDgSx1ET
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}ROFk5Ne/bUNtrIT+/S9DSrux2fN9fR/7
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}GzSZ1lfFwdDVtWjNO6qQQ2rrmiRa/UxT
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}vYgBO0qcLWjx2afpIbOMD7j+HJnk4N2Y
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}V4Hrh+Z0PoEYWLKSi/UtDxAxtm/vTRT0
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}QQvNaEvjLnUh6lRPlff6ySKhRCiWCWgf
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}GlJ+aquxVg3L/PjbWFfeP8MaKQox+9uD
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}2DJYp8hSXfmwyfUGrpf5AibLN9DFk66l
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}vO6KsiDlAt8+e/1yXP5d2T/SCTQdrPxM
debian@croqueta:~$ /usr/sbin/slappasswd
New password: 
Re-enter new password: 
{SSHA}PIyn3d/tE32mwtjAjiihZRFKaQBGlvJx
debian@croqueta:~$
~~~

- Fichero de creación de usuarios (`usuarios.ldif`):
~~~
dn: cn=empleado1, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Odin
objectClass: posixAccount
uid: empleado1
uidNumber: 1001
gidNumber: 1001
userPassword: {SSHA}3/wPLgCaYf+veauC8ZT5Z18ZMDgSx1ET
homeDirectory: /home/empleado1

dn: cn=empleado2, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Tyr
objectClass: posixAccount
uid: empleado2
uidNumber: 1002
gidNumber: 1002
userPassword: {SSHA}ROFk5Ne/bUNtrIT+/S9DSrux2fN9fR/7
homeDirectory: /home/empleado2

dn: cn=empleado3, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Hel
objectClass: posixAccount
uid: empleado3
uidNumber: 1003
gidNumber: 1003
userPassword: {SSHA}GzSZ1lfFwdDVtWjNO6qQQ2rrmiRa/UxT
homeDirectory: /home/empleado3

dn: cn=empleado4, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Thor
objectClass: posixAccount
uid: empleado4
uidNumber: 1004
gidNumber: 1004
userPassword: {SSHA}vYgBO0qcLWjx2afpIbOMD7j+HJnk4N2Y
homeDirectory: /home/empleado4

dn: cn=empleado5, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Freyr
objectClass: posixAccount
uid: empleado5
uidNumber: 1005
gidNumber: 1005
userPassword: {SSHA}V4Hrh+Z0PoEYWLKSi/UtDxAxtm/vTRT0
homeDirectory: /home/empleado5

dn: cn=empleado6, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Frigg
objectClass: posixAccount
uid: empleado6
uidNumber: 1006
gidNumber: 1006
userPassword: {SSHA}QQvNaEvjLnUh6lRPlff6ySKhRCiWCWgf
homeDirectory: /home/empleado6

dn: cn=empleado7, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Loki
objectClass: posixAccount
uid: empleado7
uidNumber: 1007
gidNumber: 1007
userPassword: {SSHA}GlJ+aquxVg3L/PjbWFfeP8MaKQox+9uD
homeDirectory: /home/empleado7

dn: cn=empleado8, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Heimdall
objectClass: posixAccount
uid: empleado8
uidNumber: 1008
gidNumber: 1008
userPassword: {SSHA}2DJYp8hSXfmwyfUGrpf5AibLN9DFk66l 
homeDirectory: /home/empleado8

dn: cn=empleado9, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Freya
objectClass: posixAccount
uid: empleado9
uidNumber: 1009
gidNumber: 1009
userPassword: {SSHA}vO6KsiDlAt8+e/1yXP5d2T/SCTQdrPxM
homeDirectory: /home/empleado9

dn: cn=empleado10, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: inetOrgPerson
sn: Skadi
objectClass: posixAccount
uid: empleado10
uidNumber: 1010
gidNumber: 1010
userPassword: {SSHA}PIyn3d/tE32mwtjAjiihZRFKaQBGlvJx
homeDirectory: /home/empleado10
~~~

- Añadir los usuarios a `LDAP`:
~~~
debian@croqueta:~/LDAP/UsuariosGruposACLs$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f usuarios.ldif -W
Enter LDAP Password: 
adding new entry "cn=empleado1, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado2, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado3, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado4, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado5, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado6, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado7, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado8, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado9, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=empleado10, ou=People, dc=jesus, dc=gonzalonazareno, dc=org"

debian@croqueta:~/LDAP/UsuariosGruposACLs$
~~~

#### Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean objetos del tipo groupOfNames. Estos grupos serán: comercial, almacen y admin.
- Creación de la unidad organizativa `Empresa` y los grupos `Admin`, `Almacen` y `Comercial` (`grupos.ldif`):
~~~
# Unidad Organizativa.
dn: ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: organizationalUnit
ou: Empresa

# Grupos.
dn: cn=admin, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: groupOfNames
cn: admin
member: cn=empleado5, ou=People, dc=jesus, dc=gonzalonazareno, dc=org

dn: cn=almacen, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member: cn=empleado3, ou=People, dc=jesus, dc=gonzalonazareno, dc=org

dn: cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member: cn=empleado1, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- Añadir la unidad organizativa y los nuevos grupos a `LDAP`:
~~~
debian@croqueta:~/LDAP/UsuariosGruposACLs$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f grupos.ldif -W
Enter LDAP Password: 
adding new entry "ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

adding new entry "cn=admin, ou=Empresa, dc=jesus,dc=gonzalonazareno,dc=org"

adding new entry "cn=almacen, ou=Empresa, dc=jesus,dc=gonzalonazareno,dc=org"

adding new entry "cn=comercial, ou=Empresa, dc=jesus,dc=gonzalonazareno,dc=org"

debian@croqueta:~/LDAP/UsuariosGruposACLs$
~~~

#### Añadir usuarios que pertenezcan a:
- Solo al grupo `Comercial`:
~~~
dn: cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado2, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- Solo al grupo `Almacen`:
~~~
dn: cn=almacen, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado4, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- A los grupos `Almacen` y `Comercial`:
~~~
dn: cn=almacen, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado7, ou=People, dc=jesus, dc=gonzalonazareno, dc=org

dn: cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado7, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- A los grupos `Admin` y `Comercial`:
~~~
dn: cn=admin, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado8, ou=People, dc=jesus, dc=gonzalonazareno, dc=org

dn: cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado8, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- Solo al grupo `Admin`:
~~~
dn: cn=admin, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org
changetype: modify
add: member
member: cn=empleado9, ou=People, dc=jesus, dc=gonzalonazareno, dc=org
~~~

- Realizar los cambios en `LDAP`:
~~~
debian@croqueta:~/LDAP/UsuariosGruposACLs$ ldapmodify -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f cambiosgrupos.ldif -W
Enter LDAP Password: 
modifying entry "cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=almacen, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=almacen, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=admin, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=comercial, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

modifying entry "cn=admin, ou=Empresa, dc=jesus, dc=gonzalonazareno, dc=org"

debian@croqueta:~/LDAP/UsuariosGruposACLs$ 
~~~

#### Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los que pertenece cada usuario a través del atributo "memberOf".
- Comprobar si hay algún módulo cargado:
~~~
debian@croqueta:~$ sudo slapcat -n 0 |grep olcModuleLoad
olcModuleLoad: {0}back_mdb
debian@croqueta:~$
~~~

- Ya que hay módulos cargados, es necesario modificar el sistema usando `ldapmodify` en vez de añadir un nuevo módulo usando `ldapadd`:
~~~
#----- Contenido del fichero memberof.ldif -----#
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: memberof.la

#----- Realizar el cambio en LDAP -----#

~~~

#### Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver todos los atributos de todos los usuarios pero solo puedan modificar los suyos.


#### Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y modificar cualquier atributo de cualquier objeto.