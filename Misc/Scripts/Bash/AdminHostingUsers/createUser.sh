#!/bin/sh

# Variables.
serial=`date +%H%M%S`" ; Serial"

# Creates the new system user.
echo "Creating the new system user..."
id -u $1 > /dev/null 2>&1
if [ $? -eq 1 ]; then
  useradd -p $(openssl passwd -1 $1_ftp) $1
else
  echo "ERROR: The user already exists."
fi

# Creates the LDAP entry.
#echo "dn: cn=$1,ou=People,dc=jesus,dc=gonzalonazareno,dc=org" > ldapuser.ldif
#echo "objectClass: top" >> ldapuser.ldif
#echo "objectClass: organizationalPerson" >> ldapuser.ldif
#echo "objectClass: person" >> ldapuser.ldif
#echo "objectClass: shadowAccount" >> ldapuser.ldif
#echo "objectClass: posixAccount" >> ldapuser.ldif
#echo "uid: $1" >> ldapuser.ldif
#echo "cn: $1" >> ldapuser.ldif
#echo "sn: $1" >> ldapuser.ldif
#echo """dn: cn=$1,ou=People,dc=jesus,dc=gonzalonazareno,dc=org
#        objectClass: top
#        objectClass: organizationalPerson
#        objectClass: person
#        objectClass: shadowAccount
#        objectClass: posixAccount
#        uid: $1
#        cn: $1
#        sn: $1
#        userPassword: $ftp_ldap
#        homeDirectory: /var/www/$1-$2
#ldapadd -x -D 'cn=admin, dc=jesus, dc=gonzalonazareno, dc=org' -f ldapuser.ldif -w root

# Creates the custom virtualhost (Apache2).
echo "Creating the custom virtualhost..."
mkdir /var/www/$1-$2
chown -R $1:www-data /var/www/$1-$2
sed -e "s/dir/$1-$2/" -e "s/site-url/$2/" nginx-template > /etc/apache2/sites-available/$1-$2.conf
a2ensite $1-$2.conf
systemctl restart apache2

# Creates the custom virtualhost (Nginx).
echo "Creating the custom virtualhost..."
mkdir /var/www/$1-$2
cp index.html /var/www/$1-$2
chown -R nginx:nginx /var/www/$1-$2
sed -e "s/dir/$1-$2/" -e "s/site-url/$2/" nginx-template > /etc/nginx/conf.d/$1-$2.conf
systemctl restart nginx

# Creates the new database and user.
echo "Creating the new database and database user..."
echo "CREATE DATABASE my$1;" > createdb
echo "GRANT ALL ON my$1.* TO hosting_$1g@salmorejo.jesus.gonzalonazareno.org IDENTIFIED BY '$1_mysql';" >> createdb
ssh root@tortilla mysql < createdb

# Creates the new DNS entry.
echo "Creating the new DNS entry..."
ssh root@croqueta "echo "$2 IN CNAME salmorejo" >> /var/cache/bind/db.interna.jesus.gonzalonazareno.org &&
                  sed -i '/Serial/c\\$serial' /var/cache/bind/db.interna.jesus.gonzalonazareno.org &&
                  echo "$2 IN CNAME salmorejo" >> /var/cache/bind/db.externa.jesus.gonzalonazareno.org &&
                  sed -i '/Serial/c\\$serial' /var/cache/bind/db.externa.jesus.gonzalonazareno.org &&
                  systemctl restart bind9"




# Creates the new LDAP entry.
echo "dn: cn=$1,ou=People,dc=jesus,dc=gonzalonazareno,dc=org" > user.ldif
echo "objectClass: top" >> user.ldif
echo "objectClass: organizationalPerson" >> user.ldif
echo "objectClass: person" >> user.ldif
echo "cn:$1" >> user.ldif
echo "sn:$1" >> user.ldif
echo "Adding the new LDAP entry..."
# (Testear) ssh root@croqueta ldapadd -x -D "cn=admin, dc=jesus, dc=gonzalonazareno, dc=org" -f user.ldif -W