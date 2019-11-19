### Creación de los distintos virtual hosts.
- Creación del sitio `wordpress.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/wordpress.conf`):
~~~
server {
  listen 80;

  root /var/www/wordpress;
  index index.html index.php;

  server_name wordpress.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~

- Creación del sitio `netcloud.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/netcloud.conf`):
~~~
server {
  listen 80;

  root /var/www/netcloud;
  index index.html index.php;

  server_name netcloud.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~
