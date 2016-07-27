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
