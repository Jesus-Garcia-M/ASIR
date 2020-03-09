# Kubeadm.
En esta instalación de `kubeadm` utilizaremos `Debian Buster 10.3` y dispondremos del siguiente escenario:
- 1 nodo master (`kubeadm-1`).
- 2 nodos worker (`kubeadm-2` y `kubeadm-3`).

### Configuraciones previas.
Antes de comenzar la instalación, los nodos deberán poder acceder a los siguientes puertos:

También es necesario desactivar la `swap`:
~~~
swapoff -a
~~~

Además, es necesaria la utilización de `iptables` en modo `legacy`, para ello, haremos lo siguiente:
~~~
# Instalamos los siguiente paquetes en el caso de que no los tengamos ya instalados.
apt install iptables arptables ebtables

# Activamos el modo legacy de los paquetes previamente instalados.
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
~~~

Por último, instalaremos `docker` en todos los nodos:
~~~
apt install docker.io
~~~

### Instalación del nodo master.
Instalamos los paquetes que vamos a necesitar durante la instalación:
~~~
root@kubeadm-1:~# apt install apt-transport-https curl gnupg2
~~~

Importamos las claves de `kubernetes`:
~~~
root@kubeadm-1:~# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
OK
root@kubeadm-1:~#
~~~

Añadimos el repositorio de `kubernetes`:
~~~
root@kubeadm-1:~# cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
> deb https://apt.kubernetes.io/ kubernetes-xenial main
> EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
root@kubeadm-1:~#
~~~

A continuación, actualizamos e instalamos `kubelet`, `kubeadm` y `kubectl`:
~~~
root@kubeadm-1:~# apt update
...
root@kubeadm-1:~# apt install kubelet kubeadm kubectl
~~~

Con todo listo, iniciamos `kubeadm` indicando el direccionamiento de red para los pods y la dirección del servidor API:
~~~
root@kubeadm-1:~# kubeadm init --pod-network-cidr=10.0.10.0/24 --apiserver-cert-extra-sans=172.22.201.81
~~~

Con el servidor iniciado, realizamos las acciones que nos indican para iniciar nuestro cluster:
~~~
root@kubeadm-1:~# mkdir -p $HOME/.kube
root@kubeadm-1:~# cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
root@kubeadm-1:~# chown $(id -u):$(id -g) $HOME/.kube/config
root@kubeadm-1:~#
~~~

Por último, permitimos la comunicación con otros nodos:
~~~
root@kubeadm-1:~# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created
root@kubeadm-1:~# 
~~~

### Instalación de los nodos worker.
Para poder añadir los nodos al cluster, primero será necesario instalar `kubeadm` al igual que hemos hecho en el master:
~~~
# kubeadm-2
root@kubeadm-2:~# apt install apt-transport-https curl gnupg2
root@kubeadm-2:~# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
OK
root@kubeadm-2:~# cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
> deb https://apt.kubernetes.io/ kubernetes-xenial main
> EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
root@kubeadm-2:~# apt update
root@kubeadm-2:~# apt install kubeadm

# kubeadm-3
root@kubeadm-3:~# apt install apt-transport-https curl gnupg2
root@kubeadm-3:~# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
OK
root@kubeadm-3:~# cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
> deb https://apt.kubernetes.io/ kubernetes-xenial main
> EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
root@kubeadm-3:~# apt update
root@kubeadm-3:~# apt install kubeadm
~~~

A continuación añadiremos los nodos al cluster, utilizando los tokens obtenidos en la instalación del master:
~~~
# kubeadm-2
root@kubeadm-2:~# kubeadm join 10.0.0.16:6443 --token pkc19g.9lt0ad7bkjd2b7k2 --discovery-token-ca-cert-hash sha256:f052eab2e93c4480fffdb5499fc425489ba779a6ad5035dc6a8ff3f0622fb6aa

# kubeadm-3
root@kubeadm-3:~# kubeadm join 10.0.0.16:6443 --token pkc19g.9lt0ad7bkjd2b7k2 --discovery-token-ca-cert-hash sha256:f052eab2e93c4480fffdb5499fc425489ba779a6ad5035dc6a8ff3f0622fb6aa
~~~

Como comprobación, listaremos los nodos del cluster desde el master:
~~~
root@kubeadm-1:~# kubectl get nodes
NAME        STATUS   ROLES    AGE     VERSION
kubeadm-1   Ready    master   18m     v1.17.3
kubeadm-2   Ready    <none>   5m53s   v1.17.3
kubeadm-3   Ready    <none>   6m      v1.17.3
root@kubeadm-1:~#
~~~

### Despliegue de una aplicación en el cluster.
Antes de crear los contenedores para la aplicación será necesario definir una serie de servicios y namespaces para su correcto funcionamiento.

Definimos el namespace `despliegue-ns` con el siguiente contenido (`despliegue-ns.yaml`):
~~~
apiVersion: v1
kind: Namespace
metadata:
  name: despliegue-ns

# Creación:
kubectl create -f despliegue-ns.yaml
namespace/despliegue-ns created
~~~

Definimos un servicio `ClusterIP` para permitir la conexión al pod de base de datos (`db-cip.yaml`):
~~~
apiVersion: v1
kind: Service
metadata:
  name: db-cip
  namespace: despliegue-ns
  labels:
    app: wordpress
    type: database
spec:
  selector:
    app: wordpress
    type: database
  ports:
  - port: 3306
    targetPort: db-port
  type: ClusterIP

# Creación:
kubectl create -f db-cip.yaml
service/db-cip created
~~~

Definimos un servicio `Nodeport` para permitir la conexión desde el exterior a nuestra aplicación `Wordpress` (`wp-np.yaml`):
~~~
apiVersion: v1
kind: Service
metadata:
  name: wp-np
  namespace: despliegue-ns
  labels:
    app: wordpress
    type: frontend
spec:
  selector:
    app: wordpress
    type: frontend
  ports:
  - name: http-sv-port 
    port: 80
    targetPort: http-port
  type: NodePort 

# Creación:
kubectl create -f wp-np.yaml
service/wp-np created
~~~

Comprobamos que los servicios se han creado correctamente:
~~~
kubectl get service -n despliegue-ns
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
db-cip     ClusterIP   10.96.27.207    <none>        3306/TCP       10m
wp-np      NodePort    10.109.69.178   <none>        80:32031/TCP   3m8s
~~~

Creamos un secreto con las variables para la creción de la base de datos así como para la conexión a la misma:
~~~
  kubectl create secret generic db-secret --namespace=despliegue-ns \
--from-literal=dbuser=wp_user \
--from-literal=dbname=wp_db \
--from-literal=dbpassword=wp_pass \
--from-literal=dbrootpassword=root \
-o yaml --dry-run > db-secrets.yaml

# Creación:
kubectl create -f db-secrets.yaml
secret/db-secret created
~~~

Comprobamos que se ha creado correctamente:
~~~
kubectl get secrets -n despliegue-ns
NAME                  TYPE                                  DATA   AGE
db-secret             Opaque                                4      7m15s
default-token-m4ckj   kubernetes.io/service-account-token   3      14m
~~~

Por último, realizamos un despliegue de `MariaDB` y `Wordpress`:
~~~
# db-deply.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wpdb-deploy
  namespace: despliegue-ns
  labels:
    app: wordpress
    type: database
spec:
  selector:
    matchLabels:
      app: wordpress
  replicas: 1
  template:
    metadata:
      labels:
        app: wordpress
        type: database
    spec:
      containers:
        - name: wp-db
          image: mariadb
          ports:
            - containerPort: 3306
              name: db-port
          env:
            - name: MYSQL_USER
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbuser
            - name: MYSQL_DATABASE
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbname
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbpassword
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbrootpassword

# wp-deploy.yaml
apiVersion: apps/v1     
kind: Deployment
metadata:
  name: wp-deploy
  namespace: despliegue-ns
  labels:
    app: wordpress
    type: frontend
spec:
  selector:
    matchLabels:
      app: wordpress
  replicas: 1      
  template:
    metadata:
      labels:
        app: wordpress
        type: frontend
    spec:
      containers:
        - name: wordpress
          image: wordpress
          ports:
            - containerPort: 80
              name: http-port
          env:
            - name: WORDPRESS_DB_HOST
              value: db-cip
            - name: WORDPRESS_DB_USER
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbuser
            - name: WORDPRESS_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbpassword
            - name: WORDPRESS_DB_NAME
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: dbname

# Creación:
kubectl create -f db-deploy.yaml
deployment.apps/wpdb-deploy created

kubectl create -f wp-deploy.yaml
deployment.apps/wp-deploy created

# Comprobación:
kubectl get deploy,rs,pods -n despliegue-ns
NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wp-deploy     1/1     1            1           40s
deployment.apps/wpdb-deploy   1/1     1            1           57s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/wp-deploy-8575c8cb4d    1         1         1       40s
replicaset.apps/wpdb-deploy-877cc7fdb   1         1         1       57s

NAME                              READY   STATUS    RESTARTS   AGE
pod/wp-deploy-8575c8cb4d-54fzh    1/1     Running   0          40s
pod/wpdb-deploy-877cc7fdb-8wkrj   1/1     Running   0          57s
~~~