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
