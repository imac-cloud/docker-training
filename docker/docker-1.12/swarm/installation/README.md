## 建立一個 Swarm

在你安裝完 Docker 1.12 後，你可以建立一個 Swarm ，在這之前，請先確定你的 Docker Engine daemon 在你主機上已經執行。

打開你的 terminal 並且透過 ssh 方式連線到你想要建立 manager node 的主機上，透過執行以下指令建置一個 Swarm：

```
docker swarm init
```

輸入完畢後，你會在你的終端機看到類似如下的結果：

```
Swarm initialized: current node (d6dnup03hkbebwdro6tdsiv6w) is now a manager.

To add a worker to this swarm, run the following command:
    docker swarm join \
    --token SWMTKN-1-33mn2rmjriaoth0f50w9x0pq2q4pof5r7zw4xn08zkgf3oi1p0-2n93jchoe6lztsps5xy5nkk0e \
    172.16.99.70:2377

To add a manager to this swarm, run the following command:
    docker swarm join \
    --token SWMTKN-1-33mn2rmjriaoth0f50w9x0pq2q4pof5r7zw4xn08zkgf3oi1p0-7vxgx66bu2n5ojn2tvy38t48k \
    172.16.99.70:2377
```

開啟新的 terminal ，並且 ssh 至你想建置 worker node 的主機，並輸入以下指令，注意：這個指令並非固定，而需依照使用者 manager 節點建置 Swarm 初始化所顯示的資訊進行輸入。

```
$ docker swarm join --token \ SWMTKN-1-33mn2rmjriaoth0f50w9x0pq2q4pof5r7zw4xn08zkgf3oi1p0-2n93jchoe6lztsps5xy5nkk0e \
10.26.1.175:2377

This node joined a swarm as a worker.
```

>依照新節點之角色，可由使用者自行安排，以上是示範建置新 worker node 至 Swarm 叢集中。

使用 `docker info` 指令，顯示目前 Swarm 的狀態：

```
$ docker info

Containers: 0
Running: 0
Paused: 0
Stopped: 2
  ...snip...
Swarm: active
  NodeID: d6dnup03hkbebwdro6tdsiv6w
  Is Manager: true
  Managers: 1
  Nodes: 1
  ...snip...
```

執行 `docker node ls` 顯示關於節點上的資訊：

```
$ docker node ls

ID                           HOSTNAME       STATUS  AVAILABILITY  MANAGER STATUS
d6dnup03hkbebwdro6tdsiv6w *  docker-master  Ready   Active        Leader
e0fnowyzdke7bdms520hd52x2    docker-worker  Ready   Active
```
