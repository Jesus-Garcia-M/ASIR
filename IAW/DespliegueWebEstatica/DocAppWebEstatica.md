#### Ejercicio 2: Comenta la instalación del generador de página estática. Recuerda que el generador tienes que instalarlo en tu entorno de desarrollo. Indica el lenguaje en el que está desarrollado y el sistema de plantillas que utiliza.
- Creación y activación de un entorno virtual operativo para el uso de Pelican:
~~~
virtualenv ~/VirtualEnvs/Pelican
~~~

- Instalación de Pelican en el entorno virtual:
~~~
pip install pelican
~~~

- Instalación de Markdown:
~~~
pip install Markdown
~~~

- Generación de la estructura de ficheros:
~~~
pelican-quickstart
~~~

#### Ejercicio 3: Configura el generador para cambiar el nombre de tu página, el tema o estilo de la página,… Indica cualquier otro cambio de configuración que hayas realizado.
- Fichero de configuración: 
~~~
pelicanconf.py
~~~

- Cambiar el nombre de la página:
~~~
SITENAME = u'Mi primera estática'
~~~

- Cambiar el tema:
~~~
THEME = "{Ruta}"
~~~

- Cambiar el directorio contenedor de páginas:
~~~
PAGE_PATHS = ['pages']
~~~

- Cambiar el directorio contenedor de artículos:
~~~
ARTICLE_PATHS = ['posts']
~~~

- Cambiar el directorio contenedor de imágenes:
~~~
STATIC_PATHS = ['images']
~~~

- Cambiar el tamaño de previsualización de artículos:
~~~
SUMMARY_MAX_LENGTH = 12
~~~

#### Ejercicio 4: Genera un sitio web estático con al menos 3 páginas. Deben estar escritas en Markdown y deben tener los siguientes elementos HTML: títulos, listas, párrafos, enlaces e imágenes. El código que estas desarrollando, configuración del generado, páginas en markdown,… debe estar en un repositorio Git (no es necesario que el código generado se guarde en el repositorio, evitalo usando el fichero .gitignore).