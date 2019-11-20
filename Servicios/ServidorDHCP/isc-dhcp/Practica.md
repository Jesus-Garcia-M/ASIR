# Práctica DHCP.

## Primer Escenario.
### Configuración del servidor DHCP.
- Configuración de la interfaz por la que va a trabajar (`/etc/default/isc-dhcp-server`):
~~~
...
INTERFACESv4="eth2"
...
~~~

- Configuración del ámbito (`/etc/dhcp/dhcpd.conf`):
~~~
...
subnet 192.168.100.0 netmask 255.255.255.0 {
	range 192.168.100.10 192.168.100.20;
	max-lease-time 43200;
	default-lease-time 21600;
	option routers 192.168.100.1;
	option domain-name-servers 192.168.202.2;
}
...
~~~

### Configuración del servidor como RouterNAT.
- Cambio de la ruta de encaminamiento por defecto:
~~~
vagrant@servidorDHCP:~$ sudo ip r del default
vagrant@servidorDHCP:~$ sudo ip r add default via 172.22.0.1
~~~

- Activación del bit de forward:
~~~
vagrant@servidorDHCP:~$ sudo sysctl -w net.ipv4.ip_forward=1
vagrant@servidorDHCP:~$ sudo sysctl -p
~~~

- Creación de la regla de `ip tables` para hacer SNAT:
~~~
vagrant@servidorDHCP:~$ sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth1 -j MASQUERADE
~~~

### Captura de los paquetes de una concesión.
- Captura con `dhcpdump`:
~~~
vagrant@servidorDHCP:~$ sudo dhcpdump -i eth2
~~~

- Captura con `tcpdump`:
~~~
vagrant@servidorDHCP:~$ sudo tcpdump -i eth2 -nn -s0 -vv port 68
~~~

### Creación de una reserva para el cliente.
- Creación de la reserva (`/etc/dhcp/dhcpd.conf`):
~~~
host ClienteDebian {
hardware ethernet 08:00:27:b5:f4:f7;
fixed-address 192.168.100.100;
}
~~~

## Segundo Escenario.
### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorDHCP"
  servidor.vm.network :public_network,:bridge=>"wlan0"
  servidor.vm.network :private_network, ip: "192.168.100.1",
    virtualbox__intnet: "dhcp"
  servidor.vm.network :private_network, ip: "192.168.200.1",
    virtualbox__intnet: "dhcp-2"
end

config.vm.define :nodo_lan1 do |nodo_lan1|
  nodo_lan1.vm.box = "buster"
  nodo_lan1.vm.hostname = "clienteDHCP"
  nodo_lan1.vm.network :private_network, type: "dhcp",
    virtualbox__intnet: "dhcp"
end

config.vm.define :nodo_lan2 do |nodo_lan2|
  nodo_lan2.vm.box = "buster"
  nodo_lan2.vm.hostname = "clienteDHCP-2"
  nodo_lan2.vm.network :private_network, type: "dhcp",
    virtualbox__intnet: "dhcp-2"
end
~~~

### Configuración del servidor DHCP.
- Configuración de la nueva interfaz (`/etc/default/isc-dhcp-server`):
~~~
INTERFACESv4="eth2 eth3"
~~~

- Configuración del nuevo ámbito (`/etc/dhcp/dhcpd.conf`):
~~~
subnet 192.168.200.0 netmask 255.255.255.0 {
        range 192.168.200.10 192.168.200.20;
        max-lease-time 86400;
        default-lease-time 43200;
        option routers 192.168.200.1;
        option domain-name-servers 192.168.202.2;
}
~~~

### Configuración del servidor como RouterNAT.
- Cambio de la ruta de encaminamiento por defecto:
~~~
vagrant@servidorDHCP:~$ sudo ip r del default
vagrant@servidorDHCP:~$ sudo ip r add default via 172.22.0.1
~~~

- Activación del bit de forward:
~~~
vagrant@servidorDHCP:~$ sudo sysctl -w net.ipv4.ip_forward=1
vagrant@servidorDHCP:~$ sudo sysctl -p
~~~

- Creación de la regla de `ip tables` para hacer SNAT:
~~~
vagrant@servidorDHCP:~$ sudo iptables -t nat -A POSTROUTING -s 192.168.200.0/24 -o eth1 -j MASQUERADE
~~~