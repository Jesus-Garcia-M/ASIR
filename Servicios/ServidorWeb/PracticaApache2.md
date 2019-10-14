# Práctica Apache2.
### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorApache"
  servidor.vm.network :public_network,:bridge=>"wlan0"
end
~~~

### Configuración de virtual hostings.
- Creación de la estructura de directorios y asignación de permisos:
~~~
vagrant@servidorApache:/srv/www$ ls -l
total 8
drwxr-xr-x 2 www-data www-data 4096 Oct  8 08:02 departamento
drwxr-xr-x 2 www-data www-data 4096 Oct  8 08:02 iesgn
vagrant@servidorApache:/srv/www$ 
~~~

- Activación del directorio `/srv/www` en `/etc/apache2/apache2.conf`:
~~~
<Directory /srv/www>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
~~~

- Modificación del fichero de configuración `iesgn.conf` (`/etc/apache2/sites-available`):
~~~
...
ServerName www.iesgn.org
DocumentRoot /srv/www/iesgn
...
~~~

- Modificación del fichero de configuración `departamento.conf` (`/etc/apache2/sites-available`):
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
- Creación de la redirección en el fichero `iesgn.conf`:
~~~
# Redirección:
RedirectMatch ^/$ http://www.iesgn.org/principal/
<Directory "/srv/www/iesgn/principal">
	Require all granted
</Directory>
~~~

### Creación de alias.
- Creación del alias `www.iesgn.org/principal/documentos` a `/srv/doc` en el fichero `iesgn.conf` (`/etc/apache2/sites-available`):
~~~
# Alias:
Alias "/principal/documentos" "/srv/doc"
<Directory "/srv/doc">
	Options Indexes FollowSymLinks
	Require all granted
</Directory>
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

- Añadir el directorio de errores a la configuración del sitio `departamentos.iesgn.org` (`/etc/apache2/sites-enabled/iesgn.conf`):
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
