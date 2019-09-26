#### Ejercicio 2: Comenta la instalación del generador de página estática. Recuerda que el generador tienes que instalarlo en tu entorno de desarrollo. Indica el lenguaje en el que está desarrollado y el sistema de plantillas que utiliza.
\
Creación y activación de un entorno virtual operativo para el uso de Pelican:
~~~
virtualenv ~/VirtualEnvs/Pelican
~~~
\
Instalación de Pelican en el entorno virtual:
~~~
pip install pelican
~~~
\
Instalación de Markdown:
~~~
pip install Markdown
~~~
\
Generación de la estructura de ficheros:
~~~
pelican-quickstart
~~~
\
#### Ejercicio 3: Configura el generador para cambiar el nombre de tu página, el tema o estilo de la página,… Indica cualquier otro cambio de configuración que hayas realizado.
\
Fichero de configuración: `pelicanconf.py`
\
Cambiar el nombre de la página:
~~~
SITENAME = u'Mi primera estática'
~~~
\
Cambiar el tema:
~~~
THEME = "{Ruta}"
~~~