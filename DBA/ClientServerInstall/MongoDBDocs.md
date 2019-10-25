### Instalación del servidor.
- Instalación de la dependencia `libcurl3`:
~~~
user@debian:~$ sudo apt install libcurl3
~~~

- Instalación:
~~~
user@debian:~$ sudo apt install mongodb-server
~~~

### Configuración de acceso remoto.
- Seleccionar la dirección IP de la interfaz por la que va a escuchar el servidor (`/etc/mongod.conf`:
~~~
...
# network interfaces
net:
port: 2701
bindIp: 0.0.0.0
...
~~~