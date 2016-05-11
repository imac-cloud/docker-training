# Running Kubernetes Locally via Docker
本節將說明如何透過 docker 來部署一個單機的 kubernetes。其架構圖如下所示：

![](images/k8s-singlenode-docker.png)

### 事前準備
在開始安裝前，我們必須在部署的主機或虛擬機安裝與完成以下兩點：
* 必須安裝 docker 於主機。
```sh
$ curl http://files.imaclouds.com/scripts/docker_install.sh | sh
```

* 定義要使用的 kubernetes 版本，可以透過設定```${K8S_VERSION}```來達成，目前僅支援```Kubernetes >= “1.2.0”```版本：
```sh
$ export K8S_VERSION="1.2.0"
```

### 進行部署
完成上述後，透過執行以下指令進行部署：
```sh
$ docker run \
--volume=/:/rootfs:ro \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:rw \
--volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
--volume=/var/run:/var/run:rw \
--net=host \
--pid=host \
--privileged=true \
--name=kubelet \
-d \
gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION} \
/hyperkube kubelet \
--containerized \
--hostname-override="127.0.0.1" \
--address="0.0.0.0" \
--api-servers=http://localhost:8080 \
--config=/etc/kubernetes/manifests \
--cluster-dns=10.0.0.10 \
--allow-privileged=true --v=2
```
> ```--cluster-dns```與```--cluster-domain``` 用於部署 DNS。如果想要使用外部裝置當做 volume 的話，可以使用```--volume=/dev:/dev```。

當完成後，接著下載 kubectl 來使用 k8s 指令：
```sh
$ wget http://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl
$ chmod 755 kubectl
$ sudo ln kubectl /usr/bin/
```

上面完成後，我們要跟 k8s 的叢集連接，透過以下設定完成：
```sh
$ kubectl config set-cluster test-doc --server=http://localhost:8080
$ kubectl config set-context test-doc --cluster=test-doc
$ kubectl config use-context test-doc
```

### 驗證安裝
當完成所有步驟後，可以透過簡單指令來檢查是否安裝與連接成功，如以下：
```sh
$ kubectl get nodes
NAME        STATUS    AGE
127.0.0.1   Ready     6m
```

接著透過部署簡單應用程式來進一步確認正確性：
```sh
$ kubectl run nginx --image=nginx --port=80
replicationcontroller "nginx" created

$ kubectl expose rc nginx --port=80
service "nginx" exposed
```

透過指令檢查 pods：
```sh
$ kubectl get po -o wide
NAME                    READY     STATUS    RESTARTS   AGE       NODE
k8s-etcd-127.0.0.1      1/1       Running   0          9m        127.0.0.1
k8s-master-127.0.0.1    4/4       Running   2          9m        127.0.0.1
k8s-proxy-127.0.0.1     1/1       Running   0          10m       127.0.0.1
nginx-198147104-u9lt6   1/1       Running   0          3m        127.0.0.1
```

透過指令檢查 service：
```sh
$ kubectl get svc -o wide
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE       SELECTOR
kubernetes   10.0.0.1     <none>        443/TCP   11m       <none>
nginx        10.0.0.133   <none>        80/TCP    3m        run=nginx
```

取得應用程式的 service ip：
```sh
$ IP=$(kubectl get svc nginx --template={{.spec.clusterIP}})
$ echo ${IP}
$ curl ${IP}
```
