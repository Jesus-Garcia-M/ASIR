# Práctica Apache2.
### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorApache"
  servidor.vm.network :public_network,:bridge=>"wlan0"
end
~~~

### Configuración de virtual hosting.
- Creación de la estructura de directorios y asignación de permisos:
~~~
vagrant@servidorApache:/srv/www$ ls -l
total 8
drwxr-xr-x 2 www-data www-data 4096 Oct  8 08:02 departamento
drwxr-xr-x 2 www-data www-data 4096 Oct  8 08:02 iesgn
vagrant@servidorApache:/srv/www$ 
~~~

- Activación del directorio `/srv/www` (`/etc/apache2/apache2.conf`):
~~~
<Directory /srv/www>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
~~~

- Modificación del fichero de configuración `iesgn.conf` (`/etc/apache2/sites-enabled`):
~~~
...
ServerName www.iesgn.org
DocumentRoot /srv/www/iesgn
...
~~~

- Modificación del fichero de configuración `departamento.conf` (`/etc/apache2/sites-enabled`):
~~~
...
ServerName departamentos.iesgn.org
DocumentRoot /srv/www/departamento
...
~~~

- Activación de los sitios web:
~~~
vagrant@servidorApache:~$ sudo a2ensite iesgn.conf
Enabling site iesgn.
To activate the new configuration, you need to run:
  systemctl reload apache2 
vagrant@servidorApache:~$ sudo a2ensite departamento.conf
Enabling site departamento.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@servidorApache:~$
~~~

- Resolución estática en los clientes:
~~~
# Práctica Apache2
172.22.9.56	www.iesgn.org
172.22.9.56	departamentos.iesgn.org
~~~

### Creación de redirección.
- Creación de la redirección del sitio `www.iesgn.org` a `www.iesgn.org/principal` (`/etc/apache2/sites-enabled/iesgn.conf`):
~~~
# Redirección:
RedirectMatch ^/$ http://www.iesgn.org/principal/
<Directory "/srv/www/iesgn/principal">
	Require all granted
</Directory>
~~~

### Creación de alias.
- Creación del alias `www.iesgn.org/principal/documentos` a `/srv/doc` (`/etc/apache2/sites-enabled/iesgn.conf`):
~~~
# Alias:
Alias "/principal/documentos" "/srv/doc"
<Directory "/srv/doc">
	Options Indexes FollowSymLinks
	Require all granted
</Directory>
~~~

- Creación del enlace simbólico:
~~~
root@servidorApache:/srv/doc# ln -s /srv/www/iesgn/pruebasymlink.html pruebasymlink
root@servidorApache:/srv/doc# ls -l
total 0
-rw-r--r-- 1 www-data www-data  0 Oct  9 07:45 prueba1.txt
-rw-r--r-- 1 www-data www-data  0 Oct  9 07:45 prueba2.txt
-rw-r--r-- 1 www-data www-data  0 Oct  9 07:45 prueba3.txt
lrwxrwxrwx 1 root     root     31 Oct  9 07:52 pruebasymlink -> ../www/iesgn/pruebasymlink.html
root@servidorApache:/srv/doc# 
~~~

### Modificación de mensajes de error.
- Creación del mensaje de error 404 (`/srv/www/{V.host}/error/404.html`):
~~~
<h1 style='color:red'>
  Error 404: Not found
</h1>

<p>
El recurso al que se intenta acceder no existe en el servidor.
</p>
~~~

- Creación del mensaje de error 403 (`/srv/www/{V.host}/error/403.html`):
~~~
<h1 style='color:red'>
  Error 403: Forbidden
</h1>
<p>
No tienes permisos para acceder a ese recurso.
</p>
~~~

- Añadir el directorio de errores a la configuración del sitio `www.iesgn.org` (`/etc/apache2/sites-enabled/iesgn.conf`):
~~~
# Mensajes de error custom
ErrorDocument 404 /error/404.html
ErrorDocument 403 /error/403.html
~~~

- Añadir el directorio de errores a la configuración del sitio `departamentos.iesgn.org` (`/etc/apache2/sites-enabled/departamento.conf`):
~~~
# Mensajes de error custom
ErrorDocument 404 /error/404.html
ErrorDocument 403 /error/403.html
~~~

### Modificación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorApache"
  servidor.vm.network :public_network,:bridge=>"wlan0"
  servidor.vm.network :private_network, ip: "192.168.1.1",
    virtualbox__intnet: "apache2"
end

config.vm.define :cliente do |cliente|
  cliente.vm.box = "buster"
  cliente.vm.hostname = "clienteApache"
  cliente.vm.network :private_network, ip: "192.168.1.2",
    virtualbox__intnet: "apache2"
end
~~~

### Restricciones de acceso.
- Modificación del sitio `departamentos.iesgn.org/intranet` (`/etc/apache2/sites-enabled/departamento.conf`):
~~~
# Restricción de acceso
<Directory /srv/www/departamento/intranet>
  Require ip 192.168
</Directory>
~~~

- Modificación del sitio `departamentos.iesgn.org/internet` (`/etc/apache2/sites-enabled/departamento.conf`):
~~~
<Directory /srv/www/departamento/internet>
  <RequireAll>
    Require all granted
    Require not ip 192.168
  </RequireAll>
</Directory>
~~~

### Autentificación básica.
- Modificación del sitio `departamentos.iesgn.org/secreto` (`/etc/apache2/sites-enabled/departamento.conf`):
~~~
# Autentificación básica
<Directory /srv/www/departamento/secreto>
  AuthUserFile "/etc/apache2/autentificacion/basica.txt"
  AuthName "Identificate:"
  AuthType Basic
  Require valid-user
</Directory>
~~~

- Creación de usuarios:
~~~
root@servidorApache:/etc/apache2/autentificacion# htpasswd -c basica.txt jesus
New password:
Re-type new password:
Adding password for user jesus
root@servidorApache:/etc/apache2/autentificacion# htpasswd basica.txt prueba
New password:
Re-type new password:
Adding password for user prueba
root@servidorApache:/etc/apache2/autentificacion# cat basica.txt
jesus:$apr1$.1oUZwv2$DRfFDBE7RUmvg9jLHJoPC1
prueba:$apr1$tmaULcP9$BFoDAA0W0nKoawp.43f9d/
root@servidorApache:/etc/apache2/autentificacion# 
~~~

### Autentificación digest.
- Activación del módulo:
~~~
root@servidorApache:~# a2enmod auth_digest
Considering dependency authn_core for auth_digest:
Module authn_core already enabled
Enabling module auth_digest.
To activate the new configuration, you need to run:
  systemctl restart apache2
root@servidorApache:~# 
~~~

- Modificación del sitio `departamentos.iesgn.org/secreto` (`/etc/apache2/sites-enabled/departamento.conf`):
~~~
# Autentificación Digest.
  <Directory /srv/www/departamento/secreto>
    AuthType Digest
    AuthName "directivos"

    AuthDigestDomain "/secreto/"

    AuthDigestProvider file
    AuthUserFile "/etc/apache2/autentificacion/digest.txt"
    Require valid-user
  </Directory>
~~~

- Creación de los usuario pertenecientes al grupo `directivos`:
~~~
root@servidorApache:/etc/apache2/autentificacion# htdigest -c digest.txt directivos jesus
Adding password for jesus in realm directivos.
New password: 
Re-type new password: 
root@servidorApache:/etc/apache2/autentificacion# htdigest digest.txt directivos usuario
Adding user usuario in realm directivos
New password: 
Re-type new password: 
root@servidorApache:/etc/apache2/autentificacion# cat digest.txt
jesus:directivos:a95bf7786eb873d129179ad1ac11f2ca
usuario:directivos:de645231fdc2d3676d96dc8ebc56d403
root@servidorApache:/etc/apache2/autentificacion# 
~~~

### Combinación de restricción de acceso y autentificación digest.
