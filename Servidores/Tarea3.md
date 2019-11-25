### Creación de los distintos virtual hosts.
- Creación del sitio `www.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/wordpress.conf`):
~~~
server {
  listen 80;

  root /var/www/wordpress;
  index index.html index.php;

  server_name www.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~

- Creación del sitio `cloud.jesus.gonzalonazareno.org` (`/etc/nginx/conf.d/nextcloud.conf`):
~~~
upstream php-handler {
    server 127.0.0.1:9000;
    #server unix:/var/run/php5-fpm.sock;
}
 
server {
    listen 80;
    server_name cloud.jesus.gonzalonazareno.org;
 
    # Path to the root of your installation
    root /var/www/nextcloud/;
 
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
 
    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json
    # last;
 
    location = /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
 
    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;
 
    # Disable gzip to avoid the removal of the ETag header
    gzip off;
 
    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;
 
    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;
 
    location / {
        rewrite ^ /index.php$uri;
    }
 
    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        deny all;
    }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
        deny all;
    }
 
    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        #fastcgi_param HTTPS on;
        #Avoid sending the security headers twice
        fastcgi_param modHeadersAvailable true;
        fastcgi_param front_controller_active true;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }
 
    location ~ ^/(?:updater|ocs-provider)(?:$|/) {
        try_files $uri/ =404;
        index index.php;
    }
 
    # Adding the cache control header for js and css files
    # Make sure it is BELOW the PHP block
    location ~* \.(?:css|js)$ {
        try_files $uri /index.php$uri$is_args$args;
        add_header Cache-Control "public, max-age=7200";
        # Add headers to serve security related headers (It is intended to
        # have those duplicated to the ones above)
        # Before enabling Strict-Transport-Security headers please read into
        # this topic first.
        add_header Strict-Transport-Security "max-age=15768000;
        includeSubDomains; preload;";
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        # Optional: Don't log access to assets
        access_log off;
    }
 
    location ~* \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg)$ {
        try_files $uri /index.php$uri$is_args$args;
        # Optional: Don't log access to other assets
        access_log off;
    }
}


server {
  listen 80;

  root /var/www/nextcloud;
  index index.html index.php;

  server_name cloud.jesus.gonzalonazareno.org;


  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
~~~

- Modificación de SELinux:
~~~
[centos@salmorejo ~]$ sudo semanage fcontext -a -t httpd_config_t "/etc/nginx/conf.d(/.*)?"
[centos@salmorejo ~]$ sudo restorecon -Rv /etc/nginx/conf.d
~~~


### Creación de usuarios y bases de datos en Tortilla.
- Creación del usuario y la base de datos de `WordPress`:
~~~
MariaDB [(none)]> CREATE DATABASE wordpress;
Query OK, 1 row affected (0.05 sec)

MariaDB [(none)]> GRANT ALL ON wordpress.* TO wordpress@salmorejo IDENTIFIED BY 'wordpress';
Query OK, 0 rows affected (0.01 sec)

MariaDB [(none)]> 

#----- Prueba de funcionamiento -----#
[centos@salmorejo ~]$ mysql -u wordpress -p wordpress -h tortilla
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 32
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [wordpress]>
~~~

- Creación del usuario y la base de datos de `NextCloud`:
~~~
MariaDB [(none)]> CREATE DATABASE nextcloud;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> GRANT ALL ON nextcloud.* TO nextcloud@salmorejo IDENTIFIED BY 'nextcloud';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> 

#----- Prueba de funcionamiento -----#
[centos@salmorejo ~]$ mysql -u nextcloud -p nextcloud -h tortilla
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 33
Server version: 10.1.41-MariaDB-0ubuntu0.18.04.1 Ubuntu 18.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [nextcloud]>
~~~

### Instalación de Wordpress
- Descarga y descompresión del paquete:
~~~
[root@salmorejo wordpress]# wget https://wordpress.org/latest.tar.gz
--2019-11-19 18:35:50--  https://wordpress.org/latest.tar.gz
Resolviendo wordpress.org (wordpress.org)... 198.143.164.252
Conectando con wordpress.org (wordpress.org)[198.143.164.252]:443... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 12372564 (12M) [application/octet-stream]
Grabando a: “latest.tar.gz”

100%[==============================================================================================================================>] 12.372.564  3,37MB/s   en 3,5s

2019-11-19 18:35:54 (3,37 MB/s) - “latest.tar.gz” guardado [12372564/12372564]

[root@salmorejo wordpress]# tar xvf latest.tar.gz
[root@salmorejo wordpress]# mv wordpress/* .
~~~

- Configuración del fichero `wp-config.php`:
~~~
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'tortilla' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );
~~~

- Modificación de SELinux:
~~~
[root@salmorejo wordpress]# semanage fcontext -a -t httpd_sys_content_t "/var/www/wordpress(/.*)?"
[root@salmorejo wordpress]# restorecon -Rv /var/www/wordpress
~~~

- Instalación de la extensión `MySQL` de `php`:
~~~
[root@salmorejo ~]# yum --enablerepo=remi-php72 install php-mysql
~~~

### Instalación de NextCloud.
- Instalación de dependencias:
~~~
[root@salmorejo ~]# yum -y --enablerepo=remi-php72 install php-cli php-gd php-mcrypt php-pear php-xml php-mbstring php-pdo php-json php-pecl-apcu php-pecl-apcu-devel php-zip
~~~

- Descarga y descompresión del paquete:
~~~
[root@salmorejo nextcloud]# wget https://download.nextcloud.com/server/releases/nextcloud-17.0.1.zip
--2019-11-20 18:30:23--  https://download.nextcloud.com/server/releases/nextcloud-17.0.1.zip
Resolving download.nextcloud.com (download.nextcloud.com)... 176.9.217.52, 2a01:4f8:130:32f1::52
Connecting to download.nextcloud.com (download.nextcloud.com)|176.9.217.52|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 83842356 (80M) [application/zip]
Saving to: ‘nextcloud-17.0.1.zip’

100%[==============================================================================================================================>] 83,842,356  24.0MB/s   in 4.1s

2019-11-20 18:30:30 (19.4 MB/s) - ‘nextcloud-17.0.1.zip’ saved [83842356/83842356]

[root@salmorejo nextcloud]# unzip nextcloud-17.0.1.zip
[root@salmorejo nextcloud]# mv nextcloud/* ./
~~~

- Configuración de `php-fpm` (`/etc/php-fpm.d/www.conf`);
~~~
user = nginx
group = nginx
listen = 127.0.0.1:9000
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
~~~

- Creación del directorio `/var/lib/php/session`:
~~~
[root@salmorejo ~]# mkdir -p /var/lib/php/session
[root@salmorejo ~]# chown -R nginx:nginx /var/lib/php/session/
~~~

- Creación del directorio `/var/www/nextcloud/data`:
~~~
[root@salmorejo nextcloud]# mkdir data
[root@salmorejo nextcloud]# chown -R nginx:nginx ./
~~~

- Configuración de `SELinux` y `FirewallD`:
~~~
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/data(/.*)?'
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/config(/.*)?'
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/apps(/.*)?'
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/assets(/.*)?'
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/.htaccess'
[root@salmorejo nextcloud]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/.user.ini'
[root@salmorejo nextcloud]# restorecon -Rv '/var/www/nextcloud/'
[root@salmorejo nextcloud]# firewall-cmd --permanent --add-service=http
success
[root@salmorejo nextcloud]# firewall-cmd --reload
success
[root@salmorejo nextcloud]#
~~~