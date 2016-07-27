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
