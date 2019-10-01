# Práctica DHCP.

##### Creación del escenario Vagrant.
~~~
config.vm.define :servidor do |servidor|
  servidor.vm.box = "buster"
  servidor.vm.hostname = "servidorDHCP"
  servidor.vm.network :public_network,:bridge=>"wlan0"
  servidor.vm.network :private_network, ip: "192.168.100.63",
    virtualbox__intnet: "dhcp"
end

config.vm.define :nodo_lan1 do |nodo_lan1|
  nodo_lan1.vm.box = "buster"
  nodo_lan1.vm.hostname = "clienteDHCP"
  nodo_lan1.vm.network :private_network, type: "dhcp",
    virtualbox__intnet: "dhcp"
  nodo_lan1.vm.provision "shell",
    inline: "sudo ip r del default"  
end
~~~
\

##### Configuración del servidor DHCP.
- Seleccionar la interfaz por la que va a trabajar (`/etc/default/isc-dhcp-server`):
~~~
...
INTERFACESv4="eth2"
...
~~~

- Configuración del ámbito (`/etc/dhcp/dhcpd.conf`):