### logs 檢視
使用 logs 來查看容器的 log 資訊：
```sh
$ docker logs [--tail] [-t] <CONTAINER>
```
> ```--tail``` 追蹤一個容器，```-t```查看 log 時間。

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
