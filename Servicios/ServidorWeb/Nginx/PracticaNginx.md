# Práctica Nginx.
### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorNginx"
  servidor.vm.network :public_network,:bridge=>"wlan0"
end
~~~

### Configuración de virtual hosting.
- Creación de la estructura de directorios y asignación de permisos.
~~~
root@servidorNginx:/srv/www# ls -l
total 8
drwxr-xr-x 2 www-data www-data 4096 Oct 16 06:44 departamentos
drwxr-xr-x 2 www-data www-data 4096 Oct 16 06:43 iesgn
root@servidorNginx:/srv/www# 
~~~

- Modificación del fichero de configuración `iesgn` (`/etc/nginx/sites-enabled`):
~~~
server {
  listen 80;

  root /srv/www/iesgn;
  index index.html;

  server_name www.iesgn.org;
}
~~~

- Modificación del fichero de configuración `departamentos` (`/etc/apache2/sites-enabled`):
~~~
server {
  listen 80;

  root /srv/www/departamentos;
  index index.html;

  server_name departamentos.iesgn.org;
}
~~~

- Activación de los sitios web:
~~~
root@servidorNginx:/srv/www# ngensite iesgn
root@servidorNginx:/srv/www# ngensite departamentos
root@servidorNginx:/srv/www#
~~~

- Resolución estática en los clientes:
~~~
# Práctica Nginx
172.22.7.217 www.iesgn.org
172.22.7.217 departamentos.iesgn.org
~~~

### Creación de redirección.
- Creación de la redirección del sitio `www.iesgn.org` a `www.iesgn.org/principal` (`/etc/nginx/sites-enabled/iesgn`):
~~~
# Redirección temporal.
rewrite ^/$ http://www.iesgn.org/principal redirect;

# Redirección permanente.
rewrite ^/$ http://www.iesgn.org/principal permanent;
~~~

### Creación de alias.
- Creación del alias `www.iesgn.org/principal/documentos` a `/srv/doc` (`/etc/nginx/sites-enabled/iesgn`):
~~~
# Alias.
location /principal/documentos/ {
  alias /srv/doc/;
  autoindex on;
  disable_symlinks off;
}
~~~

- Creación del enlace simbólico:
~~~
root@servidorNginx:~# ln -s /srv/www/iesgn/principal/pruebasymlink.txt
root@servidorNginx:~# ls -l /srv/doc
total 0
-rw-r--r-- 1 www-data www-data  0 Oct 22 07:11 prueba_alias1.txt
-rw-r--r-- 1 www-data www-data  0 Oct 22 07:11 prueba_alias2.txt
lrwxrwxrwx 1 www-data www-data 42 Oct 22 08:09 pruebasymlink.txt -> /srv/www/iesgn/principal/pruebasymlink.txt
root@servidorNginx:~# 
~~~

### Modificación de mensajes de error.
- Creación del mensaje de error 404 (`/srv/www/{V.host}/errors/custom404.html`):
~~~
<h1 style='color:red'>
  Error 404: Not found
</h1>

<p>
El recurso al que se intenta acceder no existe.
</p>
~~~

- Creación del mensaje de error 403 (`/srv/www/{V.host}/errors/custom403.html`):
~~~
<h1 style='color:red'>
  Error 403: Forbidden
</h1>
<p>
No tienes permisos para acceder a ese recurso.
</p>
~~~

- Añadir el directorio de errores a la configuración del sitio `www.iesgn.org` (`/etc/nginx/sites-enabled/iesgn`):
~~~
server {
  listen 80;

  root /srv/www/iesgn;
  index index.html;
  server_name www.iesgn.org;

# Mensajes de error.
error_page 404 /custom404.html;
location = /custom404.html {
  root /srv/www/iesgn/errors;
  internal;
}

error_page 403 /custom403.html;
location = /custom403.html {
  root /srv/www/iesgn/errors;
  internal;
}
~~~

- Añadir el directorio de errores a la configuración del sitio `departamentos.iesgn.org` (`/etc/nginx/sites-enabled/departamentos`):
~~~
server {
  listen 80;

  root /srv/www/departamentos;
  index index.html;
  server_name departamentos.iesgn.org;

# Mensajes de error.
error_page 404 /custom404.html;
location = /custom404.html {
  root /srv/www/departamentos/errors;
  internal;
}

error_page 403 /custom403.html;
location = /custom403.html {
  root /srv/www/departamentos/errors;
  internal;
}
~~~

### Modificación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorNginx"
  servidor.vm.network :public_network,:bridge=>"wlan0"
  servidor.vm.network :private_network, ip: "192.168.1.10",
    virtualbox__intnet: "nginx"
end

config.vm.define :cliente do |cliente|
  cliente.vm.box = "buster"
  cliente.vm.hostname = "clienteNginx"
  cliente.vm.network :private_network, ip: "192.168.1.2",
    virtualbox__intnet: "nginx"
end
~~~

### Restricciones de acceso.
- Configuración de control de acceso en el sitio `departamentos.iesgn.org` (`/etc/nginx/sites-available/departamentos`):
~~~
# Restricción de acceso.
location = /intranet {
  root /srv/www/departamentos;
  allow 192.168.1.0/24;
  deny all;
}

location = /internet {
  root /srv/www/departamentos;
  deny 192.168.1.0/24;
  allow all;
}
~~~

### Autenticación básica.
- Instalación de `apache2-utils`:
~~~
root@servidorNginx:~# apt install apache2-utils
~~~

- Creación de usuarios (`/etc/nginx/usuarios`):
~~~
root@servidorNginx:~# htpasswd -c /etc/nginx/usuarios jesus
New password: 
Re-type new password: 
Adding password for user jesus
root@servidorNginx:~# htpasswd /etc/nginx/usuarios prueba
New password: 
Re-type new password: 
Adding password for user prueba
root@servidorNginx:~# cat /etc/nginx/usuarios
jesus:$apr1$F2e3e6hg$mRgCr.jf2zTpak3xl1gVc.
prueba:$apr1$sQGrnzxu$7cXZm1pvWo69qtawOlku7/
root@servidorNginx:~#
~~~

- Configuración del sitio `departamentos.iesgn.org/secreto` (`/etc/nginx/sites-available/departamentos`):
~~~
# Autenticación básica.
location = /secreto {
  root /srv/www/departamentos;
  auth_basic "Área Restringida:";
  auth_basic_user_file /etc/nginx/usuarios;
}
~~~

### Autenticación básica + Restricción de acceso.
- Configuración del sitio `departamentos.iesgn.org/secreto` (`/etc/nginx/sites-available/departamentos`):
~~~

~~~