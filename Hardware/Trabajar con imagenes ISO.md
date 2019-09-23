### Crear imagen ISO a partir de un CD
Crear imagen ISO.
~~~
root@debian:~# dd if=/dev/sr0 of=iso_prueba.iso
430080+0 registros leídos
430080+0 registros escritos
220200960 bytes (220 MB, 210 MiB) copied, 9,61777 s, 22,9 MB/s
root@debian:~#
~~~


Montaje de la ISO y comprobación del contenido.
~~~
root@debian:~# mount iso_prueba.iso /mnt
mount: /dev/loop0 está protegido contra escritura; se monta como sólo lectura
root@debian:~# ls /mnt
boot  Clonezilla-Live-Version  EFI  GPL  live  syslinux  utils
root@debian:~# 
~~~


### Crear imagen ISO a partir de un directorio
Crear imagen ISO.
~~~
root@debian:~# genisoimage -r -J -o iso_carpeta.iso iso_carpeta
I: -input-charset not specified, using utf-8 (detected in locale settings)
Using K01MD000.;1 for  iso_carpeta/etc/rc0.d/K01mdadm (K01mdadm-waitidle)
Using K01LV000.;1 for  iso_carpeta/etc/rc0.d/K01lvm2-lvmpolld (K01lvm2-lvmetad)
Using S01LV000.;1 for  iso_carpeta/etc/rc4.d/S01lvm2-lvmetad (S01lvm2-lvmpolld)
Using S01LV000.;1 for  iso_carpeta/etc/rc2.d/S01lvm2-lvmetad (S01lvm2-lvmpolld)
Using S01LV000.;1 for  iso_carpeta/etc/rc5.d/S01lvm2-lvmetad (S01lvm2-lvmpolld)
Using APT_D000.TIM;1 for  iso_carpeta/etc/systemd/system/timers.target.wants/apt-daily-upgrade.timer (apt-daily.timer)
.
.
.
.
.
Total translation table size: 0
Total rockridge attributes bytes: 169977
Total directory bytes: 460800
Path table size(bytes): 2384
Max brk space used 12a000
1672 extents written (3 MB)
root@debian:~#
~~~


Montaje de la ISO y comprobación del contenido.
~~~
root@debian:~# mount iso_carpeta.iso /mnt
mount: /dev/loop0 está protegido contra escritura; se monta como sólo lectura
root@debian:~# ls /mnt/
etc
root@debian:~# ls /mnt/etc/
adduser.conf		dbus-1			gss		 locale.alias	 mysql		rc2.d		staff-group-for-usr-local
aliases			debconf.conf		hdparm.conf	 locale.gen	 nanorc		rc3.d		subgid
alternatives		debian_version		host.conf	 localtime	 network	rc4.d		subgid-
anacrontab		default			hostname	 logcheck	 networks	rc5.d		subuid
apm			deluser.conf		hosts		 login.defs	 newt		rc6.d		subuid-
apt			dhcp			hosts.allow	 logrotate.conf  nsswitch.conf	rcS.d		sysctl.conf
avahi			dictionaries-common	hosts.deny	 logrotate.d	 opt		reportbug.conf	sysctl.d
bash.bashrc		discover.conf.d		ifplugd		 lvm		 os-release	resolv.conf	systemd
bash_completion		discover-modprobe.conf	init		 machine-id	 pam.conf	rmt		terminfo
bash_completion.d	dpkg			init.d		 magic		 pam.d		rpc		timezone
bindresvport.blacklist	emacs			initramfs-tools  magic.mime	 passwd		rsyslog.conf	tmpfiles.d
binfmt.d		email-addresses		inputrc		 mailcap	 passwd-	rsyslog.d	ucf.conf
bluetooth		environment		iproute2	 mailcap.order	 perl		securetty	udev
ca-certificates		exim4			issue		 mailname	 ppp		security	ufw
ca-certificates.conf	fstab			issue.net	 manpath.config  profile	selinux		update-motd.d
calendar		fuse.conf		kernel		 mdadm		 profile.d	services	vim
console-setup		gai.conf		kernel-img.conf  mime.types	 protocols	sgml		wgetrc
cron.d			groff			ldap		 mke2fs.conf	 python		shadow		wpa_supplicant
cron.daily		group			ld.so.cache	 modprobe.d	 python2.7	shadow-		X11
cron.hourly		group-			ld.so.conf	 modules	 python3	shells		xdg
cron.monthly		grub.d			ld.so.conf.d	 modules-load.d  python3.5	skel		xml
crontab			gshadow			libaudit.conf	 motd		 rc0.d		ssh
cron.weekly		gshadow-		libnl-3		 mtab		 rc1.d		ssl
root@debian:~# 
~~~


### Creación de una imagen ISO Live.
Creación del directorio donde guardaremos los archivos.
~~~
root@debian:~# mkdir iso_live
~~~


Crear un entorno Debian.
~~~
root@debian:~# debootstrap \
> --arch=i386 \
> --variant=minbase \
> jessie iso_live/chroot \
>  http://ftp.es.debian.org/debian/
I: Retrieving InRelease 
I: Retrieving Release 
I: Retrieving Release.gpg 
.
.
.
.
.
I: Base system installed successfully.
root@debian:~# 
~~~


Entrar con ``chroot`` al entorno que hemos creado.
~~~
root@debian:~# chroot iso_live/chroot
root@debian:/#
~~~


Añadir un hostname al entorno.
~~~
root@debian:/# echo "debian-live" > /etc/hostname
root@debian:/#
~~~


Elegir un Kernel Linux e instalarlo.
~~~
root@debian:/# apt-cache search linux-image
linux-image-3.16.0-4-586 - Linux 3.16 for older PCs
linux-image-3.16.0-4-686-pae - Linux 3.16 for modern PCs
linux-image-3.16.0-4-686-pae-dbg - Debugging symbols for Linux 3.16.0-4-686-pae
linux-image-3.16.0-4-amd64 - Linux 3.16 for 64-bit PCs
linux-image-486 - Linux for older PCs (dummy package)
linux-image-586 - Linux for older PCs (meta-package)
linux-image-686-pae - Linux for modern PCs (meta-package)
linux-image-686-pae-dbg - Debugging symbols for Linux 686-pae configuration (meta-package)
linux-image-amd64 - Linux for 64-bit PCs (meta-package)
root@debian:/# apt-get update && \
> apt-get install --no-install-recommends \
> linux-image-3.16.0-4-686-pae \
> live-boot \
> systemd-sysv
Ign http://ftp.es.debian.org jessie InRelease
Hit http://ftp.es.debian.org jessie Release.gpg
Hit http://ftp.es.debian.org jessie Release
Hit http://ftp.es.debian.org jessie/main i386 Packages
Get:1 http://ftp.es.debian.org jessie/main Translation-en [4583 kB]
.
.
.
.
.
Processing triggers for systemd (215-17+deb8u7) ...
Processing triggers for initramfs-tools (0.120+deb8u3) ...
update-initramfs: Generating /boot/initrd.img-3.16.0-4-686-pae
live-boot: core filesystems devices utils udev blockdev.
root@debian:/# 
~~~


Establecer la contraseña del usuario ``root``.
~~~
root@debian:/# passwd root
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
root@debian:/# 
~~~


Crear los directorios que contendran los ficheros de la imagen live.
~~~
root@debian:~# mkdir -p iso_live/image/{live,boot/grub}
~~~


Comprimir el entorno chroot en un sistema de ficheros Squash.
~~~
root@debian:~# mksquashfs \
> iso_live/chroot \
> iso_live/image/live/filesystem.squashfs \
> -e boot
Parallel mksquashfs: Using 1 processor
Creating 4.0 filesystem on iso_live/image/live/filesystem.squashfs, block size 131072.
[=================================================================================================================================/] 11468/11468 100%

Exportable Squashfs 4.0 filesystem, gzip compressed, data block size 131072
	compressed data, compressed metadata, compressed fragments, compressed xattrs
	duplicates are removed
Filesystem size 190807.47 Kbytes (186.34 Mbytes)
	47.07% of uncompressed filesystem size (405395.03 Kbytes)
Inode table size 130631 bytes (127.57 Kbytes)
	30.75% of uncompressed inode table size (424777 bytes)
Directory table size 120872 bytes (118.04 Kbytes)
	46.60% of uncompressed directory table size (259401 bytes)
Xattr table size 37 bytes (0.04 Kbytes)
	92.50% of uncompressed xattr table size (40 bytes)
Number of duplicate files found 249
Number of inodes 12562
Number of files 9427
Number of fragments 1125
Number of symbolic links  1532
Number of device nodes 7
Number of fifo nodes 0
Number of socket nodes 0
Number of directories 1596
Number of ids (unique uids + gids) 7
Number of uids 1
	root (0)
Number of gids 7
	root (0)
	shadow (42)
	utmp (43)
	tty (5)
	staff (50)
	adm (4)
	mail (8)
root@debian:~# 
~~~


Copiar el kernel y el initramfs desde el directorio chroot al directorio live
~~~
root@debian:~# cp iso_live/chroot/boot/vmlinuz-3.16.0-4-686-pae iso_live/image/live/vmlinuz
root@debian:~# cp iso_live/chroot/boot/initrd.img-3.16.0-4-686-pae iso_live/image/live/initrd
root@debian:~# 
~~~


Crear un menu para el grub en el fichero ``iso_live/image/boot/grub/grub.cfg``.
~~~
set default="0"
set timeout=30

menuentry "Debian Live" {
        linux /live/vmlinuz boot=live quiet modeset
        initrd /live/initrd
}
~~~


Crear una imagen BIOS arrancable.
~~~
root@debian:~# (cd /usr/lib/grub/i386-pc && \
>     grub-mkimage \
>         --format=i386-pc \
>         --prefix="/boot/grub" \
>         --output=/root/iso_live/image/boot/grub/core.img \
>         linux \
>         normal \
>         iso9660 \
>         biosdisk
> )
root@debian:~# 
~~~


Combinar el grub con la imagen BIOS.
~~~
root@debian:~# (cd iso_live/image/boot/grub && \
>     cat \
>         /usr/lib/grub/i386-pc/cdboot.img \
>         core.img \
>     > bios.img
> )
root@debian:~# 
~~~


Generar el fichero ISO.
~~~
root@debian:~# xorriso \
>     -as mkisofs \
>     -iso-level 3 \
>     -full-iso9660-filenames \
>     -volid "DEBIAN_CUSTOM" \
>     -eltorito-boot \
>         boot/grub/bios.img \
>         -no-emul-boot -boot-load-size 4 -boot-info-table \
>         --eltorito-catalog boot/grub/boot.cat \
>     -output "iso_live/debian-custom.iso" \
>     "iso_live/image"
xorriso 1.4.6 : RockRidge filesystem manipulator, libburnia project.

Drive current: -outdev 'stdio:iso_live/debian-custom.iso'
Media current: stdio file, overwriteable
Media status : is blank
Media summary: 0 sessions, 0 data blocks, 0 data, 3173m free
Added to ISO image: directory '/'='/root/iso_live/image'
xorriso : UPDATE : 9 files added in 1 seconds
xorriso : UPDATE : 9 files added in 1 seconds
xorriso : UPDATE :  1.66% done
xorriso : UPDATE :  16.67% done
xorriso : UPDATE :  33.95% done
xorriso : UPDATE :  47.36% done, estimate finish Fri Apr 20 14:53:34 2018
xorriso : UPDATE :  60.73% done, estimate finish Fri Apr 20 14:53:34 2018
xorriso : UPDATE :  70.34% done, estimate finish Fri Apr 20 14:53:35 2018
xorriso : UPDATE :  80.11% done, estimate finish Fri Apr 20 14:53:35 2018
xorriso : UPDATE :  92.93% done
ISO image produced: 104460 sectors
Written to medium : 104460 sectors at LBA 0
Writing to 'stdio:iso_live/debian-custom.iso' completed successfully.

root@debian:~# 
~~~


### Referencias
[Will Haley](https://willhaley.com/blog/custom-debian-live-environment/)