# Comandos

- `vagrant box list`: Muestra los box instalados.
- `vagrant box add`: Añade un box.
	- `vagrant box add {Ruta Local} --name {Nombre} --version {Versión}`: Añade un box a través de un fichero.
	- `vagrant box add {usuario/S.O}`: Añade un box a través de los repositorios de Vagrant.
- `vagrant init`: Crea un Vagrantfile.
- `vagrant ssh`: Conecta a la VM via SSH. 
- `vagrant up`: Crea y enciende la VM.
- `vagrant halt`: Apaga la VM.
- `vagrant destroy`: Elimina la VM.




Crear VM:
Crear un directio por cada vagrantfile
Modificar el vagrantfile con nuestra configuración
config.vm.box = "{box}": selecciona el box de la máquina
config.vm.hostname = "{nombre máquina}": indica el nombre de la máquina
vb.memory = "{RAM}": indica la ram de la máquina


Directorios y ficheros:
~/.vagrant.d/boxes: Muestra las boxes añadidas
vagrant box add debian/buster64
