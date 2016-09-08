## 建立一個 Swarm

在你安裝完 Docker 1.12.1 後，你可以建立一個 Swarm ，在這之前，請先確定你的 Docker Engine daemon 在你主機上已經執行。

打開你的 terminal 並且透過 ssh 方式連線到你想要建立 manager node 的主機上，透過執行以下指令初始化建置一個 Swarm 叢集：

```
docker swarm init
```

輸入完畢後，你會在你的終端機看到類似如下的結果：

```
Swarm initialized: current node (9nh4v53ixfmbh88c876j5372h) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-5l2g5ao35wsdxmj4podjpk7js6ph4pqspwk8em6y0k8j65vwh6-7etb3vf1vnuzdnhq4twhwgie1 \
    172.16.99.114:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

開啟新的 terminal ，並且 ssh 至你想建置 worker node 的主機，並輸入以下指令，注意：這個指令並非固定，而需依照使用者 manager 節點建置 Swarm 初始化所顯示的資訊進行輸入。

```
$ docker swarm join \
    --token SWMTKN-1-5l2g5ao35wsdxmj4podjpk7js6ph4pqspwk8em6y0k8j65vwh6-7etb3vf1vnuzdnhq4twhwgie1 \
    172.16.99.114:2377

This node joined a swarm as a worker.
```

>依照新節點之角色，可由使用者自行安排，以上是示範建置新 worker node 至 Swarm 叢集中。

Docker 1.12.1 後，將 manager node 加入 Swarm 叢集的方法稍作變更，不同於以往使用 `docker swarm init` 即可查閱建置 manager node 與 worker node 指令。在 Docker 1.12.1 中，你必須透過 `docker swarm join-token manager` 指令才能查閱建置 manager node 所需的指令與 token：

```
$ docker swarm join-token manager
To add a manager to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-5l2g5ao35wsdxmj4podjpk7js6ph4pqspwk8em6y0k8j65vwh6-d7h63uklyq30q909svyedbtek \
    172.16.99.114:2377
```

使用 `docker node ls` 指令，顯示目前 Swarm 叢集的所有節點資訊：

```
$ docker node ls
ID                           HOSTNAME      STATUS  AVAILABILITY  MANAGER STATUS
0heawwbvo0pc6ej2r727gigu2    swarmkit-s    Ready   Active
9nh4v53ixfmbh88c876j5372h *  swarmkit-m    Ready   Active        Leader
euyib5foohdhk3x8ue728b23t    swarmkit-m-2  Ready   Active        Reachable
```

> `AVAILABILITY` 行顯示調度器是否可以將任務分派到該節點：

> * `Active` 表示該節點允許接受調度器分派任務。

> * `Pause` 表示該節點不允許接受調度器分派新任務，但是現有任務仍處於執行狀態。

> * `Drain` 表示該節點不允許接受調度器分派新任務，且關閉現有的任務，將其調度至可使用節點上。

> `MANAGER STATUS` 

> * 沒有值表示是一個 worker 節點，無法參與管理 Swarm。

> * `Leader` 表示是一個主要的 manager 節點，管理所有 Swarm 叢集與決定 Swarm 程序編排。

> * `Reachable` 表示是一個參與 Raft consensus 的 manager 節點。如果 Leader 節點變成 Unavailable ，則該節點有資格成為新的 Leader node。

> * `Unavailable` 表示是一個 manager 節點，但是無法與其他 manager 節點溝通。如果一個 manager 節點變成 Unavailable ，你需在 Swarm 叢集中加入一個新的 manager 節點或將一個 worker 節點晉升成 manager 節點。

使用 `docker info` 指令，顯示目前 Swarm 叢集的狀態：

```
$ docker info

Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
  ...snip...
Swarm: active
 NodeID: 9nh4v53ixfmbh88c876j5372h
 Is Manager: true
 ClusterID: 2cnhbdwqcfe5zfdwa9h3su68g
 Managers: 2
 Nodes: 3
  ...snip...
```

執行 `docker node ls` 顯示關於節點上的資訊：

```
$ docker node ls

ID                           HOSTNAME      STATUS  AVAILABILITY  MANAGER STATUS
0heawwbvo0pc6ej2r727gigu2    swarmkit-s    Ready   Active
9nh4v53ixfmbh88c876j5372h *  swarmkit-m    Ready   Active        Leader
euyib5foohdhk3x8ue728b23t    swarmkit-m-2  Ready   Active        Reachable
```
