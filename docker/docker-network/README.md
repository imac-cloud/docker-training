# Docker Network

本節針對幾項 Docker network mode 進行實作與介紹：

* [Bridge Mode (default)](#BridgeMode)
* [Host Mode](#HostMode)
* [None Mode](#NoneMode)
* [Container Mode](#ContainerMode)

### <a name="BridgeMode">Bridge Mode</a>

Bridge Mode 是 Docker 預設使用的 network mode 。若你在已安裝 Docker 的環境中使用 `ifconfig` 指令，你可以看到有一個名為 docker0 的 network interface：

![bridge-mode-interface](./images/bridge-mode-host-interface.png "bridge-mode-interface")

此時，你可以在這個 Docker 環境中執行一個 docker container ：

```
$ docker run -ti busybox sh
```

一樣使用 `ifconfig` 指令，你也會看到一個 eth0 network interface：

![bridge-mode-interface](./images/bridge-mode-container-interface.png "bridge-mode-interface")

這就是為什麼在 host 上可以直接使用 `ping` 指令與 container 進行通訊，因為 veth796c087 讓 docker0(172.17.0.1) 與 eth0(172.17.0.2) 位於同一個區網。

![bridge-mode-bridge](./images/bridge-mode-bridge.png "bridge-mode-bridge")

我們用一張簡單的圖來表示這三者的關係：

![bridge-mode](./images/bridge-mode.png "bridge-mode")

由上圖你可以發現，Container 1 可透過 eth0 經過 veth4fd8759 與 docker0 進行溝通，Container 2 也是如此，且 Container 1 與 Container 2 也可以進行溝通。

### <a name="HostMode">Host Mode</a>

Host Mode 可以把他想像成建立一個與 Host 擁有同樣的 network interface 的 Container ，使用方式：

```
$ docker run --net=host -ti busybox sh
``` 

### <a name="NoneMode">None Mode</a>

None Mode 是建置最簡潔的 Container ，也就是沒有任何 network interface 的 Container。使用方式是在建立 Container 的同時給與 `--net=none` 的參數：

```
$ docker run --net=none -ti busybox sh
``` 

此時，你若使用 `ifconfig` 指令，會發現這個 Container 沒有任何 network interface。

![none-mode](./images/none-mode.png "none-mode")

### <a name="ContainerMode">Container Mode</a>

首先，我們要先啟動一個 Container，並且使用這個 Container 的 Container ID 建立另外一個 Container：

![container-list](./images/container-list.png "container-lis
t")

建置第二個 Container 的方式，將第一個 Container ID 當參數進行建置：

```
docker run -ti --net=container:d16d87a29be3 busybox sh
```

此時，你會發現兩個 Container 的 IP 都是 172.17.0.2 ，雖然他們是不同的 Container 但是被放置同一個 Namespace 內，三者的關係如下：

![container-mode](./images/container-mode.png "none-mode")