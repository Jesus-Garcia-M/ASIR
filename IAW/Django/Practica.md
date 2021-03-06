# Despliegue de una aplicación en Django.
### Entorno de desarrollo.
- Creación del entorno virtual:
~~~
jesus@jesus:~/VirtualEnvs$ python3 -m venv Django
~~~

- Clonación del repositorio que contiene la aplicación:
~~~
jesus@jesus:~/VirtualEnvs/Django$ git clone https://github.com/josedom24/django_tutorial
~~~

- Instalación de los programas necesarios:
~~~
#----- Contenido requirements.txt -----#
Django==2.2.7
gunicorn==20.0.0
pkg-resources==0.0.0
pytz==2019.3
sqlparse==0.3.0


(Django) jesus@jesus:~/VirtualEnvs/Django$ pip install -r django_tutorial/requirements.txt
~~~

- Comprobación de la base de datos con la que se trabaja (`django-tutorial/django-tutorial/settings.py`)
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
(Django) jesus@jesus:~/VirtualEnvs/Django/django_tutorial$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
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
  Applying polls.0001_initial... OK
  Applying sessions.0001_initial... OK
(Django) jesus@jesus:~/VirtualEnvs/Django/django_tutorial$ 
~~~

- Creación del usuario `admin`:
~~~
(Django) jesus@jesus:~/VirtualEnvs/Django/django_tutorial$ python manage.py createsuperuser
Nombre de usuario (leave blank to use 'jesus'): jesus
Dirección de correo electrónico: 
Password: 
Password (again): 
Esta contraseña es demasiado corta. Debe contener al menos 8 caracteres.
Esta contraseña es completamente numérica.
Bypass password validation and create user anyway? [y/N]: y
Superuser created successfully.
(Django) jesus@jesus:~/VirtualEnvs/Django/django_tutorial$ 
~~~

- Ejecución del servidor en local:
~~~
(Django) jesus@jesus:~/VirtualEnvs/Django/django_tutorial$ python manage.py runserver
~~~

### Entorno de producción.
- Instalación de `apache2`:
~~~
debian@desplieguedjango:~$ sudo apt install apache2
~~~

- Instalación de `apache2-dev`:
~~~
vagrant@django:~$ sudo apt install apache2-dev
~~~

- Instalación de `libapache2-mod-wsgi-py3`:
~~~
vagrant@django:~$ sudo apt install libapache2-mod-wsgi-py3
~~~

- Instalación de `pip`:
~~~
vagrant@django:~$ sudo apt install python3-pip
~~~

- Instalación de `django`:
~~~
vagrant@django:~$ sudo pip3 install django
~~~

- Configuración de `apache2` (`/etc/apache2/sites-available/django.conf`):
~~~
<VirtualHost *:80>
  ServerName django.jesus.org
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/django

# Configuración WSGI
  WSGIDaemonProcess django user=www-data group=www-data processes=1 threads=5 python-path=/var/www/django
  WSGIScriptAlias / /var/www/django/django_tutorial/wsgi.py

  <Directory /var/www/django>
    WSGIProcessGroup django
    WSGIApplicationGroup %{GLOBAL}
    Require all granted
  </Directory>

</VirtualHost>
~~~

- Activación del sitio:
~~~
root@django:/var/www# a2ensite django.conf
Enabling site django.
To activate the new configuration, you need to run:
  systemctl reload apache2
root@django:/var/www# 
~~~

- Creación de la base de datos:
~~~
root@django:/var/www/django# python3 manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
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
  Applying polls.0001_initial... OK
  Applying sessions.0001_initial... OK
root@django:/var/www/django# 
~~~

- Creación del usuario `admin`:
~~~
root@django:/var/www/django# python3 manage.py createsuperuser
Nombre de usuario (leave blank to use 'root'): admin
Dirección de correo electrónico:  
Password: 
Password (again): 
Superuser created successfully.
root@django:/var/www/django# 
~~~

- Modificación de la configuración de `Django` (`/var/www/django/django_tutorial/settings.py`):
~~~
DEBUG = False
ALLOWED_HOSTS = ['django.jesus.org']
~~~

- Modificación para mostrar el contenido estático:
~~~
#----- Configuración en settings.py -----#
STATIC_ROOT = '/var/www/django/static'

#----- Creación del contenido -----#
root@django:/var/www/django# python3 manage.py collectstatic

121 static files copied to '/var/www/django/static'.
root@django:/var/www/django#

#----- Modificación del virtual host -----#
# Contenido estático
  Alias /static /var/www/django/static

  <Directory /var/www/django/static>
    Require all granted
  </Directory>
~~~