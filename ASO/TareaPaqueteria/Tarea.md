#### Añadir la arquitectura i386.
~~~
debian@prueba-empaquetado:~$ sudo dpkg --add-architecture i386
~~~

#### Instalación de paquetes con arquitectura i386.
~~~
debian@prueba-empaquetado:~$ sudo apt install dnsutils:i386
debian@prueba-empaquetado:~$ sudo apt install net-tools:i386
~~~