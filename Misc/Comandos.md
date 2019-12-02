# Debian.
### Paquetería y arquitecturas.
- `dpkg`: Manejo de paquetes `.deb`.
	- `-i {paquete}`: Instala el paquete indicado.
	- `-r {paquete}`: Desinstala el paquete indicado.
	- `-s {paquete}`: Muestra el estado del paquete indicado.
	- `-S {fichero}`: Busca el fichero indicado en los paquetes instalados.
	- `-l {filtro}`: Muestra una lista de paquetes de acuerdo al filtro indicado.
	- `-L {paquete}`: Muestra los ficheros creados por el paquete indicado.
	- `--print-architecture`: Muestra la arquitectura del sistema de paquetes.
	- `--print-foreign-architecture`: Muestra las arquitecturas del sistema de paquetes añadidas manualmente.
	- `--add-architecture {arquitectura}`: Añade una arquitectura al sistema de paquetes.
	- `--remove-architecture {arquitectura}`: Elimina una arquitectura del sistema de paquetes.
	- `dpkg-reconfigure {paquete}`: Configura el paquete indicado.

- `tar`: Manejo de archivos.
	- `-x`: Descomprimir.
	- `-f`: Indica el archivo.
	- `-t`: Simula la descompresión.
	- `-v`: Muestra la salida.

- `apt`: Manejo del sistema de paquetes.
	- `install`: Instala los paquetes indicados.
	- `purge`: Desinstala los paquetes indicados junto a los ficheros de configuración.
	- `remove`: Desinstala los paquetes indicados.
	- `autoremove`: Desinstala los paquetes que ya no son necesarios en el sistema.
	- `update`: Actualiza la lista de paquetes del sistema.
	- `upgrade`: Actualiza todos los paquetes del sistema.

### SSH.
- `ssh-copy-id -i {ruta clave privada} {destino}`: Copia en el destino la clave pública correspondiente a la clave privada indicada.
- `ssh-add {ruta clave privada}`: Añade la clave privada a la sesión.

### Kernel.
- `lspci -knn`: Muestra los módulos que utilizan las distintas interfaces del sistema.

### Misc.
- `file {fichero}`: Muestra las cabeceras del fichero indicado.
- `zless {fichero}`: Igual que `less` pero para ficheros comprimidos.


### Gestión de usuarios y grupos.
- `newgrp {grupo}`: Cambia el grupo principal para esta sesión.
- `adduser {usuario}`: Crea un nuevo usuario.

# CentOS.
### Paquetería.
- `yum`: Manejo del sistema de paquetes.
	- `install {paquete}`: Instala el paquete indicado.
	- `update`: Actualiza todos los paquetes del sistema.
	- `repolist`: Muestra la lista de repositorios.
	- `provides {fichero/comando}`: Muestra los paquetes que contienen el fichero o comando indicado.