# Apache 2.
#### Directorios y ficheros de configuración.
- `/etc/apache2/sites-available`: Directorio contenedor de los sitios web disponibles.
- `/etc/apache2/sites-enabled`: Directorio contenedor de los sitios web activos.
- `/etc/apache2/conf-availabe`: Directorio contenedor de las configuraciones disponibles.
- `/etc/apache2/conf-enabled`: Directorio contenedor de las configuraciones activas.
- `/etc/apache2/mod-available`: Directorio contenedor de los módulos disponibles.
- `/etc/apache2/mod-enables`: Directorio contenedor de los módulos activas.
- `/var/www/html`: Document root del sitio por defecto.

#### Comandos de administración.
- `a2ensite {Fichero .conf sitio web}`: Crea un enlace simbólico para activar el sitio web.
- `a2dissite {Fichero .conf sitio web}`: Elimina el enlace simbólico para desactivar el sitio web.
- `a2enconf {Fichero .conf }`: Activa un
- `a2disconf`: 
- `a2enmod`: 
- `a2dismod`: 