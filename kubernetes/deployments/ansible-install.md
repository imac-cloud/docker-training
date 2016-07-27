# Deploying Kubernetes via Ansible
本節將透過 Ansible 來部署一個 [Kubernetes](https://github.com/kubernetes/contrib/tree/master/ansible) 叢集，其中包含設定 Monitor、Dashboard 與 DNS等。

## 節點配置
本安裝將使用三台虛擬機器作為部署主機，虛擬機器採用 OpenStack，其規格為以下：

|Role       |RAM   |CPUs |Disk |IP Address |
|-----------|------|-----|-----|-----------|
|k8s-master | 4 GB |2vCPU|40 GB|172.16.1.59|
|k8s-minion1| 4 GB |2vCPU|40 GB|172.16.1.60|
|k8s-minion2| 4 GB |2vCPU|40 GB|172.16.1.61|

其中作業系統採用 ```CentOS 7```。

## 事前準備
首先在所有節點設定好```/etc/hosts```，請加入以下內容：
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.16.1.59 k8s-master
172.16.1.60 k8s-minion-1
172.16.1.61 k8s-minion-2
```

並在```k8s-master```節點設定 SSH 到其他節點不需要密碼，請依照以下執行：
```sh
$ ssh-keygen -t rsa
$ ssh-copy-id k8s-minion1
...
```

回到```k8s-master```節點，安裝一些需要的套件：
```sh
$ sudo yum install -y epel-release
$ sudo yum install -y ansible python-netaddr git
```

完成安裝後，編輯```/etc/ansible/hosts```檔案(inventory)，並加入以下內容：
```
[masters]
k8s-master

[etcd:children]
masters

[nodes]
k8s-minion[1:2]
```

接著透過以下指令確認節點是否可以溝通：
```sh
$ ansible all -m ping
k8s-minion-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
k8s-master | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
k8s-minion-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## 部署 Ansible Kubernetes 叢集
首先透過 Git 下載 Kubernetes 專案，透過以下指令：
```sh
$ git clone https://github.com/kubernetes/contrib.git
$ cd contrib/ansible
```

然後編輯```group_vars/all.yml```檔案，修改一下內容：
```yaml
cluster_name: imac-cluster
cluster_logging: false
cluster_monitoring: false
kube-ui: true
kube-dash: true
dns_setup: false
```
> 這邊指開啟 UI 與 Dashboard。其餘可自行選擇。

完成後執行以下指令來進行部署：
```sh
$ INVENTORY=/etc/ansible/hosts ./setup.sh
PLAY [all] *********************************************************************

TASK [pre-ansible : Get os_version from /etc/os-release] ***********************
ok: [k8s-minion-2]
ok: [k8s-master]
ok: [k8s-minion-1]
```

經過一段時間後就會完成部署，一旦完成部署就可以透過以下指令查看資訊：
```sh
$ kubectl get nodes
NAME           STATUS    AGE
k8s-minion-1   Ready     3h
k8s-minion-2   Ready     3h
```

查看系統服務建置狀況：
```sh
$ kubectl get svc --all-namespaces
NAMESPACE     NAME                    CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
default       kubernetes              10.254.0.1       <none>        443/TCP             3h
kube-system   elasticsearch-logging   10.254.164.5     <none>        9200/TCP            3h
kube-system   heapster                10.254.213.162   <none>        80/TCP              3h
kube-system   kibana-logging          10.254.176.124   <none>        5601/TCP            3h
kube-system   kube-dns                10.254.0.10      <none>        53/UDP,53/TCP       3h
kube-system   kubedash                10.254.68.80                   80/TCP              3h
kube-system   kubernetes-dashboard    10.254.84.138    <none>        80/TCP              3h
kube-system   monitoring-grafana      10.254.193.233   <none>        80/TCP              3h
kube-system   monitoring-influxdb     10.254.135.115   <none>        8083/TCP,8086/TCP   3h
```
> 若想查看 kubernetes UI 可以透過瀏覽器進入 [Kube UI](http://k8s-master:8080/ui)。

若想指定執行安裝節點套件可以透過以下方式。

如只需要安裝 etcd：
```sh
$ ./setup.sh --tags=etcd
```

而 kube-master 則利用以下方式：
```sh
$ ./setup.sh --tags=masters
```

kube-minion 的指令如以下：
```sh
$ ./setup.sh --tags=nodes
```
