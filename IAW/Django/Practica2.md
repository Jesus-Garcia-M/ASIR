### Entorno de desarrollo.
- Clonación del repositorio:
~~~
jesus@jesus:~/Documentos/GitHub$ git clone git@github.com:Jesus-Garcia-M/iaw_gestionGN.git PracticaDjango
Clonando en 'PracticaDjango'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 304 (delta 2), reused 1 (delta 0), pack-reused 293
Recibiendo objetos: 100% (304/304), 2.04 MiB | 910.00 KiB/s, listo.
Resolviendo deltas: 100% (112/112), listo.
jesus@jesus:~/Documentos/GitHub$ 
~~~

- Creación del entorno virtual:
~~~
jesus@jesus:~/VirtualEnvs$ python3 -m venv PracticaDjango
~~~

- Activación del entorno virtual:
~~~
jesus@jesus:~/VirtualEnvs/PracticaDjango$ source bin/activate
(PracticaDjango) jesus@jesus:~/VirtualEnvs/PracticaDjango$
~~~

- Instalación de dependecias:
~~~
(PracticaDjango) jesus@jesus:~/VirtualEnvs/PracticaDjango$ pip install -r requirements.txt
~~~

- Comprobación del tipo de base de datos a utilizar:
~~~
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
~~~

- Creación de la base de datos:
~~~
(PracticaDjango) jesus@jesus:~/Documentos/GitHub/PracticaDjango$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, centro, contenttypes, convivencia, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying centro.0001_initial... OK
  Applying centro.0002_cursos_equipoeducativo... OK
  Applying centro.0003_auto_20161102_1656... OK
  Applying centro.0004_auto_20161102_1721... OK
  Applying centro.0005_auto_20161105_1217... OK
  Applying centro.0006_auto_20161106_1741... OK
  Applying convivencia.0001_initial... OK
  Applying sessions.0001_initial... OK
(PracticaDjango) jesus@jesus:~/Documentos/GitHub/PracticaDjango$ 
~~~

- Carga de datos:
~~~
(PracticaDjango) jesus@jesus:~/Documentos/GitHub/PracticaDjango$ python manage.py loaddata datos.json
Installed 89 object(s) from 1 fixture(s)
(PracticaDjango) jesus@jesus:~/Documentos/GitHub/PracticaDjango$ 
~~~

- Inicio del servidor web:
~~~
(PracticaDjango) jesus@jesus:~/Documentos/GitHub/PracticaDjango$ python manage.py runserver
~~~

### Desarrollo de la aplicación.
- Modificación de la aplicación (`templates/base.html`):
~~~
<title>Jesús García</title>
...
<h3 class="text-muted">Gestiona - IES Gonzalo Nazareno - Versión de Jesús García</h3>
~~~

- Subida de los cambios al repositorio:
~~~
jesus@jesus:~/Documentos/GitHub/PracticaDjango$ git commit -am "Tarea 2"
jesus@jesus:~/Documentos/GitHub/PracticaDjango$ git push
Enumerando objetos: 13, listo.
Contando objetos: 100% (13/13), listo.
Compresión delta usando hasta 8 hilos
Comprimiendo objetos: 100% (7/7), listo.
Escribiendo objetos: 100% (7/7), 648 bytes | 648.00 KiB/s, listo.
Total 7 (delta 5), reusado 0 (delta 0)
remote: Resolving deltas: 100% (5/5), completed with 5 local objects.
To github.com:Jesus-Garcia-M/iaw_gestionGN.git
   2fe904d..4be17af  master -> master
jesus@jesus:~/Documentos/GitHub/PracticaDjango$ 
~~~

### Entorno de producción.
- Instalación de los paquetes necesarios:
~~~
debian@produccion-django:~$ sudo apt install apache2 mariadb-server apache2-dev libapache2-mod-wsgi-py3 python3-pip python3-venv python3-mysqldb git
~~~

- Creación del entorno virtual:
~~~
debian@produccion-django:~$ python3 -m venv django
~~~

- Clonación de repositorio:
~~~
debian@produccion-django:~$ sudo git clone https://github.com/Jesus-Garcia-M/iaw_gestionGN.git /var/www/django
Cloning into '/var/www/django'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 311 (delta 4), reused 5 (delta 2), pack-reused 293
Receiving objects: 100% (311/311), 2.04 MiB | 3.48 MiB/s, done.
Resolving deltas: 100% (114/114), done.
debian@produccion-django:~$ 
~~~

- Configuración del virtualhost (`/etc/apache2/sites-available/django.conf`):
~~~
<VirtualHost *:80>
  ServerName django.jesus.org
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/django

# Configuración WSGI
  WSGIDaemonProcess django user=www-data group=www-data processes=1 threads=5 python-path=/var/www/django:/home/debian/django/lib/python3.7/site-pack$
  WSGIScriptAlias / /var/www/django/gestion/wsgi.py

  <Directory /var/www/django>
    WSGIProcessGroup django
    WSGIApplicationGroup %{GLOBAL}
    Require all granted
  </Directory>

# Contenido estático
  Alias /static /var/www/django/static

  <Directory /var/www/django/static>
    Require all granted
  </Directory>


</VirtualHost>
~~~

- Activación del virtualhost:
~~~
debian@produccion-django:~$ sudo a2ensite django.conf
Enabling site django.
To activate the new configuration, you need to run:
  systemctl reload apache2
debian@produccion-django:~$ 
~~~

- Instalación de dependencias en el entorno virtual:
~~~
(django) debian@produccion-django:~/django$ pip install -r /var/www/django/requirements.txt
(django) debian@produccion-django:~/django$ pip freeze
Django==2.2.7
html5lib==1.0b8
mysql-connector-python==8.0.18
Pillow==6.2.1
pkg-resources==0.0.0
protobuf==3.11.0
PyPDF2==1.26.0
pytz==2019.3
reportlab==3.3.0
six==1.10.0
sqlparse==0.3.0
webencodings==0.5
xhtml2pdf==0.0.6
(django) debian@produccion-django:~/django$ 
~~~

- Creación del usuario y la base de datos:
~~~
#----- Creación de la base de datos -----#
MariaDB [(none)]> CREATE DATABASE django;
Query OK, 1 row affected (0.001 sec)

#----- Creación de usuarios -----#
MariaDB [(none)]> CREATE USER django IDENTIFIED BY "django";
Query OK, 0 rows affected (0.023 sec)

#----- Concesión de privilegios al usuario -----#
MariaDB [(none)]> GRANT ALL ON django.* TO django;
Query OK, 0 rows affected (0.014 sec)

MariaDB [(none)]> 
~~~

- Configuración de `Django` para utilizar la base de datos y acceder a la página (`settings.py`):
~~~

DATABASES = {
      'default': {
          'ENGINE': 'mysql.connector.django',
          'NAME': 'django',
          'USER': 'django',
          'PASSWORD': 'django',
          'HOST': 'localhost',
          'PORT': '',
      }
  }

DEBUG = False
ALLOWED_HOSTS = ['django.jesus.org']
~~~

- Creación de la estructura y los datos de la base de datos:
~~~
(django) debian@produccion-django:/var/www/django$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, centro, contenttypes, convivencia, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying centro.0001_initial... OK
  Applying centro.0002_cursos_equipoeducativo... OK
  Applying centro.0003_auto_20161102_1656... OK
  Applying centro.0004_auto_20161102_1721... OK
  Applying centro.0005_auto_20161105_1217... OK
  Applying centro.0006_auto_20161106_1741... OK
  Applying convivencia.0001_initial... OK
  Applying sessions.0001_initial... OK
(django) debian@produccion-django:/var/www/django$

#----- Comprobación -----#
(django) debian@produccion-django:/var/www/django$ mysql -u django -p django
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 39
Server version: 10.3.18-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [django]> show tables;
+---------------------------------+
| Tables_in_django                |
+---------------------------------+
| auth_group                      |
| auth_group_permissions          |
| auth_permission                 |
| auth_user                       |
| auth_user_groups                |
| auth_user_user_permissions      |
| centro_alumnos                  |
| centro_areas                    |
| centro_areas_Departamentos      |
| centro_cursos                   |
| centro_cursos_EquipoEducativo   |
| centro_departamentos            |
| centro_profesores               |
| convivencia_amonestaciones      |
| convivencia_sanciones           |
| convivencia_tiposamonestaciones |
| django_admin_log                |
| django_content_type             |
| django_migrations               |
| django_session                  |
+---------------------------------+
20 rows in set (0.001 sec)

MariaDB [django]> 
~~~

### Modificación de la aplicación en el entorno de producción.
- Modificación en el entorno de desarrollo (`templates/index.html`):
~~~
<center><img src="/static/img/otter.jpg"/></center>
~~~

- Creación de una nueva tabla:
  - Añadir un nuevo modelo (`centro/models.py`):
  ~~~

  ~~~