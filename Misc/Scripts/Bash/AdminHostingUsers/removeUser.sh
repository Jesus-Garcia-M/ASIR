#!/bin/sh

# Removes the system user.
deluser $1

# Removes the virtualhost.
a2dissite $2.conf
rm /etc/apache2/sites-available/$2.conf
rm -rf /var/www/$2
systemctl restart apache2

# Removes the ldap entry.


# Drops the database and database user.
echo "DROP DATABASE $1_db;" > dropdb
echo "DROP USER $1@salmorejo;" >> dropdb
mysql < dropdb

# Removes the DNS entry.
echo "Deleting the DNS entry..."
ssh debian@croqueta sed -i '/$2/d' /var/cache/bind/db.interna.jesus.gonzalonazareno.org
