# Deploying Kubernetes Using Vagrant and CoreOS
本節將透過 Vagrant 與 CoreOS 來部署多節點的 Kubernetes 叢集，並使用 Kubernetest CLI 工具與 API 進行溝通。

## 事前準備
首先必須在主機上安裝 ```Vagrant``` 工具，
點選該 [Vagrant downloads](https://www.vagrantup.com/downloads.html) 頁面抓取當前系統的版本，並完成安裝。

接著在主機上安裝 ```kubectl```，該程式是主要與 Kubernetes API 進行溝通的工具，透過 Curl 工具來下載。如果是 Linux 作業系統，請下載以下：
```sh
$ curl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.3/bin/linux/amd64/kubectl
```
> 如果是 OS X，請取代 URL 為以下：
```sh
$ curl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.3/bin/darwin/amd64/kubectl
```

下載完成後確保可以直接執行，要修改權限，並移到```/usr/local/bin/```下：
```sh
$ chmod +x kubectl
$ mv kubectl /usr/local/bin/kubectl
```

## 安裝 Kubernetes
首先透過 Git 工具來下載 CoreOS 的 Kubernetes 專案，裡面包含了描述 Vagrant 要建立的檔案：
```sh
$ git clone https://github.com/coreos/coreos-kubernetes.git
$ cd coreos-kubernetes/multi-node/vagrant
```

接著複製```config.rb.sample```並改成```config.rb```檔案：
```sh
$ cp config.rb.sample config.rb
```

編輯```config.rb```並修改成一下內容：
```ruby
$update_channel="beta"

$controller_count=1
$controller_vm_memory=512

$worker_count=2
$worker_vm_memory=1024

$etcd_count=1
$etcd_vm_memory=512
```
> 預設下 Calico 網路策略是不啟動的，要啟動必須修改```../generic/controller-install.sh```與```../generic/worker-install.sh```中的```export USE_CALICO=true```。

> 這邊也要確保 Kubernetes 的版本是否正確，如```export K8S_VER=v1.2.3_coreos.cni.1```。

透過以下指令確保 Vagrant 是使用最新版本的 CoreOS 映像檔：
```sh
$ vagrant box update
```

然後透過執行以下指令來部署最基本的叢集：
```sh
$ vagrant up
```
> P.S. 這邊建置起來裡面虛擬機還要下載一些東西，要等一下子才會真正完成。

## 配置 kubectl
當完成部署後，需要配置 kubectl 連接 API，這邊可以選擇以下兩種的其中一種進行：
* 使用一個客制的 KUBECONFIG 路徑：
```sh
$ export KUBECONFIG="${KUBECONFIG}:$(pwd)/kubeconfig"
$ kubectl config use-context vagrant-multi
```

* 更新本地使用者的 kubeconfig：
```sh
$ kubectl config set-cluster vagrant-multi-cluster \
--server=https://172.17.4.101:443 \
--certificate-authority=${PWD}/ssl/ca.pem

$ kubectl config set-credentials vagrant-multi-admin \
--certificate-authority=${PWD}/ssl/ca.pem \
--client-key=${PWD}/ssl/admin-key.pem \
--client-certificate=${PWD}/ssl/admin.pem

$ kubectl config set-context vagrant-multi \
--cluster=vagrant-multi-cluster \
--user=vagrant-multi-admin

$ kubectl config use-context vagrant-multi
```

最後檢查 kubectl client 是否正確的被配置，透過查詢節點指令來確認：
```sh
$ kubectl get nodes
NAME           STATUS                     AGE
172.17.4.101   Ready,SchedulingDisabled   3m
172.17.4.201   Ready                      3m
172.17.4.202   Ready                      3m
```
> 若有問題可以進入 vagrant 的節點查看，如以下方式：
```sh
$ vagrant ssh w1
core@w1 ~ $ journalctl -u kubelet
```

> 發生```The connection to the server 172.17.4.101:443 was refused - did you specify the right host or port?```的話，請執行以下方式：
```sh
$ vagrant suspend
$ vagrant up
Bringing machine 'e1' up with 'virtualbox' provider...
Bringing machine 'c1' up with 'virtualbox' provider...
Bringing machine 'w1' up with 'virtualbox' provider...
==> e1: Checking if box 'coreos-beta' is up to date...
==> e1: Resuming suspended VM...
...
```
