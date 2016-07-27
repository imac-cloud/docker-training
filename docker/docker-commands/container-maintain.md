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

### diff 差異
若要查看一個容器與映像檔之間的狀態被修改了哪些，可以使用該指令：
```sh
$ docker diff <CONTAINER>
```

### export 匯出
若要將容器的檔案系統儲存為 tar 封裝檔，並將內容輸出至標準輸出，他將容器內所有檔案層整合包裝，因此映像檔歷史記錄與metadata 不會被儲存：
```sh
docker export <container_id> > ubuntu.tar
```

### wait 等待
該指令能夠暫停工作直到容器停止，並輸出結束碼：
```sh
$ docker wait <CONTAINER>
```
