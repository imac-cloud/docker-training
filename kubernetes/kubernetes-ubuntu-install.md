# Kubernetes 安裝與操作
Kubernetes 是 Google 的容器叢集管理系統，是一個開放式原始碼，主要提供應用程式部署、快速的擴展與系統自動維護等功能，Kubernetes讓IT人員可以跨主機執行 Docker 化的應用程式。

## Ubuntu Kubernetes 安裝
Kubernetes 提供了許多雲端平台與作業系統的安裝方式，本章將針對 Ubuntu 進行部署教學，若想要瞭解更多平台的部署可以參考 [Creating a Kubernetes Cluster](http://kubernetes.io/v1.1/docs/getting-started-guides/README.html)。首先安裝前我們要確認以下四項都已將準備完成：
* 所有節點需安裝```docker```版本 1.2+，以及安裝```bridge-utils```。

> 以下為安裝 bridge-utils 與 docker 方法：
 ```sh
$ sudo apt-get install -y openvswitch-switch bridge-utils
$ curl http://files.imaclouds.com/scripts/docker_install.sh | sh
 ```

* 目前 ubuntu 官方只有測試 14.04，理論 15.x 也可以執行。
* 需要安裝相依套件```etcd```、``` flannel```、```k8s```。
* 所有節點需要可以互相溝通，包含網路與```ssh```。

 > ssh 只需要 master 能夠無密碼進入 minion 與自己就好。

滿足以上後，可以透過```git```下載 kubernetes：
```sh
$ git clone https://github.com/kubernetes/kubernetes.git
```
> 預設安裝下的相依套件```etcd```、``` flannel```、```k8s```會使用較新版本，若要修改可以使用以下指令：
```sh
$ export KUBE_VERSION=1.0.5
$ export FLANNEL_VERSION=0.5.0
$ export ETCD_VERSION=2.2.0
```

一個簡單的節點配置如下：

| IP Address  |   Role   |
|-------------|----------|
|172.16.1.100 |  master  |
|172.16.1.101 |  minion  |
|172.16.1.102 |  minion  |

> 這邊 master 為主要控制節點，minion 為應用程式工作節點。

> P.S 可以配置多個 master 節點，或者 master 與 minion 同節點。

當下載完成後，編輯kubernetes目錄底下的```kubernetes/cluster/ubuntu/config-default.sh```檔案，並修改一下內容：
```sh
export nodes="ubuntu@172.16.1.100 ubuntu@172.16.1.101 ubuntu@172.16.1.102"
export role="a i i"
export NUM_NODES=${NUM_NODES:-2}
export SERVICE_CLUSTER_IP_RANGE=192.168.3.0/24
export FLANNEL_NET=172.16.0.0/16
```
> * ```nodes```定義節點 ssh 的 user 與 ip。
> * ```role```定義節點角色。
> * ```NUM_NODES```定義總共有多少節點。
> * ```SERVICE_CLUSTER_IP_RANGE```定義 kubernetes service ip 範圍。
> * ```FLANNEL_NET```定義 flannel overlay network 的 ip 範圍。

> P.S 注意，在部署時，若需要連接到網際網路下載必要檔案時，如果機器是處於私有網路需要設定代理來連接網路網路的話，可以配置```PROXY_SETTING```於```cluster/ubuntu/config-default.sh```中，如：
```sh
PROXY_SETTING="http_proxy=http://server:port https_proxy=https://server:port"
```

完成上面檔案的設定後，進入```kubernetes/cluster```目錄，並執行以下指令：
```sh
$ KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
```

完成後，進入```cluster/ubuntu/binaries```目錄，然後執行：
```sh
$ sudo ln kubectl /usr/bin
```

之後就可以使用 kubernetes cli 指令，如下：
```sh
$ kubectl get nodes
```

## Nginx 範例
Kubernetes 可以選擇使用指令直接建立應用程式與服務，或者撰寫 YAML 與 JSON 檔案來描述部署應用程式的配置，以下將使用兩種方式建立一個簡單的 Nginx 服務。

### 純指令建立
首先我們要建立 Kubernetes 的 rc（Replication Controller），使用以下指令建立：
```sh
$ kubectl run nginx --image=nginx --replicas=2 --port=80
$ kubectl get pods -o wide

NAME              READY     STATUS    RESTARTS   AGE       NODE
nginx-41nhj       1/1       Running   0          22m       172.16.1.105
nginx-fzlws       1/1       Running   0          22m       172.16.1.104
```
> 若狀態處於```Pending```則表示節點在下載映像檔。

完成後要接著建立 svc（Service）來提供外部網路存取應用程式，使用以下指令建立：
```sh
$ kubectl expose rc nginx --port=80 --type=NodePort
$ kubectl get svc -o wide

NAME         CLUSTER_IP     EXTERNAL_IP   PORT(S)   SELECTOR    AGE
kubernetes   192.168.3.1    <none>        443/TCP   <none>      28m
nginx        192.168.3.26   nodes         80/TCP    run=nginx   26m
```
> ```--type``` 可以依需求改變，目前有```NodePort```、```LoadBalancer```。
> 也可以用```--external-ip```來使用一個外部 IP：
```sh
$ kubectl expose rc nginx --port=80 --container-port=80 --external-ip=172.16.1.250
```

最後因為上述使用```NodePort```，若沒指定 port 會亂數使用一個數值（預設為部署時設定的範圍），由於不知道 port 為多少故需要透過指令查詢：
```sh
$ kubectl get svc nginx -o json 
```

若要刪除```svc```、```rc```與```pods```可以使用以下方式：
```sh
$ kubectl delete {svc/rc/pods} nginx
```

### 使用 YAML 檔案建立
本節將撰寫一個簡單的 nginx rc（Replication Controller）檔案來建立 pods，建立檔案```nginx-rc.yaml```，並加入以下內容：
```sh
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

完成後，就可以透過 k8s 指令來建立：
```sh
$ kubectl create -f nginx-rc.yaml

replicationcontroller "nginx" created
```

建立好 rc 後，就可以接著建立 svc，建立一個檔名為```nginx-svc.yaml```的 YAML檔，並新增以下內容：
```sh
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    nodePort: 80
  selector:
    app: nginx
```
> 這邊使用```NodePort```。

完成後，就可以透過 k8s 指令來建立：
```sh
$ kubectl create -f nginx-svc.yaml

service "nginx-service" created
```

完成後，可以查看一下資訊：
```sh
$ kubectl get svc,pods,rc -o wide
# service
NAME            CLUSTER_IP      EXTERNAL_IP   PORT(S)    SELECTOR        AGE
kubernetes      192.168.3.1     <none>        443/TCP    <none>          1h
nginx-service   192.168.3.140   nodes         80/TCP     app=nginx       1m

# pods
NAME              READY     STATUS    RESTARTS   AGE       NODE
nginx-75ws3       1/1       Running   0          7m        172.16.1.104
nginx-ex5aj       1/1       Running   0          7m        172.16.1.105

# rc
CONTROLLER   CONTAINER(S)   IMAGE(S)               SELECTOR        REPLICAS   AGE
nginx        nginx          nginx                  app=nginx       2          7m
```

若要刪除可以使用以下指令：
```sh
$ kubectl delete -f {*.yaml}
```

## Deploy addons（Options）
假設已經有啟動的叢集，本節將說明如何部署插件到已存在的叢集，如```DNS```及```UI```。

若要配置 DNS，可以修改```kubernetes/cluster/ubuntu/config-default.sh```檔案，加入以下內容：
```sh
ENABLE_CLUSTER_DNS="${KUBE_ENABLE_CLUSTER_DNS:-true}"

DNS_SERVER_IP="192.168.3.10"

DNS_DOMAIN="cluster.local"

DNS_REPLICAS=1
```
> * ```DNS_SERVER_IP```定義了了 DNS Server IP 於```SERVICE_CLUSTER_IP_RANGE``` 範圍內。
> * ```DNS_REPLICAS```描述了有多少的 DNS pod 會執行於叢集上。

至於 kube-ui 在預設下，會在部署插件時安裝，若要關閉可以修改以下參數：
```sh
ENABLE_CLUSTER_UI="${KUBE_ENABLE_CLUSTER_UI:-true}"
```

上面所有變數都被設定後，只需要執行以下指令就會進行部署：
```sh
$ cd kubernetes/cluster/ubuntu
$ KUBERNETES_PROVIDER=ubuntu ./deployAddons.sh
```

當完成後可以使用 k8s 指令來查看：
```sh
 $ kubectl get pods --namespace=kube-system
```

# Kubernetes 網路實現工具
Kubernetes 可以採用以下工具來達到覆蓋網路（overlay network）：
* [OpenVSwitch with GRE/VxLAN](https://github.com/kubernetes/kubernetes/blob/master/docs/admin/ovs-networking.md)
* [Flannel](https://github.com/coreos/flannel#flannel)
* [L2 networks](http://blog.oddbit.com/2014/08/11/four-ways-to-connect-a-docker/) ("With Linux Bridge devices" section)
* [Weave](https://github.com/zettio/weave)
* [Calico](https://github.com/Metaswitch/calico), uses BGP to enable real container IPs.
