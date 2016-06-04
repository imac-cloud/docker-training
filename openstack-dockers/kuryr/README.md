# OpenStack Kuryr 基本教學
本篇說明如何透過 CentOS 來部署簡單的 Kuryr 與 Docker 串接。

## 節點配置
OpenStack Kuryr 我們使用到三抬節點，以下為本次安裝的規格：

| Role      |RAM   |Disk  | CPUs  | IP Address |
|-----------|------|------|-------|------------|
| controller| 4 GB | 50GB | 2vCPU |172.16.1.115|
| network-1 | 4 GB | 50GB | 2vCPU |172.16.1.118|
| network-2 | 4 GB | 50 GB| 2vCPU |172.16.1.119|


請以上節點都分別安裝 RHEL 或者 CentOS 作業系統。並且設定 IP 為靜態固定，編輯```/etc/sysconfig/network-scripts/ifcfg-<name>```檔案，加入以下內容：
```sh
ONBOOT="yes"
IPADDR="10.0.0.104"
PREFIX="24"
GATEWAY="10.0.0.1"
DNS1="8.8.8.8"
DNS2="8.8.8.4"
```
> <font color=red>P.S.</font> 若是虛擬機則不需要設定。

## 安裝前準備
在開始安裝以前，首先需要在每一台節點將基本環境的軟體更新：
```sh
$ sudo yum update -y
```
> 完成後檢查是否是最新版本，可以透過以下方式查看 Kernel：
```sh
$ uname -r
3.10.0-327.13.1.el7.x86_64
```

> 如果不是以上版本，請執行以下指令：
```sh
$ sudo yum upgrade --assumeyes --tolerant
$ sudo yum update --assumeyes
```

由於在 CentOS 與 RHEL 預設會開啟防火牆，故要關閉防火牆與開機時自動啟動：
```sh
$ sudo systemctl stop firewalld && sudo systemctl disable firewalld
```

設定關閉 SELinux 與設定一些資訊，並重新啟動：
```sh
$ sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config &&
sudo groupadd nogroup &&
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 &&
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 &&
sudo reboot
```

完成重新啟動後，在所有```Network```節點安裝 Docker，首先要取得 repos，設定以下來讓 yum 可以抓取：
```sh
$ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

在```Network```節點安裝 Docker engine，並啟動 docker 與設定開機啟動：
```sh
$ sudo yum install --assumeyes --tolerant docker-engine
$ sudo systemctl start docker
$ sudo systemctl enable docker
```

在```所有```節點安裝一些基本工具軟體：
```sh
$ sudo yum install -y tar xz unzip curl ipset vim wget git python-pip
$ sudo pip install --upgrade pip
```

在```Controller```節點，進入 <font color=red>root</font> 使用者，並建置 ssh keys：
```sh
$ ssh-keygen -t rsa
$ cat .ssh/id_rsa.pub >> .ssh/authorized_keys
```

複製```Controller```節點的```.ssh/id_rsa.pub```內容，並貼到```Network```節點的 <font color=red>root</font> 使用者的```.ssh/authorized_keys```。並驗證 ssh 是否可以無密碼登入：
```sh
$ ssh 172.16.1.118
```

### 安裝 OpenStack
這邊使用 RDO 進行安裝。由於只需要 Neutron 與 Keystone 服務，所以可以修改部署的```answer-file```設定檔。由於這邊使用的事虛擬機，因此 Neutron 網路採用 VXLAN 方式進行安裝。進入到```Controller```節點，並且進入到 <font color=red>root</font> 使用者安裝 PackStack：
```sh
$ yum install -y centos-release-openstack-mitaka.noarch
$ yum install -y openstack-packstack
$ wget https://gist.githubusercontent.com/kairen/637c707b960e188d32aba9044e652c0b/raw/6724a5177ca82ced555554635c6b0893e8c398ab/answer-file
```
> 這邊可以更改安裝版本，如更改成 Liberty 的穩定版```centos-release-openstack-liberty.noarch```

編輯```answer-file```設定檔，修改以下內容：
```
CONFIG_CONTROLLER_HOST=172.16.1.115
CONFIG_COMPUTE_HOSTS=172.16.1.118,172.16.1.119
CONFIG_NETWORK_HOSTS=172.16.1.115,172.16.1.118,172.16.1.119
CONFIG_STORAGE_HOST=172.16.1.115
CONFIG_AMQP_HOST=172.16.1.115
CONFIG_MARIADB_HOST=172.16.1.115
CONFIG_KEYSTONE_LDAP_URL=ldap://172.16.1.115
```

設定檔都確認無誤後，透過以下指令進行安裝：
```sh
$ packstack --answer-file=answer-file
...
**** Installation completed successfully ******
* To access the OpenStack Dashboard browse to http://172.16.1.115/dashboard .
```
> 中途若發生安裝套件失敗問題，請直接重新執行一次。

當成功安裝完成後，透過簡單的 OpenStack 指令來確認：
```sh
$ . keystonerc_admin
$ openstack user list
+----------------------------------+---------+
| ID                               | Name    |
+----------------------------------+---------+
| 70b80593320543bbb32e15d7f06036f0 | admin   |
| 9600aaa2447940e789e548b2f5515690 | neutron |
+----------------------------------+---------+
```

### 安裝 Kuryr
進入```Network```節點，並且進入到 <font color=red>root</font> 使用者，下載 Kuryr 最新的專案：
```sh
$ git clone https://github.com/openstack/kuryr.git
$ pip install -r requirements.txt
$ python setup.py install
```

建立 Kuryr 設定檔與 Log 目錄：
```sh
$ mkdir -p /var/log/kuryr /etc/kuryr
$ wget https://gist.githubusercontent.com/kairen/637c707b960e188d32aba9044e652c0b/raw/6724a5177ca82ced555554635c6b0893e8c398ab/kuryr.conf -O /etc/kuryr/kuryr.conf
```

編輯```/etc/kuryr/kuryr.conf```設定檔，修改一下內容：
```
[keystone_client]
auth_uri = http://172.16.1.115:35357/v2.0

[neutron_client]
neutron_uri = http://172.16.1.115:9696
```

接著啟動 Kuryr 服務：
```sh
$ ./scripts/run_kuryr.sh &
2016-06-02 03:51:33.578 4758 INFO werkzeug [-]  * Running on http://0.0.0.0:2377/ (Press CTRL+C to quit)
```

### 服務驗證
當所有```Network```節點都完成 Kuryr 安裝後，就可以透過以下方式來驗證，首先在```network-1```建立網路：
```sh
$ docker network create --driver=kuryr \
--ipam-driver=kuryr \
--subnet 10.0.0.0/16 \
--gateway 10.0.0.1 \
--ip-range 10.0.0.0/24 kuryr

...
821d6cd53af6c656969c1c96063a60c695a0313c9a119e44d4325ce2a9f2f935
```

透過 docker 指令來查看網路：
```sh
$ docker network inspect kuryr
[
    {
        "Name": "kuryr",
        "Id": "821d6cd53af6c656969c1c96063a60c695a0313c9a119e44d4325ce2a9f2f935",
        "Scope": "local",
        "Driver": "kuryr",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "kuryr",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.0.0.0/16",
                    "IPRange": "10.0.0.0/24",
                    "Gateway": "10.0.0.1"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "367763a677ad180c57818631ee3e9151683d0218a15bb002d0995ab5c6e30446": {
                "Name": "awesome_dijkstra",
                "EndpointID": "326aba6247266cfd0ca3771b0283e2142a3e934bb994d1b77fc93bb467c0df48",
                "MacAddress": "fa:16:3e:7c:d8:b6",
                "IPv4Address": "10.0.0.5/24",
                "IPv6Address": ""
            },
            "b740abd7976d274de233df0bad052c418516ba036132b92ad022a4b52a2d7d25": {
                "Name": "awesome_engelbart",
                "EndpointID": "fcc642dae6323ce7d86ddda61c9583a19801eae70d8126d35b4b5846cd8598a4",
                "MacAddress": "fa:16:3e:5b:6e:7f",
                "IPv4Address": "10.0.0.3/24",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

接著建立一個 container 來取得 IP：
```sh
$ docker run -it -d --net kuryr --privileged=true ubuntu:14.04
$ docker exec -ti $(docker ps -lq) bash
root@367763a677ad$ ip -4 a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
14: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.3/24 scope global eth0
       valid_lft forever preferred_lft forever
```

接著進入到```network-2```節點，透過 docker 指令建立網路，這邊採用跟上一個同樣的網路：
```sh
$ docker network create --driver=kuryr \
--ipam-driver=kuryr \
--subnet 10.0.0.0/16 \
--gateway 10.0.0.1 \
--ip-range 10.0.0.0/24 \
-o neutron.net.uuid=8c069d2c-772c-47ae-90bb-d22148f37dc8 kuryr
```
> 這邊```neutron.net.uuid```可以透過以下在```Controller```方式取得：
```sh
$ neutron net-list | awk '/kuryr/ {print $2}'
8c069d2c-772c-47ae-90bb-d22148f37dc8
```

接著一樣建立一個 container 來取得 IP：
```sh
$ docker run -it -d --net kuryr --privileged=true ubuntu:14.04
$ docker exec -ti $(docker ps -lq) bash
root@f2b48a802e92$ ip -4 a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
15: eth0@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.4/24 scope global eth0
       valid_lft forever preferred_lft forever
```

透過 ping 來驗證網路是否有連接：
```sh
root@f2b48a802e92$ ping -c 3 10.0.0.3
PING 10.0.0.3 (10.0.0.3) 56(84) bytes of data.
64 bytes from 10.0.0.3: icmp_seq=1 ttl=64 time=1.71 ms
64 bytes from 10.0.0.3: icmp_seq=2 ttl=64 time=1.37 ms
64 bytes from 10.0.0.3: icmp_seq=3 ttl=64 time=1.23 ms
```
