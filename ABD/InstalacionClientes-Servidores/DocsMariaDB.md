- Abrir el puerto 3306:
~~~
vagrant@MariaDBServer:~$ sudo iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
~~~