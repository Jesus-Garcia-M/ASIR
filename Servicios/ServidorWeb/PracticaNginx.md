# Práctica Nginx.
### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|  
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorNginx"
  servidor.vm.network :public_network,:bridge=>"wlan0"
end
~~~

### Creación de los scripts ngxensite y ngxdissite.
- Creación del script `ngxensite` (`/bin/ngxensite`):
~~~
ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
systemctl restart nginx
~~~

- Creación del script `ngxdissite` (`/bin/ngxdissite`):
~~~
unlink /etc/nginx/sites-enabled/$1
systemctl restart nginx
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
root@servidorNginx:/srv/www# ngxensite iesgn
root@servidorNginx:/srv/www# ngxensite departamentos
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