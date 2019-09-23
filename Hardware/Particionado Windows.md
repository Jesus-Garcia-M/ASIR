# Particionado con diskpart.


Creación de distintos esquemas de particionado utilizando la herramienta **diskpart**.


## Esquema.
- Disco duro: 800 MB.
- Partición Primaria: 100 MB, Formato FAT32, Letra E.
- Partición Primaria: 100 MB, Formato NTFS, Letra F.
- Hueco: 300 MB.
- Partición Lógica: 100 MB, Formato NTFS, Letra G.


Creación de las distintas particiones.
~~~
DISKPART> list disk

  Núm Disco  Estado      Tamaño   Disp     Din  Gpt
  ---------- ----------  -------  -------  ---  ---
  Disco 0    En línea      32 GB      0 B
  Disco 1    En línea     800 MB   199 MB

DISKPART> select disk 1

El disco 1 es ahora el disco seleccionado.

DISKPART> create partition primary size=100

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> create partition primary size=100

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> create partition extended offset=512000

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> create partition logical size=100

DiskPart ha creado satisfactoriamente la partición especificada.

DISKPART> list partition

  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
  Partición 1    Principal          100 MB    64 KB
  Partición 2    Principal          100 MB   100 MB
  Partición 0    Extendido          299 MB   500 MB
* Partición 3    Lógico             100 MB   500 MB

DISKPART>
~~~


Redimensión de la segunda partición primaria.
~~~
DISKPART> select partition 2

La partición 2 es ahora la partición seleccionada.

DISKPART> extend

DiskPart extendio el volumen correctamente.

DISKPART> list partition

  Núm Partición  Tipo              Tamaño   Desplazamiento
  -------------  ----------------  -------  ---------------
  Partición 1    Principal          100 MB    64 KB
* Partición 2    Principal          399 MB   100 MB
  Partición 0    Extendido          299 MB   500 MB
  Partición 3    Lógico             100 MB   500 MB

DISKPART>
~~~


Asignación de letras a las distintas particiones.
~~~
DISKPART> select partition 1

La partición 1 es ahora la partición seleccionada.

DISKPART> assign letter=E

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART> select partition 2

La partición 2 es ahora la partición seleccionada.

DISKPART> assign letter=F

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART> select partition 3

La partición 3 es ahora la partición seleccionada.

DISKPART> assign letter=G

DiskPart asignó correctamente una letra de unidad o punto de montaje.

DISKPART> 
~~~


Formateo de las distintas particiones.
~~~
DISKPART> select partition 1

La partición 1 es ahora la partición seleccionada.

DISKPART> format fs=FAT32

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART> select partition 2

La partición 2 es ahora la partición seleccionada.

DISKPART> format fs=ntfs

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART> select partition 3

La partición 3 es ahora la partición seleccionada.

DISKPART> format fs=ntfs

  100 por ciento completado

DiskPart formateó el volumen correctamente.

DISKPART>
~~~