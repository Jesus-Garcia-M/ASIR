### Ficheros de configuración:
- `/etc/default/isc-dhcp-server`
- `/etc/dhcp/dhcpd.conf`

### Log de concesiones:
- `/var/lib/dhcp/dhcpd.leases`

### Parámetros configurables:
- `max-lease-time`: Tiempo máximo de concesión.
- `default-lease-time`: Tiempo de renovación de la concesión.
- `option routers`: Dirección de la puerta de enlace.
- `option domain-name-servers`: Dirección de los servidores DNS.
- `option domain-name`: Nombre de dominio.
- `option subnetmask`: Máscara de subred.
- `option broadcast-address`: Dirección de difusión de la red.
- `range`: Rango de dirección IP a asignar.
- `hardware ethernet`: Dirección MAC del cliente (Utilizado en reservas).
- `fixed-address`: Dirección IP que se va a asignar al cliente (Utilizado en reservas).