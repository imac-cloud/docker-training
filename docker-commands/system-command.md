### daemon 服務指令
如果不是檔案庫安裝docker服務，我們就需要使用到該指令，否則可以省略。手動啟動 docker 服務時，可以加入容器的 DNS設定、儲存驅動與執行驅動的參數，如下：
```sh
$ export DOCKER_HOST="tcp://0.0.0.0:2375"
$ Docker -d -D -e lxc -s btrfs --dns 8.8.8.8 --dns-search example.com
```
> 只有手動啟動需要上述指令，如果是自動只需要執行```sudo service docker start``` 即可，OS X 與 Windows 可以安裝 [Docker Toolbox](https://www.docker.com/docker-toolbox)。

| 選項 | 說明 |
|------------|------|
| -d | 以服務方式執行 Docker |
| -D | Debug 模式執行 Docker |
| -e [option] | 指定執行驅動，預設為 ```libcontainer``` |
| -s [option] | 強制 Docker 使用指定儲存驅動，預設為 ```AUFS``` |
| --dns [option] | 設定所有容器使用的 DNS 伺服器 |
| --dns-search [option] | 設定所有容器蒐尋的網域 |
| -H [option] | 關連的socket，可以是一個或多個以下格式 ```tcp://host:port```, ```unix:///path/to/socket```, ```fd://*``` 或者 ```df://socketfd``` |

### version 版本指令
使用 version 或者『-v』顯示版本，如下：
```sh
$ docker -v
Docker version 1.9.0, build 76d6bc9

$ docker version
Client:
 Version:      1.9.0
 API version:  1.21
 ...
```
### info 資訊指令
想列出 docker 服務設定值，如執行驅動、儲存驅動等，可以使用info：
```sh
$ docker info
Containers: 0
Images: 22
Server Version: 1.9.0
Storage Driver: aufs
...
```
### run 執行指令
若要執行一個 Container，可以用 run 來執行：
```sh
$ docker run [options] IMAGE [command] [args]
```
範例如：
```sh
$ docker run -d -p 8080:80 -p 10022:22 --name apache2 kairen/apache2:1.0.0 /bin/sh -c "/etc/boot_run.sh -d"
```

| 選項 | 說明 |
|------------|------|
| -a, --attach=[] | 附加 stdin、stdout 或 stderr 檔案 |
| -d, --detach | 使容器執行於背景 |
| -i, --interactive | 開啟互動模式（保持 stdin 檔案在開啟狀態） |
| -t, --tty | 配置一個虛擬終端機 |
| -p, --publish=[] | 對主機開放一個容器內的通訊埠，格式為```hostport:containerport``` |
| --rm | 在容器結束時，自動刪除容器檔案（無法與 -d 共用） |
| --privileged | 給予容器額外特殊權限 |
| -v, --volume=[] | 給予特定容器掛載 volume |
| -w, --workdir="" | 設定容器中工作目錄 |
| --name="" | 設定容器名稱 |
| -h, -hostname="" | 設定容器主機名稱 |
| -u, --user="" | 設定容器執行時的使用者帳號 |
| -e, --env=[] | 設定環境變數 |
| --env-file=[] | 從一個檔案中讀取環境變數 |
| --dns=[] | 設定自訂的 DNS 伺服器 |
| --dns-search=[] | 設定自訂的搜尋網域 |
| --link=[] | 建立與其他容器連結（輸入容器名稱） |
| -c, --cpu-shares=0 | 設定 CPU 的相對共用值 |
| --cpuset="" | 執行時能使用的 CPU 個數，最小為 0 |
| -m, --memory="" | 設定記憶體限制（{number}{b\k\m\g}） |
| --restart="" | 設定當容器掛點時，重新啟動方式。```no```：掛了不重啟。```on-failure```：回傳了非 0 的結束碼自動重啟。```always```：無論回傳結果如何，都會重啟。 |
| --cap-add="" | 取得容器權限能力 |
| --cap-drop="" | 禁止容器使用權限能力 |
| --device="" | 在容器中掛載設備 |

### exec 執行內部程式
我們可以用 exec 來執行容器內的程式，或者配置虛擬終端機來與容器作互動：
```sh
$ docker exec -t -i <CONTAINER>
```
> ```-t```為配置虛擬終端機，```-i```為互動模式。

### search 查詢網路資源庫 images
我們可以用 search 指令來搜尋公開的資源庫中的 docker 映像檔，例如以下：
```sh
$ docker search python | less
NAME                        DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
python                      Python is an interpreted, interactive, obj...   449       [OK]
```

### pull 取下指令
若要抓取想要的映像檔，可以使用 pull 指令來達到，預設會到官方資源庫搜尋：
```sh
$ docker pull ubuntu
$ docker pull ubuntu:14.04
```
> 若為加```:```則會抓取最新版本，若加```:```可以指定版本。

### start 啟動指令
若容器被停止了，且沒有設定自動重啟，可以使用該指令啟動容器：
```sh
$ docker start [-a] [-i] <CONTAINERS>
```
> ```<containers>``` 可以是 ```ID``` 或 ```NAME```。

### stop 終止指令
若要關閉正在執行的容器，可以使用該指令，stop 會送出 SIGTERM 與 SIGKILL 訊號至容器，使得一個容器被停止：
```sh
$ docker stop [-t/--time] <CONTAINERS>
```
> ```-t``` 或 ```--time``` 可以設定等待時間。

> P.S： SIGTERM 與 SIGKILL 是 Unix 訊號，是一種 Unix 與其他的 POSIX 相容作業系統中行程間通訊協定，收到 SIGTERM 會停止行程，收到 SIGKILL 會殺掉行程。

### restart 重啟指令
透過 restart 指令可以重新啟動容器：
```sh
$ docker restart <CONTAINERS>
```

### rm 刪除指令
若已停止的容器，並不會被完全刪除，我們必須透過該指令來刪除：
```sh
$ docker rm <CONTAINERS>
$ docker rm $(docker ps -a -q)
$ docker ps -a -q | xargs docker rm
```

### ps 容器狀態
列出容器清單，可以加入選項：
```sh
$ docker ps [options]
```

| 選項 | 說明 |
|------------|------|
| -a, --all | 顯示所有容器，包含已停止 |
| -q, --quiet | 只顯示 ID |
| -s, --size | 顯示容器佔用空間 |
| -l, --latest | 只顯示最新的容器 |
| -n="" | 顯示最新的 n 個容器 |
| -before="" | 顯示特定名稱容器之前的容器 |
| -after="" | 顯示特定名稱容器之後的容器 |

### logs logs檢視
使用 logs 來查看容器的 log 資訊：
```sh
$ docker logs [--tail] [-t] <CONTAINER>
```
> ```--tail``` 追蹤一個容器，```-t```查看 log 時間。

### inspect 檢閱
該指令可以列出容器或者映像檔的詳細資訊，回傳格式為 JSON：
```sh
$ docker inspect <CONTAINER/IMAGE>
$ docker inspect -f '{{.NetworkSettings.IPAddress}}' <CONTAINER>
```
> ```-f``` 後面可以接著使用 GO 語言板模表示法。

### top 行程資訊
top 指令可以顯示容器內的行程與統計資料，與 Unix top 類似：
```sh
$ docker top <CONTAINER>
```

### attach 附加
該指令讓我們附接一個正在執行的容器：
```sh
$ docker run -dit --name ubuntu ubuntu:14.04
$ docker attach ubuntu
```

### kill 終止
若想強制終止容器，可以使用 kill 指令，就會送出
 SIGTERM：
```sh
$ docker kill <CONTAINER>
```
### cp 複製
若想從容器複製檔案或目錄到主機的路徑，可以使用以下：
```sh
$ docker run -it --name ubuntu ubuntu:14.04 /bin/bash
$ touch $(echo -e '\007')
$ docker cp ubuntu:/$(echo -e '\007') $(pwd)
```
### port 對應
若想知道有哪些 port 被映射到主機，可以使用該指令：
```sh
$ docker port <CONTAINER>
```

## 執行於自己專案的指令
### diff 差異
若要查看一個容器與映像檔之間的狀態被修改了哪些，可以使用該指令：
```sh
$ docker diff <CONTAINER>
```

### commit 提交
commit 有點像是 Git 的提交，可以將目前的容器檔案系統包裝產生一個新的映像檔：
```sh
$ docker commit [options] <CONTAINER> <REPOSITORY:TAG>
```

| 選項 | 說明 |
|------------|------|
| -p, --pause | 再提交過程中加入暫停（v1.1.1 later） |
| -m, --message="" | 指定提交的訊息，描述映像檔的用途 |
| -a, --author="" | 指定映像檔作者資訊 |

### images 映像檔
若要查看所有映像檔，可以只用該指令：
```sh
$ docker images [options] [NAME]
$ docker images | head
```

| 選項 | 說明 |
|------------|------|
| -a, --all | 顯示所有映像檔，包括中間層 |
| -f, --filter=[] | 提供篩選功能 |
| --no-trunc | 不切斷映像檔 ID |
| -q, --quiet | 只顯示映像檔 ID |

### rmi 刪除
若想刪除不需要的映像檔，會將所有依賴的相關映像等一起刪除：
```sh
$ docekr rmi [option] <IMAGE>
```

| 選項 | 說明 |
|------------|------|
| -f, --force | 強制刪除映像檔 |
| --no-prune | 不刪除沒標籤的上層映像檔 |

### save 儲存
save 可以將一個映像檔儲存成 tar 封裝檔，並輸出至標準輸出（stdout），保存了這映像檔的父檔層與元資料：
```sh
$ docker save -o ubunut.tar ubuntu
$ docker save ubuntu > ubunut.tar
```

### load 載入
若要載⼊一個 image 可以使⽤以下⽅式：
```sh
$ docker load < kairen-apache2.tar
$ docker load --input kairen-apache2.tar
```

### export 匯出
若要將容器的檔案系統儲存為 tar 封裝檔，並將內容輸出至標準輸出，他將容器內所有檔案層整合包裝，因此映像檔歷史記錄與metadata 不會被儲存：
```sh
docker export <container_id> > ubuntu.tar
```

### import 匯入
import 會先建立一個空的映像檔，再將 tar 封裝檔的內容匯入：
```sh
cat ubuntu.tar | docker import - kairen/ubuntu:14.04
```
如果想從網路匯入可以使用以下：
```sh
$ docker import URL|- [REPOSITORY:TAG]
$ docker import http://example.com/exampleimage.tgz example/ imagerepo
```

### tag 標籤
若要對映像檔下標籤，來對映像檔做版本資訊，可以使用以下方式：
```sh
$ docker tag <IMAGE> [REGISTRYHOST/][USERNAME/][NAME:TAG]
$ docker tag kairen/apache:1.0.0
```
> 一般下標籤會遵守以下格式：```username/repository:tag```

### login 登入 docker hub
使用該指令可以讓 docker client 登入 docker hub：
```sh
$ docker login [options] [SERVER]
```

| 選項 | 說明 |
|------------|------|
| -e, --email="" | 指定 Email |
| -p, --password="" | 指定密碼 |
| -u, --username="" | 指定帳號 |

### logout 登出 docker hub
使用該指令可以讓 docker client 登出 docker hub：
```sh
$ docker logout
```

### push 上傳 docker hub
若想將建立好的 docker 送交至公開的資源庫或私人的資源庫，可以用該指令：
```sh
$ docker push NAME:TAG
```
### history 歷史紀錄
history 指令可以列出一個映像檔的歷史紀錄：
```sh
$ docker history <IMAGE>
```
### events 事件
若想知道 docker 服務的事件，可以使用該指令：
```sh
$ docker events [options]
```

| 選項 | 說明 |
|------------|------|
| --since="" | 顯示由什麼時間開始的事件 |
| --until="" | 顯示到什麼時間為止的事件 |

### wait 等待
該指令能夠暫停工作直到容器停止，並輸出結束碼：
```sh
$ docker wait <CONTAINER>
```
### build 建立映像檔
若想利用 Dockerfile 建立自己的映像檔，就必須使用到該指令：
```sh
$ docker build [options] PATH | URL | -
$ docker build -t="kairen/hadoop:2.6.0" .
```
> ```.```為 Dockerfile 檔案目錄。

| 選項 | 說明 |
|------------|------|
| -t, --tag="" | 這是當建立成功時，映像檔所在檔案庫的名稱 |
| -q, --quiet | 不輸出訊息，預設為顯示 |
| --rm=true | 當成功建立後，刪除過程中產生的容器 |
| --force-rm | 不論成功建立與否，都刪除過程中所產生的容器 |
| --no-cache | 在建立過程中不使用快取 |
