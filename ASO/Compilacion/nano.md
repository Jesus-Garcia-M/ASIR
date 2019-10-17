# Compilación de nano.
### Dependencias.
- autoconf (version >= 2.69)
~~~
jesus@jesus:~/nano$ apt show autoconf
Package: autoconf
Version: 2.69-11
Priority: optional
Section: devel
Maintainer: Ben Pfaff <pfaffben@debian.org>
Installed-Size: 1.913 kB
Depends: perl (>> 5.005), m4 (>= 1.4.13), debianutils (>= 1.8)
Recommends: automake | automaken
Suggests: autoconf-archive, gnu-standards, autoconf-doc, libtool, gettext
Breaks: gettext (<< 0.10.39), pkg-config (<< 0.25-1.1)
Homepage: http://www.gnu.org/software/autoconf/

jesus@jesus:~/nano$ 
~~~

- automake (version >= 1.14)
~~~
jesus@jesus:~/nano$ apt show automake
Package: automake
Version: 1:1.16.1-4
Priority: optional
Section: devel
Source: automake-1.16
Maintainer: Eric Dorland <eric@debian.org>
Installed-Size: 1.827 kB
Provides: automake-1.16, automaken
Depends: autoconf (>= 2.65), autotools-dev (>= 20020320.1)
Suggests: autoconf-doc, gnu-standards
Conflicts: automake (<< 1:1.4-p5-1), automake1.10-doc, automake1.5 (<< 1.5-2), automake1.6 (<< 1.6.1-4)
Homepage: https://www.gnu.org/software/automake/

jesus@jesus:~/nano$ 
~~~

- autopoint (version >= 0.18.3)
~~~
jesus@jesus:~/nano$ sudo apt show autopoint
Package: autopoint
Version: 0.19.8.1-9
Priority: optional
Section: devel
Source: gettext
Maintainer: Santiago Vila <sanvila@debian.org>
Installed-Size: 466 kB
Depends: xz-utils
Replaces: gettext (<= 0.17-11)
Homepage: http://www.gnu.org/software/gettext/

jesus@jesus:~/nano$ 
~~~

- gcc (version >= 5.0)
~~~
jesus@jesus:~/nano$ sudo apt show gcc
Package: gcc
Version: 4:8.3.0-1
Priority: optional
Build-Essential: yes
Section: devel
Source: gcc-defaults (1.181)
Maintainer: Debian GCC Maintainers <debian-gcc@lists.debian.org>
Installed-Size: 46,1 kB
Provides: c-compiler, gcc-x86-64-linux-gnu (= 4:8.3.0-1)
Depends: cpp (= 4:8.3.0-1), gcc-8 (>= 8.3.0-1~)
Recommends: libc6-dev | libc-dev
Suggests: gcc-multilib, make, manpages-dev, autoconf, automake, libtool, flex, bison, gdb, gcc-doc
Conflicts: gcc-doc (<< 1:2.95.3)

jesus@jesus:~/nano$ 
~~~

- gettext (version >= 0.18.3)
~~~
jesus@jesus:~/nano$ apt show gettext
Package: gettext
Version: 0.19.8.1-9
Priority: optional
Section: devel
Maintainer: Santiago Vila <sanvila@debian.org>
Installed-Size: 6.752 kB
Depends: libc6 (>= 2.17), libcroco3 (>= 0.6.2), libglib2.0-0 (>= 2.12.0), libgomp1 (>= 4.9), libncurses6 (>= 6), libtinfo6 (>= 6), libunistring2 (>= 0.9.7), libxml2 (>= 2.9.1), gettext-base, dpkg (>= 1.15.4) | install-info
Recommends: curl | wget | lynx
Suggests: gettext-doc, autopoint, libasprintf-dev, libgettextpo-dev
Breaks: autopoint (<= 0.17-11)
Homepage: http://www.gnu.org/software/gettext/

jesus@jesus:~/nano$ 
~~~

- git (version >= 2.7.4)
~~~
jesus@jesus:~/nano$ apt show git
Package: git
Version: 1:2.20.1-2
Priority: optional
Section: vcs
Maintainer: Gerrit Pape <pape@smarden.org>
Installed-Size: 36,1 MB
Provides: git-completion, git-core
Depends: libc6 (>= 2.28), libcurl3-gnutls (>= 7.56.1), libexpat1 (>= 2.0.1), libpcre2-8-0 (>= 10.32), zlib1g (>= 1:1.2.0), perl, liberror-perl, git-man (>> 1:2.20.1), git-man (<< 1:2.20.1-.)
Recommends: ca-certificates, patch, less, ssh-client
Suggests: gettext-base, git-daemon-run | git-daemon-sysvinit, git-doc, git-el, git-email, git-gui, gitk, gitweb, git-cvs, git-mediawiki, git-svn
Breaks: bash-completion (<< 1:1.90-1), cogito (<= 0.18.2+), dgit (<< 5.1~), git-buildpackage (<< 0.6.5), git-core (<< 1:1.7.0.4-1.), gitosis (<< 0.2+20090917-7), gitpkg (<< 0.15), gitweb (<< 1:1.7.4~rc1), guilt (<< 0.33), openssh-client (<< 1:6.8), stgit (<< 0.15), stgit-contrib (<< 0.15)
Replaces: git-core (<< 1:1.7.0.4-1.), gitweb (<< 1:1.7.4~rc1)
Homepage: https://git-scm.com/

jesus@jesus:~/nano$
~~~

- groff       (version >= 1.12)
~~~
jesus@jesus:~/nano$ apt show groff
Package: groff
Version: 1.22.4-3
Priority: optional
Section: text
Maintainer: Colin Watson <cjwatson@debian.org>
Installed-Size: 12,1 MB
Provides: groff-x11, jgroff
Depends: groff-base (= 1.22.4-3), libc6 (>= 2.14), libgcc1 (>= 1:3.0), libice6 (>= 1:1.0.0), libsm6, libstdc++6 (>= 4.1.1), libx11-6, libxaw7, libxmu6, libxt6
Recommends: ghostscript, imagemagick, libpaper1, netpbm, perl, psutils
Breaks: groff-x11 (<< 1.18-1), jgroff (<< 1.17-1)
Replaces: groff-base (<< 1.17.2-9), groff-x11 (<< 1.18-1), jgroff (<< 1.17-1)
Homepage: https://www.gnu.org/software/groff/

jesus@jesus:~/nano$ 
~~~

- make (any version)
~~~
jesus@jesus:~/nano$ apt show make
Package: make
Version: 4.2.1-1.2
Priority: optional
Build-Essential: yes
Section: devel
Source: make-dfsg
Maintainer: Manoj Srivastava <srivasta@debian.org>
Installed-Size: 1.327 kB
Depends: libc6 (>= 2.27)
Suggests: make-doc
Conflicts: make-guile
Replaces: make-guile
Homepage: https://www.gnu.org/software/make/

jesus@jesus:~/nano$ 
~~~

- pkg-config (version >= 0.22)
~~~
jesus@jesus:~/nano$ apt show pkg-config
Package: pkg-config
Version: 0.29-6
Priority: optional
Section: devel
Maintainer: Tollef Fog Heen <tfheen@debian.org>
Installed-Size: 208 kB
Depends: libc6 (>= 2.14), libglib2.0-0 (>= 2.16.0), libdpkg-perl
Suggests: dpkg-dev
Conflicts: pkg-config-bin
Replaces: pkg-config-bin
Homepage: http://pkg-config.freedesktop.org

jesus@jesus:~/nano$ 
~~~

- texinfo (version >= 4.0)
~~~
jesus@jesus:~/nano$ apt show texinfo
Package: texinfo
Version: 6.5.0.dfsg.1-4+b1
Priority: optional
Section: text
Source: texinfo (6.5.0.dfsg.1-4)
Maintainer: Debian TeX maintainers <debian-tex-maint@lists.debian.org>
Installed-Size: 9.329 kB
Depends: libc6 (>= 2.14), perl (>= 5.28.0-3), perlapi-5.28.0, libtext-unidecode-perl, libxml-libxml-perl, tex-common (>= 6)
Suggests: texlive-base, texlive-latex-base, texlive-generic-recommended, texinfo-doc-nonfree, texlive-fonts-recommended
Breaks: ja-trans (<= 0.7-3.1), tetex-base (<< 3.0), tetex-bin (<< 3.0)
Replaces: tetex-base (<< 1.0.2+20000804-9), tetex-bin (<< 3.0)
Homepage: https://www.gnu.org/software/texinfo/

jesus@jesus:~/nano$ 
~~~

### Dependencias para soporte UTF-8.
- libncursesw5-dev (version >= 5.7)
~~~
jesus@jesus:~/nano$ apt show libncursesw5-dev
Package: libncursesw5-dev
Version: 6.1+20181013-2+deb10u1
Priority: optional
Section: libdevel
Source: ncurses
Maintainer: Craig Small <csmall@debian.org>
Installed-Size: 6.144 B
Depends: libtinfo6 (= 6.1+20181013-2+deb10u1), libncurses-dev (= 6.1+20181013-2+deb10u1)
Homepage: https://invisible-island.net/ncurses/

jesus@jesus:~/nano$ 
~~~

### Compilación.
- Ejecución de `./autogen.sh`