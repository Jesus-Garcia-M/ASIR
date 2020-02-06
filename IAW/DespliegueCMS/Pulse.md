# Pulse.
Pulse es un CMS genérico escrito en Java, utilizado para la creación de páginas a media y gran escala.

### Instalación.
- Instalación de `Apache2` y `Tomcat`:
~~~
debian@tomcat:~$ sudo apt install apache2 tomcat9
~~~

- Descarga y descompresión del paquete `Pulse`:
~~~
#----- Descarga -----#
debian@tomcat:~$ wget https://sourceforge.net/projects/pulse-java/files/latest/download

#----- Descompresión -----#
debian@tomcat:~$ unzip pulse.zip
debian@tomcat:~/pulse$ ls -l
total 76
drwxr-xr-x 2 debian debian  4096 Oct 26  2010 build
-rw-r--r-- 1 debian debian   232 Oct 26  2010 build.bat
-rw-r--r-- 1 debian debian   181 Oct 26  2010 build.properties
-rw-r--r-- 1 debian debian   491 Oct 26  2010 build.sh
-rw-r--r-- 1 debian debian  1737 Oct 26  2010 build.xml
drwxr-xr-x 5 debian debian  4096 Oct 26  2010 custom-webapp
-rw-r--r-- 1 debian debian  1681 Oct 26  2010 INSTALLING.txt
-rw-r--r-- 1 debian debian   332 Oct 26  2010 JAVA5-COMPATIBILITY.txt
-rw-r--r-- 1 debian debian 35821 Oct 26  2010 LICENSE.txt
drwxr-xr-x 3 debian debian  4096 Oct 26  2010 util
drwxr-xr-x 7 debian debian  4096 Oct 26  2010 webapp
debian@tomcat:~/pulse$
~~~

- Configuración de logs (`custom-webapp/WEB-INF/conf/log4j-config.xml`):
~~~
debian@tomcat:~/pulse$ cp webapp/WEB-INF/conf/log4j-config.xml custom-webapp/WEB-INF/conf/

#----- Modificación -----#
<param name="File" value="/home/debian/pulse/pulse.log"/>
~~~

- Creación de la base de datos en `tortilla`:
~~~
MariaDB [(none)]> CREATE DATABASE pulse;
Query OK, 1 row affected (0.02 sec)

MariaDB [(none)]> GRANT ALL ON pulse.* TO pulse@10.0.0.9 IDENTIFIED BY 'pulse';
Query OK, 0 rows affected (0.04 sec)

MariaDB [(none)]>
~~~

- Configuración de la base de datos (`custom-webapp/WEB-INF/conf/pulse.xml`):
~~~
debian@tomcat:~/pulse$ cp webapp/WEB-INF/conf/pulse.xml custom-webapp/WEB-INF/conf/

#----- Modificación -----#
<property name="hibernate.connection.url">
  jdbc:mysql://10.0.0.10:3306/pulsedb?autoReconnect=true&amp;characterEncoding=UTF-8
</property>
<property name="hibernate.connection.username">pulse</property>
<property name="hibernate.connection.password">pulse</property>
~~~

- Creación de la aplicación:
~~~
debian@tomcat:~/pulse$ ./build.sh
Buildfile: /home/debian/pulse/build.xml

build-all:
     [echo] Cleaning build directory
   [delete] Deleting directory /home/debian/pulse/build
     [echo] Copying webapp files
     [copy] Copying 1981 files to /home/debian/pulse/build/pulse
     [copy] Copied 201 empty directories to 2 empty directories under /home/debian/pulse/build/pulse
     [echo] Overwriting with custom edited files
     [copy] Copying 2 files to /home/debian/pulse/build/pulse
     [copy] Copied 49 empty directories to 7 empty directories under /home/debian/pulse/build/pulse
     [echo] Creating WAR
      [war] Building war: /home/debian/pulse/build/pulse.war

BUILD SUCCESSFUL
Total time: 10 seconds
debian@tomcat:~/pulse$
~~~

- Despliegue de la aplicación en `Tomcat`:
~~~

~~~