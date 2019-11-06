### Instalación de dependencias.
- libelf-dev:
~~~
jesus@jesus:~/Kernel/linux-source-4.19$ sudo apt install libelf-dev
~~~

- libssl-dev:
~~~
jesus@jesus:~/Kernel/linux-source-4.19$ sudo apt install libssl-dev
~~~

### Descarga y creación del directorio de trabajo.
- Descarga de la versión de kernel que está en uso:
~~~
jesus@jesus:~$ sudo apt install linux-source-4.19/stable
~~~

- Descompresión del kernel en el directorio de trabajo:
~~~
jesus@jesus:~/Kernel$ tar -xf /usr/src/linux-source-4.19.tar.xz
jesus@jesus:~/Kernel$ ls -la linux-source-4.19/
total 800
drwxr-xr-x  25 jesus sudo   4096 sep 20 12:51 .
drwxr-xr-x   3 jesus sudo   4096 oct 24 14:29 ..
drwxr-xr-x  26 jesus sudo   4096 ago 16 10:12 arch
drwxr-xr-x   3 jesus sudo   4096 ago 16 10:12 block
drwxr-xr-x   2 jesus sudo   4096 sep 20 12:51 certs
-rw-r--r--   1 jesus sudo  13061 ago 16 10:12 .clang-format
-rw-r--r--   1 jesus sudo     59 ago 16 10:12 .cocciconfig
-rw-r--r--   1 jesus sudo    423 ago 16 10:12 COPYING
-rw-r--r--   1 jesus sudo  98741 ago 16 10:12 CREDITS
drwxr-xr-x   4 jesus sudo   4096 ago 16 10:12 crypto
drwxr-xr-x 120 jesus sudo  12288 ago 16 10:12 Documentation
drwxr-xr-x 137 jesus sudo   4096 ago 16 10:12 drivers
drwxr-xr-x   2 jesus sudo   4096 ago 16 10:12 firmware
drwxr-xr-x  73 jesus sudo   4096 sep 20 12:51 fs
-rw-r--r--   1 jesus sudo     31 ago 16 10:12 .get_maintainer.ignore
-rw-r--r--   1 jesus sudo     30 ago 16 10:12 .gitattributes
-rw-r--r--   1 jesus sudo   1444 sep 20 12:51 .gitignore
drwxr-xr-x  27 jesus sudo   4096 ago 16 10:12 include
drwxr-xr-x   2 jesus sudo   4096 ago 16 10:12 init
drwxr-xr-x   2 jesus sudo   4096 ago 16 10:12 ipc
-rw-r--r--   1 jesus sudo   2245 ago 16 10:12 Kbuild
-rw-r--r--   1 jesus sudo    563 ago 16 10:12 Kconfig
drwxr-xr-x  18 jesus sudo   4096 sep 20 12:51 kernel
drwxr-xr-x  13 jesus sudo  12288 sep 20 12:51 lib
drwxr-xr-x   5 jesus sudo   4096 ago 16 10:12 LICENSES
-rw-r--r--   1 jesus sudo   9924 ago 16 10:12 .mailmap
-rw-r--r--   1 jesus sudo 471497 sep 20 12:51 MAINTAINERS
-rw-r--r--   1 jesus sudo  60368 sep 20 12:51 Makefile
drwxr-xr-x   3 jesus sudo   4096 sep 20 12:51 mm
drwxr-xr-x  70 jesus sudo   4096 ago 16 10:12 net
-rw-r--r--   1 jesus sudo    800 ago 16 10:12 README
drwxr-xr-x  27 jesus sudo   4096 ago 16 10:12 samples
drwxr-xr-x  14 jesus sudo   4096 sep 20 12:51 scripts
drwxr-xr-x  10 jesus sudo   4096 sep 20 12:51 security
drwxr-xr-x  26 jesus sudo   4096 ago 16 10:12 sound
drwxr-xr-x  32 jesus sudo   4096 ago 16 10:12 tools
drwxr-xr-x   2 jesus sudo   4096 ago 16 10:12 usr
drwxr-xr-x   4 jesus sudo   4096 ago 16 10:12 virt
jesus@jesus:~/Kernel$ 
~~~

- Creación de la copia del fichero de configuración usado en el arranque:
~~~
jesus@jesus:~/Kernel$ cp /boot/config-4.19.0-6-amd64 linux-source-4.19/.config
~~~

### Proceso de compilación.
- Creación de la configuración con el hardware actual:
~~~
jesus@jesus:~/Kernel/linux-source-4.19$ make localmodconfig
~~~

- Creación del paquete `.deb`:
~~~
jesus@jesus:~/Kernel/linux-source-4.19$ make -j6 deb-pkg
~~~

- Modificación de la configuración:
~~~
jesus@jesus:~/Kernel/linux-source-4.19$ make nconfig
~~~

### Modificaciones.
##### Primer Kernel.
- Virtualization.
- Procesor Type and Features:
	- AMD ACPI2Platform devices support.
	- AMD MCE features.
	- AMD miAMD microcode loading support crocode loading support.
	- Old style AMD Opteron NUMA detection.
	- Linux Guest support.
	- Old AMD GART IOMMU support
	- IBM Calgary IOMMU support
	- Enable support for 16-bit segments
	- Enable the LDT (local descriptor table)
- Networking support:
	- Amateur Radio Support.
	- Bluetooth subsystem support.
- Device Drivers:
	- Macintosh Device Drivers.
	- Hardware Monitoring support.
	- Multimedia Support:
		- Cameras/video grabbers support.
		- Analog TV support.
		- Digital TV support.
		- AM/FM radio receivers/transmitters support.
		- Software defined radio support.
		- HDMI CEC support.
		- Radio Adapters.
	- LED support.
	- Virtualization drivers.
	- Virtio drivers.
	- Platform support for Chrome hardware.
	- X86 Platform Specific Device Drivers.
- File systems:
	- Quota Support.
	- Btrfs filesystem support.
	- Network File Systems.
- Security Options:
	- NSA SELinux Support

##### Segundo Kernel.
- General Setup:
	- CPU Isolation.
	- Support initial ramdisk/ramfs compressed using bzip2
	- Support initial ramdisk/ramfs compressed using LZMA
	- Support initial ramdisk/ramfs compressed using XZ
	- Support initial ramdisk/ramfs compressed using LZO
	- Support initial ramdisk/ramfs compressed using LZ4
- Processor Type and Features:
	- Intel Low Power Subsystem Support
	- Power Management Timer Support
	- Hibernation (aka 'suspend to disk')
- Kernel Hacking (Completo).
- Device Drivers:
	- Network Device Support:
		- Fibre Channel driver support
		- Wireless LAN

##### Tercer Kernel.
- General setup:
	- Configure standard kernel features (expert users)
- Enable loadable module support (Completo)




- Processor type and features:
	- Symmetric multi-processing support (Dudoso)
	- Support x2apic
	- Machine Check / overheating reporting
	- Enable vsyscall emulation (Dudoso)
	- CPU microcode loading support
	- MTRR (Memory Type Range Register) support
	- Randomize the address of the kernel image (KASLR)
	- Randomize the kernel memory sections




- Binary Emulations:
	- IA32 Emulation
	- x32 ABI for 64-bit mode
- Networking Support:
	- Wireless (Completo)
	- RF switch subsystem support (Completo)
	- Networking Options:
		- IP: multicasting
		- IP: advanced router
		- TCP: advanced congestion control
		- The IPv6 Protocol
		- Data Center Bridging support
		- L3 Master device support
- Device Drivers:
	- Block Devices (Completo)
	- Graphics Support:
		-  Intel 8xx/9xx/G3x/G4x/HD Graphics
		-  Enable legacy drivers (DANGEROUS)
		-  /dev/agpgart (AGP Support):
			-  AMD Opteron/Athlon64 on-CPU GART support
			-  Intel 440LX/BX/GX, I8xx and E7x05 chipset support
	- Sound Card Support
	- Accesibility Support

## Anotaciones.
- Fichero `Makefile` - Variable `EXTRAVERSION`: Indica una nueva versión al paquete generado.
- Comando `make` - Parámetro `-j`: Indica el número de cores a utilizar en la compilación.
