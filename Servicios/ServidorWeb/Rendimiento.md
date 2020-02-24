## Ejecución de scripts PHP.
##### Apache2 + mod-php.
- Instalación de `Apache2` y del módulo php:
~~~
vagrant@rendimiento:~$ sudo apt install apache2 libapache2-mod-php7.3
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2232 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.008 seconds
Complete requests:      2232
Failed requests:        0
Non-2xx responses:      2232
Total transferred:      542376 bytes
HTML transferred:       0 bytes
Requests per second:    223.03 [#/sec] (mean)
Time per request:       896.743 [ms] (mean)
Time per request:       4.484 [ms] (mean, across all concurrent requests)
Transfer rate:          52.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   15 117.0      0    1032
Processing:    23  706 912.9    537    7357
Waiting:       17  705 912.6    533    7357
Total:         37  721 920.4    542    7369

Percentage of the requests served within a certain time (ms)
  50%    542
  66%    663
  75%    728
  80%    810
  90%    971
  95%   1129
  98%   2114
  99%   7204
 100%   7369 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2253 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.011 seconds
Complete requests:      2253
Failed requests:        0
Non-2xx responses:      2253
Total transferred:      547479 bytes
HTML transferred:       0 bytes
Requests per second:    225.05 [#/sec] (mean)
Time per request:       888.683 [ms] (mean)
Time per request:       4.443 [ms] (mean, across all concurrent requests)
Transfer rate:          53.41 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   21 154.1      0    3021
Processing:    16  760 943.6    591    7596
Waiting:       16  759 943.5    589    7596
Total:         18  781 956.8    594    7598

Percentage of the requests served within a certain time (ms)
  50%    594
  66%    730
  75%    810
  80%    847
  90%   1068
  95%   1445
  98%   4132
  99%   7346
 100%   7598 (longest request)
root@rendimiento:~#

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2850 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.277 seconds
Complete requests:      2850
Failed requests:        0
Non-2xx responses:      2851
Total transferred:      692793 bytes
HTML transferred:       0 bytes
Requests per second:    277.32 [#/sec] (mean)
Time per request:       721.180 [ms] (mean)
Time per request:       3.606 [ms] (mean, across all concurrent requests)
Transfer rate:          65.83 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   24 155.4      0    3040
Processing:    16  608 797.0    479    7561
Waiting:       16  604 794.4    477    7560
Total:         18  633 808.8    484    7563

Percentage of the requests served within a certain time (ms)
  50%    484
  66%    559
  75%    614
  80%    652
  90%    767
  95%    926
  98%   1589
  99%   7356
 100%   7563 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2618 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.004 seconds
Complete requests:      2618
Failed requests:        0
Non-2xx responses:      2618
Total transferred:      636174 bytes
HTML transferred:       0 bytes
Requests per second:    261.68 [#/sec] (mean)
Time per request:       764.282 [ms] (mean)
Time per request:       3.821 [ms] (mean, across all concurrent requests)
Transfer rate:          62.10 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   19 135.1      0    1031
Processing:    19  657 882.6    438    7631
Waiting:       19  653 882.1    437    7631
Total:         24  676 890.5    439    7633

Percentage of the requests served within a certain time (ms)
  50%    439
  66%    621
  75%    697
  80%    757
  90%    941
  95%   1189
  98%   1911
  99%   7480
 100%   7633 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2865 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.022 seconds
Complete requests:      2865
Failed requests:        0
Non-2xx responses:      2901
Total transferred:      704943 bytes
HTML transferred:       0 bytes
Requests per second:    285.86 [#/sec] (mean)
Time per request:       699.645 [ms] (mean)
Time per request:       3.498 [ms] (mean, across all concurrent requests)
Transfer rate:          68.69 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   21 149.5      0    3035
Processing:    10  599 805.4    448    7381
Waiting:       10  592 803.4    448    7381
Total:         19  619 816.4    452    7383

Percentage of the requests served within a certain time (ms)
  50%    452
  66%    522
  75%    588
  80%    647
  90%    753
  95%   1069
  98%   1554
  99%   7190
 100%   7383 (longest request)
root@rendimiento:~#

# Media: 254.58 peticiones por segundo.
~~~

##### Apache2 + PHP-FPM (Socket UNIX).
- Instalación de `PHP-FPM`:
~~~
vagrant@rendimiento:~$ sudo apt install php7.3-fpm
~~~

- Configuración de `PHP-FPM` (`/etc/php/7.3/fpm/pool.d/www.conf`):
~~~
# Usuario y grupo que lo van a utilizar, en este caso el usuario/grupo de Apache2.
user = www-data
group = www-data
# Tipo de socket que va a utilizar.
listen = /run/php/php7.3-fpm.sock
~~~

- Activación de los módulos necesarios en `Apache2`:
~~~
root@rendimiento:~# a2enmod proxy_fcgi setenvif mpm_event
Considering dependency proxy for proxy_fcgi:
Module proxy already enabled
Enabling module proxy_fcgi.
Enabling module setenvif.
Considering conflict mpm_worker for mpm_event:
Considering conflict mpm_prefork for mpm_event:
Enabling module mpm_event.
To activate the new configuration, you need to run:
  systemctl restart apache2
root@rendimiento:~#
~~~

- Configuración de `Apache2` (Configuración general: `/etc/apache2/conf-available/php7.3-fpm` \ Configuración por virtualhost: `/etc/apache2/sites-available` \ *Nota:* En ambos casos la configuración es la misma, la única diferencia es el fichero en el que se configura.):
~~~
# Directivas del fichero (Configuración general):
<FilesMatch ".+\.ph(ar|p|tml)$">
SetHandler "proxy:unix:/run/php/php7.3-fpm.sock|fcgi://localhost"
</FilesMatch>

# Activación de la configuración:
root@rendimiento:~# a2enconf php7.3-fpm
Enabling conf php7.3-fpm.
To activate the new configuration, you need to run:
  systemctl reload apache2
root@rendimiento:~#
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 3225 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.000 seconds
Complete requests:      3225
Failed requests:        0
Non-2xx responses:      3225
Total transferred:      783675 bytes
HTML transferred:       0 bytes
Requests per second:    322.49 [#/sec] (mean)
Time per request:       620.167 [ms] (mean)
Time per request:       3.101 [ms] (mean, across all concurrent requests)
Transfer rate:          76.53 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  43.7      0    1018
Processing:    14  595 113.5    603    1192
Waiting:       11  594 113.5    603    1192
Total:         17  597 120.4    604    1590

Percentage of the requests served within a certain time (ms)
  50%    604
  66%    611
  75%    617
  80%    627
  90%    732
  95%    779
  98%    795
  99%    891
 100%   1590 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2971 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.006 seconds
Complete requests:      2971
Failed requests:        0
Non-2xx responses:      2971
Total transferred:      721953 bytes
HTML transferred:       0 bytes
Requests per second:    296.92 [#/sec] (mean)
Time per request:       673.582 [ms] (mean)
Time per request:       3.368 [ms] (mean, across all concurrent requests)
Transfer rate:          70.46 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  37.4      0    1025
Processing:    10  650 203.2    610    1762
Waiting:       10  650 203.2    610    1762
Total:         12  651 205.8    610    1762

Percentage of the requests served within a certain time (ms)
  50%    610
  66%    621
  75%    630
  80%    733
  90%    976
  95%   1124
  98%   1144
  99%   1196
 100%   1762 (longest request)
root@rendimiento:~#

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2873 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.003 seconds
Complete requests:      2873
Failed requests:        0
Non-2xx responses:      2873
Total transferred:      698139 bytes
HTML transferred:       0 bytes
Requests per second:    287.20 [#/sec] (mean)
Time per request:       696.378 [ms] (mean)
Time per request:       3.482 [ms] (mean, across all concurrent requests)
Transfer rate:          68.15 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  42.2      0    1026
Processing:    12  652 215.7    605    1764
Waiting:        6  652 215.7    605    1764
Total:         12  654 218.4    605    1764

Percentage of the requests served within a certain time (ms)
  50%    605
  66%    617
  75%    639
  80%    676
  90%   1107
  95%   1134
  98%   1153
  99%   1208
 100%   1764 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2752 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.001 seconds
Complete requests:      2752
Failed requests:        0
Non-2xx responses:      2752
Total transferred:      668736 bytes
HTML transferred:       0 bytes
Requests per second:    275.17 [#/sec] (mean)
Time per request:       726.826 [ms] (mean)
Time per request:       3.634 [ms] (mean, across all concurrent requests)
Transfer rate:          65.30 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  51.7      0    1034
Processing:    17  683 270.1    591    2283
Waiting:       11  683 270.1    591    2283
Total:         17  686 273.0    592    2287

Percentage of the requests served within a certain time (ms)
  50%    592
  66%    672
  75%    803
  80%    916
  90%   1086
  95%   1100
  98%   1311
  99%   1474
 100%   2287 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2868 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.006 seconds
Complete requests:      2868
Failed requests:        0
Non-2xx responses:      2868
Total transferred:      696924 bytes
HTML transferred:       0 bytes
Requests per second:    286.62 [#/sec] (mean)
Time per request:       697.793 [ms] (mean)
Time per request:       3.489 [ms] (mean, across all concurrent requests)
Transfer rate:          68.02 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    5  62.7      0    1027
Processing:    14  654 241.3    597    2245
Waiting:       10  654 241.3    597    2245
Total:         17  659 247.2    597    2250

Percentage of the requests served within a certain time (ms)
  50%    597
  66%    609
  75%    735
  80%    789
  90%   1040
  95%   1079
  98%   1163
  99%   1475
 100%   2250 (longest request)
root@rendimiento:~#

# Media: 293.68 peticiones por segundo.
~~~

##### Apache2 + PHP-FPM (Socket TCP/IP).
- Ya que anteriormente hemos instalado `PHP-FPM`, el único cambio necesario es cambiar el socket UNIX por un socket TCP/IP, para ello modificaremos los ficheros `/etc/php/7.3/fpm/pool.d/www.conf` y `/etc/apache2/conf-available/php7.3-fpm`:
~~~
# Fichero www.conf:
listen = 127.0.0.1:9000

# Fichero php7.3-fpm:
<FilesMatch ".+\.ph(ar|p|tml)$">
SetHandler "proxy:fcgi://127.0.0.1:9000"
</FilesMatch>
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 3158 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.004 seconds
Complete requests:      3158
Failed requests:        0
Non-2xx responses:      3158
Total transferred:      767394 bytes
HTML transferred:       0 bytes
Requests per second:    315.68 [#/sec] (mean)
Time per request:       633.551 [ms] (mean)
Time per request:       3.168 [ms] (mean, across all concurrent requests)
Transfer rate:          74.91 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    5  65.3      0    1031
Processing:    12  496 329.4    404    4675
Waiting:        6  496 329.4    404    4675
Total:         12  500 336.1    404    4675

Percentage of the requests served within a certain time (ms)
  50%    404
  66%    507
  75%    519
  80%    525
  90%    563
  95%    749
  98%   1462
  99%   1754
 100%   4675 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2765 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.002 seconds
Complete requests:      2765
Failed requests:        0
Non-2xx responses:      2765
Total transferred:      671895 bytes
HTML transferred:       0 bytes
Requests per second:    276.44 [#/sec] (mean)
Time per request:       723.471 [ms] (mean)
Time per request:       3.617 [ms] (mean, across all concurrent requests)
Transfer rate:          65.60 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  47.6      0    1032
Processing:    11  595 420.5    524    5448
Waiting:        6  595 420.5    524    5448
Total:         11  597 422.6    524    5448

Percentage of the requests served within a certain time (ms)
  50%    524
  66%    586
  75%    648
  80%    721
  90%    751
  95%    874
  98%   1790
  99%   2257
 100%   5448 (longest request)
root@rendimiento:~#

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2783 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.001 seconds
Complete requests:      2783
Failed requests:        0
Non-2xx responses:      2783
Total transferred:      676269 bytes
HTML transferred:       0 bytes
Requests per second:    278.26 [#/sec] (mean)
Time per request:       718.747 [ms] (mean)
Time per request:       3.594 [ms] (mean, across all concurrent requests)
Transfer rate:          66.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  43.1      0    1029
Processing:    16  539 311.8    507    6622
Waiting:        9  539 311.8    507    6622
Total:         16  542 314.0    508    6627

Percentage of the requests served within a certain time (ms)
  50%    508
  66%    542
  75%    560
  80%    610
  90%    729
  95%    748
  98%   1432
  99%   1739
 100%   6627 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2825 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.001 seconds
Complete requests:      2825
Failed requests:        0
Non-2xx responses:      2825
Total transferred:      686475 bytes
HTML transferred:       0 bytes
Requests per second:    282.48 [#/sec] (mean)
Time per request:       708.009 [ms] (mean)
Time per request:       3.540 [ms] (mean, across all concurrent requests)
Transfer rate:          67.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  33.3      0    1035
Processing:    11  601 413.3    537    4658
Waiting:       11  601 413.3    537    4658
Total:         17  602 414.4    537    4658

Percentage of the requests served within a certain time (ms)
  50%    537
  66%    591
  75%    613
  80%    675
  90%    783
  95%   1430
  98%   1798
  99%   2471
 100%   4658 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://apache.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking apache.jesus.org (be patient)
Finished 2476 requests


Server Software:        Apache/2.4.38
Server Hostname:        apache.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.004 seconds
Complete requests:      2476
Failed requests:        0
Non-2xx responses:      2476
Total transferred:      601668 bytes
HTML transferred:       0 bytes
Requests per second:    247.51 [#/sec] (mean)
Time per request:       808.039 [ms] (mean)
Time per request:       4.040 [ms] (mean, across all concurrent requests)
Transfer rate:          58.74 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  45.7      0    1032
Processing:    13  663 618.2    544    9159
Waiting:        6  663 618.2    544    9159
Total:         16  665 619.3    545    9164

Percentage of the requests served within a certain time (ms)
  50%    545
  66%    718
  75%    735
  80%    741
  90%    824
  95%    942
  98%   1777
  99%   3648
 100%   9164 (longest request)
root@rendimiento:~#

# Media: 280.1 peticiones por segundo.
~~~

##### Nginx + PHP-FPM (Socket UNIX).
- La configuración de `PHP-FPM` es la misma que la realizada en `Apache2` por lo que pasaré a mostrar la configuración de `Nginx` necesaria en cada virtual host:
~~~
location ~ \.php$ {
  include snippets/fastcgi-php.conf;
  fastcgi_pass unix:/run/php/php7.3-fpm.sock;
}
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   9.136 seconds
Complete requests:      50000
Failed requests:        48110
   (Connect: 0, Receive: 0, Length: 48110, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16038320 bytes
HTML transferred:       8323030 bytes
Requests per second:    5473.01 [#/sec] (mean)
Time per request:       36.543 [ms] (mean)
Time per request:       0.183 [ms] (mean, across all concurrent requests)
Transfer rate:          1714.41 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    5   2.7      4      25
Processing:     0   30 123.0      6    1054
Waiting:        0   28 123.0      4    1053
Total:          1   35 123.3     11    1065

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     12
  75%     13
  80%     14
  90%     20
  95%     24
  98%    580
  99%    614
 100%   1065 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   9.022 seconds
Complete requests:      50000
Failed requests:        48135
   (Connect: 0, Receive: 0, Length: 48135, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16041120 bytes
HTML transferred:       8327355 bytes
Requests per second:    5542.12 [#/sec] (mean)
Time per request:       36.087 [ms] (mean)
Time per request:       0.180 [ms] (mean, across all concurrent requests)
Transfer rate:          1736.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   3.0      4      26
Processing:     0   30 122.1      6    1060
Waiting:        0   28 122.1      4    1060
Total:          0   34 122.5     11    1069

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     12
  75%     13
  80%     14
  90%     20
  95%     25
  98%    584
  99%    624
 100%   1069 (longest request)
root@rendimiento:~# 

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   9.065 seconds
Complete requests:      50000
Failed requests:        48286
   (Connect: 0, Receive: 0, Length: 48286, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16058032 bytes
HTML transferred:       8353478 bytes
Requests per second:    5515.70 [#/sec] (mean)
Time per request:       36.260 [ms] (mean)
Time per request:       0.181 [ms] (mean, across all concurrent requests)
Transfer rate:          1729.91 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   3.7      3      28
Processing:     0   31 128.8      6    1081
Waiting:        0   29 128.7      5    1076
Total:          0   34 129.3     10    1082

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     12
  75%     15
  80%     17
  90%     22
  95%     29
  98%    589
  99%    789
 100%   1082 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   8.879 seconds
Complete requests:      50000
Failed requests:        48164
   (Connect: 0, Receive: 0, Length: 48164, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16044368 bytes
HTML transferred:       8332372 bytes
Requests per second:    5631.48 [#/sec] (mean)
Time per request:       35.515 [ms] (mean)
Time per request:       0.178 [ms] (mean, across all concurrent requests)
Transfer rate:          1764.72 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   3.0      4      23
Processing:     0   29 121.2      6    1071
Waiting:        0   28 121.2      4    1065
Total:          1   34 121.6     10    1083

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     12
  75%     13
  80%     14
  90%     20
  95%     26
  98%    581
  99%    646
 100%   1083 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   9.750 seconds
Complete requests:      50000
Failed requests:        48211
   (Connect: 0, Receive: 0, Length: 48211, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16049632 bytes
HTML transferred:       8340503 bytes
Requests per second:    5128.28 [#/sec] (mean)
Time per request:       38.999 [ms] (mean)
Time per request:       0.195 [ms] (mean, across all concurrent requests)
Transfer rate:          1607.56 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    5   3.4      4      22
Processing:     0   32 135.8      6    1064
Waiting:        0   30 135.8      4    1062
Total:          1   37 136.3     11    1074

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     13
  75%     16
  80%     18
  90%     22
  95%     27
  98%    631
  99%    847
 100%   1074 (longest request)
root@rendimiento:~#

# Media: 5458.12 peticiones por segundo.
~~~

##### Nginx + PHP-FPM (Socket TCP/IP).
- Al igual que antes, lo único necesario es cambiar la comfiguración de `PHP-FPM` tal y como hicimos en `Apache2` y modificar la configuración de los virtualhost de `Nginx`:
~~~
location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass 127.0.0.1:9000;
}
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Finished 2803 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.001 seconds
Complete requests:      2803
Failed requests:        0
Non-2xx responses:      2803
Total transferred:      597039 bytes
HTML transferred:       0 bytes
Requests per second:    280.27 [#/sec] (mean)
Time per request:       713.596 [ms] (mean)
Time per request:       3.568 [ms] (mean, across all concurrent requests)
Transfer rate:          58.30 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  50.5      0    1012
Processing:    13  489 311.5    393    8246
Waiting:       11  488 311.5    393    8246
Total:         17  491 327.9    393    8248

Percentage of the requests served within a certain time (ms)
  50%    393
  66%    433
  75%    522
  80%    646
  90%    728
  95%    740
  98%   1402
  99%   1736
 100%   8248 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Finished 2641 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.001 seconds
Complete requests:      2641
Failed requests:        0
Non-2xx responses:      2641
Total transferred:      562533 bytes
HTML transferred:       0 bytes
Requests per second:    264.08 [#/sec] (mean)
Time per request:       757.358 [ms] (mean)
Time per request:       3.787 [ms] (mean, across all concurrent requests)
Transfer rate:          54.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   3.6      0      17
Processing:    14  553 450.0    395    8241
Waiting:        7  553 450.0    395    8241
Total:         14  554 450.3    395    8257

Percentage of the requests served within a certain time (ms)
  50%    395
  66%    580
  75%    699
  80%    725
  90%    750
  95%   1383
  98%   1748
  99%   1815
 100%   8257 (longest request)
root@rendimiento:~# 

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Finished 2602 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.000 seconds
Complete requests:      2602
Failed requests:        0
Non-2xx responses:      2602
Total transferred:      554226 bytes
HTML transferred:       0 bytes
Requests per second:    260.19 [#/sec] (mean)
Time per request:       768.674 [ms] (mean)
Time per request:       3.843 [ms] (mean, across all concurrent requests)
Transfer rate:          54.12 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   2.6      0      13
Processing:    18  549 410.7    422    8133
Waiting:       10  549 410.8    422    8133
Total:         18  550 410.9    422    8145

Percentage of the requests served within a certain time (ms)
  50%    422
  66%    496
  75%    694
  80%    717
  90%    751
  95%    793
  98%   1721
  99%   1781
 100%   8145 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Finished 2686 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.005 seconds
Complete requests:      2686
Failed requests:        0
Non-2xx responses:      2686
Total transferred:      572118 bytes
HTML transferred:       0 bytes
Requests per second:    268.47 [#/sec] (mean)
Time per request:       744.967 [ms] (mean)
Time per request:       3.725 [ms] (mean, across all concurrent requests)
Transfer rate:          55.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   1.5      0       8
Processing:    13  520 368.5    387    8112
Waiting:        7  520 368.5    387    8112
Total:         13  520 368.4    387    8115

Percentage of the requests served within a certain time (ms)
  50%    387
  66%    524
  75%    690
  80%    707
  90%    732
  95%    746
  98%   1681
  99%   1749
 100%   8115 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Finished 2595 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   10.000 seconds
Complete requests:      2595
Failed requests:        0
Non-2xx responses:      2595
Total transferred:      552735 bytes
HTML transferred:       0 bytes
Requests per second:    259.49 [#/sec] (mean)
Time per request:       770.749 [ms] (mean)
Time per request:       3.854 [ms] (mean, across all concurrent requests)
Transfer rate:          53.98 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   3.1      0      16
Processing:    14  543 407.9    393    8455
Waiting:        7  543 407.9    393    8455
Total:         14  544 407.9    393    8469

Percentage of the requests served within a certain time (ms)
  50%    393
  66%    648
  75%    700
  80%    707
  90%    721
  95%    733
  98%   1707
  99%   1748
 100%   8469 (longest request)
root@rendimiento:~#

# Media: 266.5 peticiones por segundo.
~~~

## Aumento de rendimiento.
Como hemos podido comprobar con las estadísticas anteriores, `Nginx` + `PHP-FPM (Socket UNIX)` es la opción que mejores resultados ha dado, debido a esto, vamos a intentar aumentar incluso más el rendimiento de la misma.

##### Nginx + PHP-FPM (Socket UNIX) + Memcached.
- Instalación de `Memcached`:
~~~
root@rendimiento:~# apt install memcached
root@rendimiento:~# apt install php7.3-memcached
~~~

- Inicio del servicio:
~~~
root@rendimiento:~# systemctl start memcached
~~~

- Comprobación de funcionamiento:
~~~
root@rendimiento:~# netstat -tap | grep memcached
tcp        0      0 localhost:11211         0.0.0.0:*               LISTEN      2066/memcached      
root@rendimiento:~#
~~~

- Comprobación de configuración:
~~~
root@rendimiento:~# echo "stats settings" | nc localhost 11211
STAT maxbytes 67108864
STAT maxconns 1024
STAT tcpport 11211
STAT udpport 0
STAT inter 127.0.0.1
STAT verbosity 0
STAT oldest 0
STAT evictions on
STAT domain_socket NULL
STAT umask 700
STAT growth_factor 1.25
STAT chunk_size 48
STAT num_threads 4
STAT num_threads_per_udp 4
STAT stat_key_prefix :
STAT detail_enabled no
STAT reqs_per_event 20
STAT cas_enabled yes
STAT tcp_backlog 1024
STAT binding_protocol auto-negotiate
STAT auth_enabled_sasl no
STAT item_size_max 1048576
STAT maxconns_fast yes
STAT hashpower_init 0
STAT slab_reassign yes
STAT slab_automove 1
STAT slab_automove_ratio 0.80
STAT slab_automove_window 30
STAT slab_chunk_max 524288
STAT lru_crawler yes
STAT lru_crawler_sleep 100
STAT lru_crawler_tocrawl 0
STAT tail_repair_time 0
STAT flush_enabled yes
STAT dump_enabled yes
STAT hash_algorithm murmur3
STAT lru_maintainer_thread yes
STAT lru_segmented yes
STAT hot_lru_pct 20
STAT warm_lru_pct 40
STAT hot_max_factor 0.20
STAT warm_max_factor 2.00
STAT temp_lru no
STAT temporary_ttl 61
STAT idle_timeout 0
STAT watcher_logbuf_size 262144
STAT worker_logbuf_size 65536
STAT track_sizes no
STAT inline_ascii_response no
END
~~~

- Instalación del plugin `W3 Total Cache` en `Wordpress`:
~~~
root@rendimiento:/var/www/wordpress/wp-content/plugins# wget https://downloads.wordpress.org/plugin/w3-total-cache.0.12.0.zip
root@rendimiento:/var/www/wordpress/wp-content/plugins# unzip w3-total-cache.0.12.0.zip
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   7.873 seconds
Complete requests:      50000
Failed requests:        48216
   (Connect: 0, Receive: 0, Length: 48216, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16050192 bytes
HTML transferred:       8341368 bytes
Requests per second:    6350.76 [#/sec] (mean)
Time per request:       31.492 [ms] (mean)
Time per request:       0.157 [ms] (mean, across all concurrent requests)
Transfer rate:          1990.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   2.4      4      30
Processing:     0   27 108.7      6     819
Waiting:        0   25 108.7      4     817
Total:          1   31 108.9     10     826

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     11
  75%     12
  80%     13
  90%     15
  95%     19
  98%    575
  99%    619
 100%    826 (longest request)
root@rendimiento:~#

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   8.320 seconds
Complete requests:      50000
Failed requests:        47920
   (Connect: 0, Receive: 0, Length: 47920, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16017040 bytes
HTML transferred:       8290160 bytes
Requests per second:    6009.83 [#/sec] (mean)
Time per request:       33.279 [ms] (mean)
Time per request:       0.166 [ms] (mean, across all concurrent requests)
Transfer rate:          1880.07 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   2.3      4      17
Processing:     0   28 105.4      6     603
Waiting:        0   26 105.4      4     603
Total:          1   32 105.7     11     618

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     12
  75%     12
  80%     13
  90%     16
  95%     20
  98%    556
  99%    568
 100%    618 (longest request)
root@rendimiento:~#

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   7.570 seconds
Complete requests:      50000
Failed requests:        48138
   (Connect: 0, Receive: 0, Length: 48138, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16041456 bytes
HTML transferred:       8327874 bytes
Requests per second:    6604.85 [#/sec] (mean)
Time per request:       30.281 [ms] (mean)
Time per request:       0.151 [ms] (mean, across all concurrent requests)
Transfer rate:          2069.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   2.3      4      16
Processing:     0   26 101.6      6     637
Waiting:        0   24 101.6      4     637
Total:          1   29 101.8     10     644

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     11
  75%     12
  80%     12
  90%     14
  95%     18
  98%    553
  99%    579
 100%    644 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   7.250 seconds
Complete requests:      50000
Failed requests:        48252
   (Connect: 0, Receive: 0, Length: 48252, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16054224 bytes
HTML transferred:       8347596 bytes
Requests per second:    6896.41 [#/sec] (mean)
Time per request:       29.001 [ms] (mean)
Time per request:       0.145 [ms] (mean, across all concurrent requests)
Transfer rate:          2162.43 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   2.4      4      17
Processing:     0   24 100.2      5     701
Waiting:        0   23 100.1      4     701
Total:          0   28 100.4      9     705

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     11
  75%     12
  80%     12
  90%     14
  95%     17
  98%    557
  99%    576
 100%    705 (longest request)
root@rendimiento:~#

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   7.513 seconds
Complete requests:      50000
Failed requests:        48246
   (Connect: 0, Receive: 0, Length: 48246, Exceptions: 0)
Non-2xx responses:      50000
Total transferred:      16053552 bytes
HTML transferred:       8346558 bytes
Requests per second:    6655.29 [#/sec] (mean)
Time per request:       30.051 [ms] (mean)
Time per request:       0.150 [ms] (mean, across all concurrent requests)
Transfer rate:          2086.74 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4   2.1      4      13
Processing:     0   25 103.9      5     684
Waiting:        0   24 103.9      4     683
Total:          1   29 104.1     10     689

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     11
  75%     12
  80%     12
  90%     14
  95%     16
  98%    578
  99%    608
 100%    689 (longest request)
root@rendimiento:~#

# Media: 6503.43 peticiones por segundo.
~~~

##### Nginx + PHP-FPM (Socket UNIX) + Varnish.
- Instalación de `Varnish`:
~~~
root@rendimiento:~# apt install varnish
~~~

- Configuración (`/etc/default/varnish`):
~~~
DAEMON_OPTS="-a :80 \
             -T localhost:6082 \
             -f /etc/varnish/default.vcl \
             -S /etc/varnish/secret \
             -s malloc,256m"
~~~

- Modificación de la unidad systemd para que `Varnish` se inicie en el puerto 80 (`/lib/systemd/system/varnish.service`):
~~~
ExecStart=/usr/sbin/varnishd -j unix,user=vcache -F -a :80 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,256m
~~~

- Reinicio del servicio:
~~~
root@rendimiento:~# systemctl daemon-reload
root@rendimiento:~# systemctl restart varnish
~~~

- Pruebas de rendimiento:
~~~
# Test 1.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   4.095 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      14690015 bytes
HTML transferred:       0 bytes
Requests per second:    12211.20 [#/sec] (mean)
Time per request:       16.378 [ms] (mean)
Time per request:       0.082 [ms] (mean, across all concurrent requests)
Transfer rate:          3503.57 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    9  54.4      6    1041
Processing:     0    7   2.2      6      37
Waiting:        0    6   2.1      5      31
Total:          0   16  54.5     12    1048

Percentage of the requests served within a certain time (ms)
  50%     12
  66%     16
  75%     17
  80%     18
  90%     19
  95%     19
  98%     21
  99%     24
 100%   1048 (longest request)
root@rendimiento:~# 

# Test 2.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   3.800 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      14742565 bytes
HTML transferred:       0 bytes
Requests per second:    13158.40 [#/sec] (mean)
Time per request:       15.199 [ms] (mean)
Time per request:       0.076 [ms] (mean, across all concurrent requests)
Transfer rate:          3788.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    8  38.7      7    1036
Processing:     1    7   2.0      7      21
Waiting:        0    5   1.8      5      15
Total:          5   15  38.8     14    1044

Percentage of the requests served within a certain time (ms)
  50%     14
  66%     16
  75%     17
  80%     18
  90%     19
  95%     19
  98%     20
  99%     21
 100%   1044 (longest request)
root@rendimiento:~# 

# Test 3.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   3.933 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      14984955 bytes
HTML transferred:       0 bytes
Requests per second:    12713.88 [#/sec] (mean)
Time per request:       15.731 [ms] (mean)
Time per request:       0.079 [ms] (mean, across all concurrent requests)
Transfer rate:          3721.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    8  38.0      8    1018
Processing:     1    7   1.8      8      18
Waiting:        0    6   1.7      6      16
Total:          4   16  38.2     15    1026

Percentage of the requests served within a certain time (ms)
  50%     15
  66%     16
  75%     16
  80%     16
  90%     17
  95%     18
  98%     20
  99%     22
 100%   1026 (longest request)
root@rendimiento:~#

# Test 4.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   4.098 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      15043390 bytes
HTML transferred:       0 bytes
Requests per second:    12199.75 [#/sec] (mean)
Time per request:       16.394 [ms] (mean)
Time per request:       0.082 [ms] (mean, across all concurrent requests)
Transfer rate:          3584.49 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    8   0.8      8      13
Processing:     0    8   0.9      8      15
Waiting:        0    6   1.7      6      13
Total:          9   16   1.3     16      24

Percentage of the requests served within a certain time (ms)
  50%     16
  66%     16
  75%     17
  80%     17
  90%     18
  95%     19
  98%     20
  99%     21
 100%     24 (longest request)
root@rendimiento:~# 

# Test 5.
root@rendimiento:~# ab -t 10 -c 200 http://nginx.jesus.org/index.php
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking nginx.jesus.org (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        nginx/1.14.2
Server Hostname:        nginx.jesus.org
Server Port:            80

Document Path:          /index.php
Document Length:        0 bytes

Concurrency Level:      200
Time taken for tests:   4.208 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      15043486 bytes
HTML transferred:       0 bytes
Requests per second:    11880.83 [#/sec] (mean)
Time per request:       16.834 [ms] (mean)
Time per request:       0.084 [ms] (mean, across all concurrent requests)
Transfer rate:          3490.80 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    8   1.2      8      36
Processing:     1    9   1.1      8      37
Waiting:        1    6   1.5      6      16
Total:         10   17   1.9     17      51

Percentage of the requests served within a certain time (ms)
  50%     17
  66%     17
  75%     17
  80%     18
  90%     18
  95%     19
  98%     21
  99%     24
 100%     51 (longest request)
root@rendimiento:~#

# Media: 12432.9 peticiones por segundo.
~~~

- Si nos fijamos en los logs (`/var/log/nginx/access.log`), podemos comprobar que solo se realiza una petición al servidor:
~~~
root@rendimiento:~# tail /var/log/nginx/access.log
...
127.0.0.1 - - [15/Jan/2020:09:00:19 +0000] "GET /index.php HTTP/1.1" 301 5 "-" "ApacheBench/2.3"
127.0.0.1 - - [15/Jan/2020:09:01:09 +0000] "POST /wp-admin/admin-ajax.php HTTP/1.1" 200 58 "http://nginx.jesus.org/wp-admin/plugin-install.php?s=w3+total&tab=search&type=term" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
127.0.0.1 - - [15/Jan/2020:09:02:19 +0000] "GET /index.php HTTP/1.1" 301 5 "-" "ApacheBench/2.3"
127.0.0.1 - - [15/Jan/2020:09:03:09 +0000] "POST /wp-admin/admin-ajax.php HTTP/1.1" 200 58 "http://nginx.jesus.org/wp-admin/plugin-install.php?s=w3+total&tab=search&type=term" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
127.0.0.1 - - [15/Jan/2020:09:04:12 +0000] "POST /wp-admin/admin-ajax.php HTTP/1.1" 200 58 "http://nginx.jesus.org/wp-admin/plugin-install.php?s=w3+total&tab=search&type=term" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
root@rendimiento:~#
~~~