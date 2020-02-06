### Creación de la máquina virtual.
- Instalación de los paquetes necesarios:
~~~
jesus@jesus:~/libvirt$ sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system
~~~

- Aprovisionamiento ligero de la imagen base (`buster-base.qcow2`):
~~~
jesus@jesus:~/Documentos/ASIR/libvirt$ qemu-img create -b buster-base.qcow2 -f qcow2 images/migracion.qcow2
Formatting 'images/migracion.qcow2', fmt=qcow2 size=10737418240 backing_file=buster-base.qcow2 cluster_size=65536 lazy_refcounts=off refcount_bits=16
jesus@jesus:~/Documentos/ASIR/libvirt$ ls images/
buster-base.qcow2  migracion.qcow2
jesus@jesus:~/Documentos/ASIR/libvirt$


jesus@jesus:~/libvirt/disks$ qemu-img create -b buster-base.qcow2 -f qcow2 migracion.qcow2
Formatting 'migracion.qcow2', fmt=qcow2 size=10737418240 backing_file=buster-base.qcow2 cluster_size=65536 lazy_refcounts=off refcount_bits=16
jesus@jesus:~/libvirt/disks$ ls -l
total 2200076
-rw-r--r-- 1 libvirt-qemu libvirt-qemu 2252734464 nov 20 14:30 buster-base.qcow2
-rw-r--r-- 1 jesus        sudo             196768 dic 19 08:46 migracion.qcow2
jesus@jesus:~/libvirt/disks$ 

~~~

- Creación de la máquina virtual:
~~~

~~~