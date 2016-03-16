# OpenStack Docker Machine
Docker machine 可以使用```Generic Driver```與```OpenStack Driver```來連接與建立 Docker 環境。

### Using the Generic Driver
以下範例使用 Generic Driver 來連接一個已存在的 OpenStack instance：
```sh
$ docker-machine create --driver generic \
--generic-ssh-user ubuntu \
--generic-ssh-key ~/.ssh/id_rsa \
--generic-ip-address 10.26.1.82 \
docker-engine-1
```
> * ```--generic-ssh-user```為要遠端的使用者。
> * ```--generic-ssh-key```為要使用的 SSH Key。
> * ```--generic-ip-address```為要使用的虛擬機 IP。

### Using the OpenStack Driver
Docker Machine 提供了使用者可以建立 Docker 容器於 OpenStack 虛擬機。以下範例是使用 OpenStack Driver 來連接 OpenStack 並建立虛擬機：
```sh
$ docker-machine create --driver openstack \
--openstack-username "<KEYSTONE_USERNAME>" \
--openstack-password "<KEYSTONE_PASSWD>" \
--openstack-tenant-name "<KEYSTONE_PROJECT_NAME>" \
--openstack-auth-url "<KEYSTONE_URL>" \
--openstack-flavor-name "m1.medium" \
--openstack-image-name "Ubuntu-14.04-Server-Cloud" \
--openstack-net-name "admin-net" \
--openstack-floatingip-pool "internal-net" \
--openstack-ip-version 4 \
--openstack-ssh-user "ubuntu" \
--openstack-sec-groups "ALL_PASS" \
openstack-docker
```
> * ```--openstack-username```為 Keystone 使用者帳號。
> * ```--openstack-password```為 Keystone 使用者密碼。
> * ```--openstack-tenant-name```為要使用的 project 名稱。
> * ```--openstack-auth-url```為 Keystone URL。
> * ```--openstack-flavor-name```為要使用的 Flavor。
> * ```--openstack-image-name```為要使用的 Image 名稱。
> * ```--openstack-net-name```為要使用的私有網路名稱。
> * ```--openstack-floatingip-pool```為要使用的 Floating 網路名稱。
> * ```--openstack-ip-versionl```為要使用的網路版本。
> * ```--openstack-ssh-user```為要遠端的使用者名稱。
> * ```--openstack-sec-groups```為要使用的 Security Grous 名稱，可多個如以下```ALL_PASS, SSH```。

# 參考資源
* [Docker OpenStack Driver](https://docs.docker.com/machine/drivers/openstack/)
* [ Docker Machine’s generic driver](https://docs.docker.com/machine/drivers/generic/)
* [Using Docker Machine with OpenStack](http://superuser.openstack.org/articles/using-docker-machine-with-openstack)
