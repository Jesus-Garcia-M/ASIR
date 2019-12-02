### Instalación.
- Instalación del servidor:
~~~
debian@croqueta:~$ sudo apt install slapd
~~~

- Instalación del cliente:
~~~
debian@croqueta:~$ sudo apt install ldap-utils
~~~

### Operaciones.
- Busqueda anónima:
~~~
ldapsearch -x -b dc=jesus,dc=gonzalonazareno,dc=org
~~~

- Busqueda autenticada:
~~~
ldapsearch -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -b dc=jesus,dc=gonzalonazareno,dc=org -W
~~~

- Añadir ficheros:
~~~
ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f {fichero.ldif} -W
~~~

- Conexión a través de socket:
~~~
ldapmodify -Y EXTERNAL -H ldapi:///
~~~

### Ejercicio 1: Creación de una estructura básica.
- Contenido ficheros:
~~~
#----- Contenido arbol.ldif -----#
dn: ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: organizationalUnit
ou: People

dn: ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: organizationalUnit
ou: Groups

#----- Contenido personas.ldif -----#
dn: cn=UmFtw7NuIEdhcmPDrWEK,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn:: UmFtw7NuIEdhcmPDrWEK
localityName: Dos Hermanas
sn:: R2FyY8OtYQo=

dn: cn=Luisa Ayuso,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn: Luisa Ayuso
localityName: Dos Hermanas
sn: Ayuso

dn: cn=RWZyYcOtbiBNYW5zbwo=,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn:: RWZyYcOtbiBNYW5zbwo=
localityName:: QWxjYWzDoSBkZSBHdWFkYcOtcmEK
sn: Manso

dn: cn=ventas,ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: ventas
description: Departamento de Ventas
member: cn=RWZyYcOtbiBNYW5zbwo=,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
member: cn=Luisa Ayuso,ou=People,dc=jesus,dc=gonzalonazareno,dc=org

dn: cn=compras,ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: compras
description: Departamento de Compras
member: cn=UmFtw7NuIEdhcmPDrWEK,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
~~~

- Añadir los ficheros:
~~~
debian@croqueta:~$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f arbol.ldif -W
debian@croqueta:~$ ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f personas.ldif -W

#----- Comprobación -----#
debian@croqueta:~$ ldapsearch -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -b dc=jesus,dc=gonzalonazareno,dc=org -W
Enter LDAP Password: 
# extended LDIF
#
# LDAPv3
# base <dc=jesus,dc=gonzalonazareno,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# jesus.gonzalonazareno.org
dn: dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: jesus.gonzalonazareno.org
dc: jesus

# admin, jesus.gonzalonazareno.org
dn: cn=admin,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9UVlRZjdTaUdCRWpUc0VqMERoTks4bzRreE9KNjhrb2g=

# People, jesus.gonzalonazareno.org
dn: ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: organizationalUnit
ou: People

# Groups, jesus.gonzalonazareno.org
dn: ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: organizationalUnit
ou: Groups

# UmFtw7NuIEdhcmPDrWEK, People, jesus.gonzalonazareno.org
dn: cn=UmFtw7NuIEdhcmPDrWEK,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn:: UmFtw7NuIEdhcmPDrWEK
cn: UmFtw7NuIEdhcmPDrWEK
l: Dos Hermanas
sn:: R2FyY8OtYQo=

# Luisa Ayuso, People, jesus.gonzalonazareno.org
dn: cn=Luisa Ayuso,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn: Luisa Ayuso
l: Dos Hermanas
sn: Ayuso

# RWZyYcOtbiBNYW5zbwo\3D, People, jesus.gonzalonazareno.org
dn: cn=RWZyYcOtbiBNYW5zbwo\3D,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalPerson
objectClass: person
cn:: RWZyYcOtbiBNYW5zbwo=
cn: RWZyYcOtbiBNYW5zbwo=
l:: QWxjYWzDoSBkZSBHdWFkYcOtcmEK
sn: Manso

# ventas, Groups, jesus.gonzalonazareno.org
dn: cn=ventas,ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: ventas
description: Departamento de Ventas
member: cn=RWZyYcOtbiBNYW5zbwo\3D,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
member: cn=Luisa Ayuso,ou=People,dc=jesus,dc=gonzalonazareno,dc=org

# compras, Groups, jesus.gonzalonazareno.org
dn: cn=compras,ou=Groups,dc=jesus,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: compras
description: Departamento de Compras
member: cn=UmFtw7NuIEdhcmPDrWEK,ou=People,dc=jesus,dc=gonzalonazareno,dc=org

# search result
search: 2
result: 0 Success

# numResponses: 10
# numEntries: 9
debian@croqueta:~$ 
~~~

### Ejercicio 2: Añadir atributos a los elementos existentes.
- Añadir los siguientes atributos:
	- Teléfono.
	- Dirección Postal.
	- Nombre de pila.
	- Correo-e.
	- Foto en jpg.

- Modificación de los usuarios:
~~~
dn: cn=UmFtw7NuIEdhcmPDrWEK,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
changetype: modify
add: givenName
givenName: Ramón
-
add: mail
mail: ramong@gamil.com
-
add: mobile
mobile: 217228440
-
add: postalAddress
postalAddress: Quinta Avenida 1
-
add: jpegPhoto
jpegPhoto:< file:///home/debian/images/otter.jpg

dn: cn=Luisa Ayuso,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
changetype: modify
add: givenName
givenName: Luisa
-
add: mail
mail: luisaa@gamil.com
-
add: mobile
mobile: 350640951
-
add: postalAddress
postalAddress: Quinta Avenida 2
-
add: jpegPhoto
jpegPhoto:< file:///home/debian/images/otter2.jpg

dn: cn=RWZyYcOtbiBNYW5zbwo=,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
changetype: modify
add: givenName
givenName: Efraín
-
add: mail
mail: efrainm@gamil.com
-
add: mobile
mobile: 674059157
-
add: postalAddress
postalAddress: Quinta Avenida 3
-
add: jpegPhoto
jpegPhoto:< file:///home/debian/images/otter3.jpg
~~~