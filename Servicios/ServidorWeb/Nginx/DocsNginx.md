### Directorios y ficheros de configuración.
- `/etc/nginx/sites-available`: Directorio contenedor de los sitios web disponibles.
- `/etc/nginx/sites-enabled`: Directorio contenedor de los sitios web activos.
- `/etc/nginx/conf-availabe`: Directorio contenedor de las configuraciones disponibles.
- `/etc/nginx/conf-enabled`: Directorio contenedor de las configuraciones activas.
- `/etc/nginx/mod-available`: Directorio contenedor de los módulos disponibles.
- `/etc/nginx/mod-enables`: Directorio contenedor de los módulos activas.
- `/etc/nginx/ports.conf`: Fichero de configuración de puertos.
- `/etc/nginx/nginx.conf`: Fichero de configuración de los directorios de trabajo.

### Uso de PHP.
- Instalación de `php-fpm`:
~~~
root@servidorNginx:~# apt install php-fpm
~~~

- Modificación de grupo y usuario de `php-fpm` (`/etc/php/fpm/pool.d/www.conf`):
~~~
...
listen.owner = www-data
listen.group = www-data
...
~~~

- Modificación de la configuración de `Nginx` (`/etc/nginx/sites-available/defualt`):
~~~
...
location ~ \.php$ {
  include snippets/fastcgi-php.conf;
  fastcgi_pass unix:/run/php/php7.3-fpm.sock; 
}
...
~~~