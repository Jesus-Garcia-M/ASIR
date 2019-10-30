### Paquetería y arquitecturas.
- `dpkg -i {paquete}`: Instala el paquete indicado.
- `dpkg -r {paquete}`: Desinstala el paquete indicado.
- `dpkg -s {paquete}`: Muestra el estado del paquete indicado.
- `dpkg -S {fichero}`: Busca el fichero indicado en los paquetes instalados.
- `dpkg -l {filtro}`: Muestra una lista de paquetes de acuerdo al filtro indicado.
- `dpkg -L {paquete}`: Muestra los ficheros creados por el paquete indicado.
- `dpkg --print-architecture`: Muestra la arquitectura del sistema de paquetes.
- `dpkg --print-foreign-architecture`: Muestra las arquitecturas del sistema de paquetes añadidas manualmente.
- `dpkg --add-architecture {arquitectura}`: Añade una arquitectura al sistema de paquetes.
- `dpkg --remove-architecture {arquitectura}`: Elimina una arquitectura del sistema de paquetes.

### Kernel.
- `lspci -knn`: Muestra los módulos que utilizan las distintas interfaces del sistema.


### Misc.
- `file {fichero}`: Muestra las cabeceras del fichero indicado.