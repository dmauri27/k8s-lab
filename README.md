# k8s-lab

Start a quick kubernetes cluster in a Vagrant environment. The script runs on the VMs and automatically will install one master and two workers node. 
The same will install all the necessary components to startup a k8s cluster based on Ubuntu 18.04. Workers node will join the cluster in an automatically way, using calico network plugin.

**Once you have copied the files in your directory just run:**

``` 
vagrant up 
```
**When scritp has finished to run, check if master and workers are corretly running:**

1. Generate vagrant config file:
``` vagrant ssh-config > vagrant-ssh ```

2. connect to the master ```ssh -F vagrant-ssh master-01``` or ```vagrant ssh master-01```, and run:

```
kubect get no -o wide

NAME        STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master      Ready    master   24m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
worker-01   Ready    <none>   21m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
worker-02   Ready    <none>   19m   v1.16.0   10.0.2.15     <none>        Ubuntu 18.04.2 LTS   4.15.0-51-generic   docker://18.9.0
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
