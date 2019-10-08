# Apache 2.
#### Directorios y ficheros de configuración.
- `/etc/apache2/sites-availables`: Directorio contenedor de los ficheros `.conf` de los distintos sitios web.
- `/etc/apache2/sites-enabled`: Directorio contenedor de los sitios web activos.
- `/var/www/html`: Document root del sitio por defecto.

#### Comandos de administración.
- `a2ensite {Fichero .conf sitio web}`: Crea un enlace simbólico para activar el sitio web.
- `a2dissite {Fichero .conf sitio web}`: Elimina el enlace simbólico para desactivar el sitio web.