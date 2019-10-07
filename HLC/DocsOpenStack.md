#### Administración a través de línea de comandos.
- Creación del entorno virtual:
~~~
jesus@jesus:~/Documentos/VirtualEnvs$ python3 -m venv Openstack/
~~~

- Instalación de dependencias:
~~~
jesus@jesus:~/Documentos/VirtualEnvs/Openstack$ sudo apt install libpython3-dev
~~~

- Instalación del paquete de openstack:
~~~
(Openstack) jesus@jesus:~/Documentos/VirtualEnvs/Openstack$ pip install openstackclient
~~~

- Descargar el fichero con los datos de mi usuario para poder usar la API:
~~~
Acceso y Seguridad --> Acceso a la API --> Descargar fichero RC de OpenStack v3
~~~

- Instalación de la unidad certificadora:
~~~
root@jesus:~# mv /home/jesus/Certs/gonzalonazareno.crt /urs/local/share/ca.certificates
root@jesus:~# update-ca-certificates
~~~

- Añadir la variable de entorno con el contener de certificados al fichero de información:
~~~
export OS_CACERT=/urs/local/share/ca-certificates/gonzalonazareno.crt
~~~


#### Comandos.
- ``
- ``
- ``
- ``
- ``
