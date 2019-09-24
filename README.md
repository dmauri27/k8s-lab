# k8s-lab

Start a quick kubernetes cluster in a Vagrant environment. The script runs on the VMs and automatically will install one master and two workers node. 
The same will install all the necessary components to startup a k8s cluster based on Ubuntu 18.04. Workers node will join the cluster in an automatically way, using calico network plugin.

**Prerequisite**

- VirtualBox or similar
- NAT and Internal network cards (configured in Vagrant)

**Once you have copied the files in your directory just run:**

``` 
vagrant up 
```
**When scritp has finished to run, check if master and workers are corretly running:**

1. Generate vagrant config file: Run this every time you add new host to your Vagrant file

``` vagrant ssh-config > vagrant-ssh ```

2. connect to the master ```ssh -F vagrant-ssh master-01``` or ```vagrant ssh master-01```, and run:

```
sudo -i
kubectl get no -o wide

NAME        STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master      Ready    master   24m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
worker-01   Ready    <none>   21m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
worker-02   Ready    <none>   19m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
```
```
kubectl get po --all-namespaces

NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-564b6667d7-r979r   1/1     Running   0          7m1s
kube-system   calico-node-fw87x                          1/1     Running   0          3m54s
kube-system   calico-node-pd68w                          1/1     Running   0          7m1s
kube-system   calico-node-pmm8h                          1/1     Running   0          71s
kube-system   coredns-5644d7b6d9-7f8zr                   1/1     Running   0          7m1s
kube-system   coredns-5644d7b6d9-wzb5j                   1/1     Running   0          7m1s
kube-system   etcd-master                                1/1     Running   0          5m58s
kube-system   kube-apiserver-master                      1/1     Running   0          6m4s
kube-system   kube-controller-manager-master             1/1     Running   0          6m6s
kube-system   kube-proxy-qpb96                           1/1     Running   0          71s
kube-system   kube-proxy-strts                           1/1     Running   0          3m54s
kube-system   kube-proxy-z4ffr                           1/1     Running   0          7m1s
kube-system   kube-scheduler-master                      1/1     Running   0          6m17s
```


3. Run simple deployment based on nginx webserver and expose it through HTTP port 80 on container port HTTP 80

```
kubectl create deployment nginx --image=nginx

kubectl get deployments -o wide

NAME    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES   SELECTOR
nginx   1/1     1            1           26m   nginx        nginx    app=nginx


kubectl expose deployment nginx --port 80 --target-port 80

kubectl get svc

NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   21m
nginx        ClusterIP   10.110.243.211   <none>        80/TCP    8s

curl -I 10.110.243.211

HTTP/1.1 200 OK
Server: nginx/1.17.3
Date: Sat, 21 Sep 2019 20:59:30 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 13 Aug 2019 08:50:00 GMT
Connection: keep-alive
ETag: "5d5279b8-264"
Accept-Ranges: bytes
```
4. Destroy vagrant environment

  ```vagrant destroy -f```
