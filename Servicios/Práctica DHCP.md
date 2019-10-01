# Práctica DHCP.

##### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorDHCP"
  servidor.vm.network :public_network,:bridge=>"wlan0"
  servidor.vm.network :private_network, ip: "192.168.100.1",
    virtualbox__intnet: "dhcp"
end

config.vm.define :nodo_lan1 do |nodo_lan1|
  nodo_lan1.vm.box = "buster"
  nodo_lan1.vm.hostname = "clienteDHCP"
  nodo_lan1.vm.network :private_network, type: "dhcp",
    virtualbox__intnet: "dhcp"
end
~~~

##### Configuración del servidor DHCP.
- Seleccionar la interfaz por la que va a trabajar (`/etc/default/isc-dhcp-server`):
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

#### Configuración del servidor como RouterNAT.
- Activación del bit de forward:
~~~
root@servidorDHCP:~# echo 1 > /proc/sys/net/ipv4/ip_forward
root@servidorDHCP:~# sysctl -p
~~~

- Creación de la regla de `ip tables` para hacer SNAT:
~~~

~~~