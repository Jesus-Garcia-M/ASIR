#!/bin/bash
# Uso: Lista los paquetes instalados de un repositorio, necesita de 2 parámetros, el nombre del repositorio y la "rama" en caso de que
# el repositorio indicado tenga varias. (Ej: deb.debian.org_debian_dists_buster/buster-backports/buster-updates)

if [ -z "$2" ]
	then
		# Recorre el repositorio indicado y guarda el nombre del paquete en una variable.
		for paqrepo in $(grep Package /var/lib/apt/lists/$1*Packages|cut -d' ' -f2)
			do
				paqueterepo=$paqrepo
				# Recorre los paquetes instalados y comprubea si corresponden al repositorio, si corresponde
				# lo imprime por pantalla.
				for paqinst in `dpkg -l |grep ^ii |awk '{print $2}'`
					do
						if [ $paqinst == $paqueterepo ]
							then
								echo $paqinst;
						fi
					done
			done
	else
		for paqrepo in $(grep Package /var/lib/apt/lists/$1*$2*Packages|cut -d' ' -f2)
			do
				paqueterepo=$paqrepo
				for paqinst in `dpkg -l |grep ^ii |awk '{print $2}'`
					do
						if [ $paqinst == $paqueterepo ]
							then
								echo $paqinst;
						fi
					done
			done
fi
