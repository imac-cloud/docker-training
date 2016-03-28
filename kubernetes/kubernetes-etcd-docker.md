
```sh
docker run -d --name=etcd \                                                   
--net=host \                                                                
gcr.io/google_containers/etcd:2.2.1 \                                       
/usr/local/bin/etcd \                                                   
--listen-client-urls=http://0.0.0.0:4001 \                                  
--advertise-client-urls=http://0.0.0.0:4001 \                               
--data-dir=/var/etcd/data
```

```sh
docker run -d --name=api \                                                    
--net=host --pid=host --privileged=true \                                   
gcr.io/google_containers/hyperkube:v1.1.2 \                                 
/hyperkube apiserver \                                                      
--insecure-bind-address=0.0.0.0 \                                           
--service-cluster-ip-range=10.0.0.1/24 \                                    
--etcd_servers=http://127.0.0.1:4001 \                                      
--cluster_name=kubernetes --v=2
```

```sh
docker run -d --name=kubs \                                                   
--volume=/:/rootfs:ro \                                                       
--volume=/sys:/sys:ro \                                                       
--volume=/dev:/dev \                                                          
--volume=/var/lib/docker/:/var/lib/docker:rw \                                
--volume=/var/lib/kubelet/:/var/lib/kubelet:rw \                              
--volume=/var/run:/var/run:rw \                                               
--net=host \                                                                  
--pid=host \                                                                  
--privileged=true \                                                           
gcr.io/google_containers/hyperkube:v1.1.2 \                                   
/hyperkube kubelet \                                                          
--containerized \                                                             
--hostname-override="0.0.0.0" \                                               
--address="0.0.0.0" \                                                         
--cluster_dns=10.0.0.10 --cluster_domain=cluster.local \                      
--api-servers=http://localhost:8080 \                                         
--config=/etc/kubernetes/manifests-multi
```

```sh
docker run -d --name=proxy\                                                   
--net=host \                                                                
--privileged \                                                              
gcr.io/google_containers/hyperkube:v1.1.2 \                                 
/hyperkube proxy \                                                          
--master=http://0.0.0.0:8080 --v=2
```

```sh
$ curl -o ~/.bin/kubectl http://storage.googleapis.com/kubernetes-release/rel
ease/v1.1.2/bin/linux/amd64/kubectl
$ chmod u+x ~/.bin/kubectl
$ export KUBERNETES_MASTER=http://docker:8080
```

```sh
kubectl create -f ~/skydns-rc.yaml
kubectl create -f ~/skydns-svc.yaml
```

```sh
kubectl create -f ~/kube-ui-rc.yaml
kubectl create -f ~/kube-ui-svc.yaml
```

```sh
curl http://docker:4001/version
curl http://docker:8080/version
export KUBERNETES_MASTER=http://docker:8080
kubectl cluster-info
kubectl get nodes
```
