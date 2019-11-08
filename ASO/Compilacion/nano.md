# Compilación de nano.
### Dependencias.
- autoconf (version >= 2.69)
- automake (version >= 1.14)
- autopoint (version >= 0.18.3)
- gcc (version >= 5.0)
- gettext (version >= 0.18.3)
- git (version >= 2.7.4)
- groff (version >= 1.12)
- make (any version)
- pkg-config (version >= 0.22)
- texinfo (version >= 4.0)
- Soporte de UTF-8: libncursesw5-dev (version >= 5.7)

### Compilación.
- Ejecución de `./autogen.sh`
- Ejecución de `./configure --enable-utf8 --enable-multibuffer --disable-speller --disable-nls --disable-operatingdir`
- Ejecución de `make`
- Ejecución de `sudo make install`

### Desinstalación.
- Ejecución de `sudo make uninstall`
