## Logs: rsyslog
`Rsyslog` es un demonio que se encarga de recolectar los logs del sistema así como de las distintas aplicaciones del mismo.

### Configuración del servidor.
- Abrir el puerto 514 `udp` y `tcp` para la recepción de logs (`/etc/rsyslog.conf`):
~~~
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")
~~~

- Configuración del nivel de prioridad de los logs que queremos guardar (`/etc/rsyslog.d/50-default.conf`):
En este caso solo deseamos guardar los logs de los niveles `crit`, `emerg`, `error` y `alert`. Adicionalmente, guardaremos dicha información de los demonios del sistema y del kernel:
~~~
daemon.crit;daemon.emerg;daemon.error;daemon.alert      -/var/log/daemon.log
kern.crit;kern.emerg;kern.error;kern.alert              -/var/log/kern.log
~~~

- Por último, añadiremos la siguiente configuración para así tener los logs de las distintas máquinas en un directorio distinto (`/etc/rsyslog.conf`):
~~~
$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
& stop
*.* ?RemoteLogs
~~~

### Configuración de los clientes.
En todos los clientes la configuración será la misma, debemos indicar la dirección donde se enviarán los logs (`/etc/rsyslog.conf`):
~~~
*.* @10.0.0.14:514
~~~