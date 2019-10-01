#!/bin/bash

for paqrepo in $(grep Package /var/lib/apt/lists/$1|cut -d' ' -f2)
	do
		paqueterepo=$paqrepo
		for paqinst in `dpkg -l | grep ^ii | awk '{print $2}'`
			do
				if [ $paqinst == $paqueterepo ]
				then
					echo $paqinst;
				fi
			done
	done
