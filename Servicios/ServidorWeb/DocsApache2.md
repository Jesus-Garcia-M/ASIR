# Apache 2.
### Directorios y ficheros de configuración.
- `/etc/apache2/sites-available`: Directorio contenedor de los sitios web disponibles.
- `/etc/apache2/sites-enabled`: Directorio contenedor de los sitios web activos.
- `/etc/apache2/conf-availabe`: Directorio contenedor de las configuraciones disponibles.
- `/etc/apache2/conf-enabled`: Directorio contenedor de las configuraciones activas.
- `/etc/apache2/mod-available`: Directorio contenedor de los módulos disponibles.
- `/etc/apache2/mod-enables`: Directorio contenedor de los módulos activas.
- `/var/www/html`: Document root del sitio por defecto.
- `/etc/apache2/ports.conf`: Fichero de configuración de puertos.
- `/etc/apache2/apache2.conf`: Fichero de configuración de los directorios de trabajo.

### Comandos de administración.
- `a2ensite {Fichero .conf sitio web}`: Activa un sitio web.
- `a2dissite {Fichero .conf sitio web}`: Desactiva un sitio web.
- `a2enconf {Fichero .conf configuración}`: Activa una configuración.
- `a2disconf {Fichero .conf configuración}`: Desactiva una configuración.
- `a2enmod {Fichero .conf módulo}`: Activa un módulo.
- `a2dismod {Fichero .conf módulo}`: Desactiva un módulo.