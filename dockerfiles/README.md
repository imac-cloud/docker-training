# Dockerfile
本章將說明 Docker 映像檔建置與 Dockerfile 的使用與語法。若嘗試過 docker 基本操作的人，想必已經知道如何下載與上傳映像檔，且也知道透過既有映像檔來修改成一個獨一的應用程式映像檔，但是當嘗試過一次後，想要修改先前某一個過程，這時會發生透過這樣方式既不方便又不實際。然而 Dockerfile 正是解決這一問題的良藥，Dockerfile 是一個被用來描述映像檔產生的步驟，當我們建置時，會依照檔案的內容以及語法由上而下的執行，最後產生一個映像檔。Dockerfile 的內容格式描述如以下所示：
```sh
# Comment
INSTRUCTION arguments
```
> 其中```#```號為註解，若 # 號不在開頭則表示指令參數。```INSTRUCTION```表示 Dockerfile 的語法。

Dockerfile 使用 Domain Specific Language 來表示對應的執行功能，其指令如下列表所示。

### FROM
指定該要被建置映像檔使用的基礎映像檔名稱，可指定本地或 docker hub（公有倉庫）的映像檔，語法格式如下：
```sh
FROM <image_name>:<tag>
```
> 其中```<tag>```可以依需求加入，若沒有則抓取```latest```版本。一般情況下是 Dockerfile 的開頭。

### MAINTAINER
單純用來表示該 Dockefile 的維護人資訊，語法格式如下：
```sh
MAINTAINER "name <email>"
```
> 後面格式為一個字串，可自我定義。

### RUN
RUN 指令在 Dockerfile 被用來指定執行基礎映像檔中已存在的指令，且該指令必須是能夠```自動完成```的指令，語法格式如下：
```sh
RUN <command>
RUN ["exec", "args1", "args2"]
```
> 第一種會以```shell```方式執行，類似```/bin/sh -c <command>```。第二種則是在沒有 shell 時使用。

一般成功執行過的指令會被快取，這樣可以當過程中哪個步驟錯誤時，下次會直接從該步驟執行，但是快取會有以下失效情況：
* 當 build 時，輸入```--no-cache```時。
* 無法快取的指令，如```apt-get update```。
* 當使用 COPY 與 ADD 時，檔案內容被改變了。

### CMD
該指令被用於當容器被啟動時，指定容器預設所要執行的指令，指令格式如下：
```sh
CMD <command> <arg1> <arg2>
CMD ["arg1", "arg2"]
CMD ["exec", "arg1", "arg2"]
```
> 格式(一)採用 shell 方式執行。格式(二)單純只是參數，需加```ENTRYPOINT```輔助。格式(三)最建議使用，其```exec```必須為絕對路徑。

### ENTRYPOINT
該語法讓我們可以指定映像檔中的執行檔，當映像檔被啟動時可以在最後面輸入執行檔接受的參數或指令，語法格式如下：
```sh
ENTRYPOINT <command> arg1 arg2
ENTRYPOINT ["exec", "arg1", "arg2"]
```
> 與 CMD 不同的是當起動時可以隨需求加入參數，如以下```docker run <image>:<tag> <command/args>```。

### WORKDIR
用來設定 RUN、CMD 與 ENTRYPOINT 的工作目錄，語法格式如下：
```sh
WORKDIR <path>
```
> 可在 Dockerfile 多個地方以相對路徑表示。

### EXPOSE
用來表示哪些 Port 被曝露給外部存取，語法格式如下：
```sh
EXPOSE <port>
EXPOSE <port/tcp>
```
> 雖然這邊指定了曝露的 Port，但是實際執行時依然要透過```-p```來指定 Port。

### ENV
用來設定環境參數，語法格式如下：
```sh
ENV <key> <value>
```
> 該指令跟```docker run -e <key>=<value>```是類似的功能。

### USER
指定該映像檔在被執行時的使用者名稱，語法格式如下：
```sh
USER <user>
```
> 可以輸入```User Name```或者```UID```。

### VOLUME
指定要被建立掛載的目錄，並提供給主機或其他容器日後掛載，語法格式如下：
```sh
VOLUME <path>
VOLUME ["<path>"]
```

### ADD
將指定的任意地方的檔案複製到映像檔內，語法格式如下：
```sh
ADD <src> <dest>
ADD <URL> <dest>
add <*.tar> <dest>
```
> 類似 COPY，但是多了許多檔案來源，如網路檔案、壓縮檔案。其中當指定壓縮檔，並被複製到映像檔時會被直接解壓縮。

### COPY
將指定的檔案從主機複製到映像檔內，語法格式如下：
```sh
COPY <src> <dest>
```
> 類似 ADD，但不同之處在於 COPY 只能複製 Dockerfile 明確指定的檔案。

### ONBUILD
ONBUILD 是增加一個之後執行的觸發器指令到映像檔中，當該映像檔被當作基礎映像檔使用時，這些觸發器就會在 FROM 時執行加入到建置的過程中。語法格式如下：
```sh
ONBUILD [INSTRUCTION]
```
> P.S. 一個 ONBUILD 語法無法呼叫 ONBUILD。

### LABEL
### ARG
### STOPSIGNAL
