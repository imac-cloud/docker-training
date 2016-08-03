## Docker 1.10

### 安裝

首先，加入新的 `gpg` 金鑰：

```
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
```

接著，使用編輯軟體，例如 `vim`，開啟 `/etc/apt/sources.list.d/docker.list` 並加入以下指令後儲存：

```
# Ubuntu Precise
deb https://apt.dockerproject.org/repo ubuntu-precise main# Ubuntu Trusty
deb https://apt.dockerproject.org/repo ubuntu-trusty main# Ubuntu Vivid
deb https://apt.dockerproject.org/repo ubuntu-vivid main# Ubuntu Wily
deb https://apt.dockerproject.org/repo ubuntu-wily main
```

更新 apt package ：

```
sudo apt-get update
```

最後，使用以下指令安裝即可：

```
apt-get install -y docker-engine=1.10.1-0~trusty
```

###驗證

使用 `docker version` 指令進行驗證，確認安裝無誤：

```
Client:
 Version:      1.10.1
 API version:  1.22
 Go version:   go1.5.3
 Git commit:   9e83765
 Built:        Thu Feb 11 19:27:08 2016
 OS/Arch:      linux/amd64

Server:
 Version:      1.10.1
 API version:  1.22
 Go version:   go1.5.3
 Git commit:   9e83765
 Built:        Thu Feb 11 19:27:08 2016
 OS/Arch:      linux/amd64
```

> 注意，若 `docker version` 指令無法操作，請將該使用者加入 docker group 