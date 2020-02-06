### Ejercicio Inicial.
- Creación de una red NAT Interna:
~~~
#----- Fichero nat-network.xml -----#
<network>
  <name>NAT</name>
  <bridge name="virbr1"/>
  <forward mode="nat"/>
  <ip address="10.10.10.100" netmask="255.255.255.0">
    <dhcp>
      <range start="10.10.10.10" end="10.10.10.50"/> 
    </dhcp>
  </ip>
</network>
~~~

