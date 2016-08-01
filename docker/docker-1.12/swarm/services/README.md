## 應用服務

* 建立一個服務
* 服務更新
* 移除服務

### 建立一個服務

當你完成環境建置後，你可以嘗試在 Swarm 環境上佈署一個應用服務。

首先，開啟 terminal 並且 ssh 至你安裝 manager node 的主機，執行以下命令：

```
$ docker service create --name vote -p 8080:80 --replicas=5 instavote/vote

d2knc5grdqntqsbrl6b6g43ca
```

> --name 表示為服務命名 <br>
> --replicas 表示指定期望副本數

建立完服務後，使用 `docker service ps <service name>` 指令查看目前執行的服務列表：

```
$ docker service ps vote

ID                         NAME    IMAGE           NODE           DESIRED STATE  CURRENT STATE           ERROR
6wzdu5098xlfslw63j284j136  vote.1  instavote/vote  docker-master  Running        Running 14 minutes ago
5k06pk4az7hvxln690e6o2a1n  vote.2  instavote/vote  docker-worker  Running        Running 14 minutes ago
em5bz5nx8wtln0v8ob86qra33  vote.3  instavote/vote  docker-worker  Running        Running 14 minutes ago
cnzvzc4a0vu7tx9wkgwc85en2  vote.4  instavote/vote  docker-master  Running        Running 14 minutes ago
9s2vapo5pqrl3buaai7ew5u28  vote.5  instavote/vote  docker-master  Running        Running 14 minutes ago
```

> 由上方的 NODE 可以了解服務是執行在哪個節點上。

若你希望看到更詳細的服務資訊，可使用 `docker service inspect --pretty <service name>` 指令查看：

```
$ docker service inspect --pretty vote

ID:		d2knc5grdqntqsbrl6b6g43ca
Name:		vote
Mode:		Replicated
 Replicas:	5
Placement:
UpdateConfig:
 Parallelism:	1
 On failure:	pause
ContainerSpec:
 Image:		instavote/vote
Resources:
Ports:
 Protocol = tcp
 TargetPort = 80
 PublishedPort = 8080
```

###服務更新

假設你想更新你的 Image ，可以透過 `docker service update <service name> 進行更新：

```
$ docker service update --replicas=5 --update-delay 10s --update-parallelism 2 --image instavote/vote:movies vote

vote
```

> --update-delay 10s 表示每個更新間隔時間 <br>
> --update-parallelism 表示一次更新幾個副本

查看結果：

```
$ docker service ps vote

ID                         NAME        IMAGE                  NODE           DESIRED STATE  CURRENT STATE            ERROR
0umce0zaobqt2kcyxque15q6c  vote.1      instavote/vote:movies  docker-worker  Running        Running 12 minutes ago
6wzdu5098xlfslw63j284j136   \_ vote.1  instavote/vote         docker-master  Shutdown       Shutdown 12 minutes ago
d37hjyn4adu0ara2gl1wczu8l  vote.2      instavote/vote:movies  docker-worker  Running        Running 12 minutes ago
5k06pk4az7hvxln690e6o2a1n   \_ vote.2  instavote/vote         docker-worker  Shutdown       Shutdown 12 minutes ago
6whlhkcxbuu8kj9w6vdedpstb  vote.3      instavote/vote:movies  docker-master  Running        Running 11 minutes ago
em5bz5nx8wtln0v8ob86qra33   \_ vote.3  instavote/vote         docker-worker  Shutdown       Shutdown 11 minutes ago
dvo0ic6j8jehvaeqr64f89u11  vote.4      instavote/vote:movies  docker-master  Running        Running 12 minutes ago
cnzvzc4a0vu7tx9wkgwc85en2   \_ vote.4  instavote/vote         docker-master  Shutdown       Shutdown 12 minutes ago
5qg3kxilnx5sd3ezekh8nlzbu  vote.5      instavote/vote:movies  docker-master  Running        Running 12 minutes ago
9s2vapo5pqrl3buaai7ew5u28   \_ vote.5  instavote/vote         docker-master  Shutdown       Shutdown 12 minutes ago
```

###移除服務

若你想移除服務，可以透過 `docker service rm <service name>` 進行服務的移除：

```
$ docker service rm d2knc5grdqnt
```


