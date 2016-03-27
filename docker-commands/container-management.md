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

### kill 終止
若想強制終止容器，可以使用 kill 指令，就會送出
 SIGTERM：
```sh
$ docker kill <CONTAINER>
```
