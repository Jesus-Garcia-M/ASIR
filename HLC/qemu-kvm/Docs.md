- Crear imagen de disco:
~~~
#----- Sintaxis -----#
qemu-img create -f {formato} {nombre fichero} {tamaño}

#----- Ejemplo -----#
jesus@jesus:~/KVM$ qemu-img create -f qcow2 buster.qcow2 10G
~~~

- Lanzar máquina virtual:
~~~
#----- Sintaxis -----#
kvm -m {memoria} -cdrom {imagen} -hda {imagen disco} -device {dispositivo} -netdev {interfaz}

#----- Ejemplo -----#
jesus@jesus:~/KVM$ kvm -m 768 -cdrom ~/Descargas/debian-10.1.0-amd64-netinst.iso -hda buster-base.qcow2 -device virtio-net,netdev=n0,mac=$MAC0 -netdev tap,id=n0,ifname=tap0,script=no,downscript=no
~~~

- Aprovisionamiento ligero:
~~~
jesus@jesus:~/Documentos/ASIR/KVM$ qemu-img create -b buster-base.qcow2 -f qcow2 buster-1.qcow2
jesus@jesus:~/Documentos/ASIR/KVM$ qemu-img create -b buster-base.qcow2 -f qcow2 buster-2.qcow2
~~~

### Creación de interfaces tap.
- Creación de la interfaz:
~~~
jesus@jesus:~/Documentos/ASIR/KVM$ sudo ip tuntap add mode tap user jesus
~~~

- Añadir la interfaz al bridge existente:
~~~
jesus@jesus:~/Documentos/ASIR/KVM$ sudo brctl addif br0 tap0
~~~

- Generación de una MAC aleatoria:
~~~
jesus@jesus:~/Documentos/ASIR/KVM$ MAC0=$(echo "02:"`openssl rand -hex 5 | sed 's/\(..\)/\1:/g; s/.$//'`)
~~~