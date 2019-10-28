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