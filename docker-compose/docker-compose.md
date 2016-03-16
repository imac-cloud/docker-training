# 安裝 Docker Compose
docker-compose 能夠安裝於 OS X 與 64-bit Lunix 作業系統上，但目前不支援 Windows。在安裝 docker-compse 之前，需要先安裝 docker，請參閱 [Mac OS X installation](https://docs.docker.com/engine/installation/mac/)、[Ubuntu installation](https://docs.docker.com/engine/installation/ubuntulinux/)與[other system installations](https://docs.docker.com/engine/installation/)。完成 docker 安裝後，就可以使用以下方式安裝 docker-compose：
```sh
$ curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

之後必須給予執行權限：
```sh
$ chmod +x /usr/local/bin/docker-compose
```

完成後就可以使用 docker-compose，如以下指令可以查看版本：
```sh
$ docker-compose --version
docker-compose version 1.6.0, build d99cad6
```
> 也可以使用```pip```來安裝，如下：
> ```sh
> pip install docker-compose
> ```

### 簡單範例
這邊使用官方的第一個範例，部署一個 Python flask 的 Web 應用程式，首先要建立一個目錄```composetest```：
```sh
$ mkdir composetest
$ cd composetest
```

建立與編輯一個名為```app.py```的 Python 檔案：
```py
from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello World! I have been seen %s times.' % redis.get('hits')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

接著建立一個```requirements.txt```檔案，用來撰寫該應用程式需要安裝的相依套件：
```sh
flask
redis
```

接下來我們必須先建立一個 Image，在目錄新增一個名為```Dockerfile```的檔案，並新增以下內容：
```sh
FROM python:2.7
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD python app.py
```

之後，透過 docker 的指令建置：
```sh
$ docker build -t web .
```

再來我們要定義應用程式的服務，docker-compose 透過 YAML 語法來描述要部署與建置的應用程式，新增一個名為```docker-compose.yml```檔案，並加入以下內容：
```
version: '2'
services:
  web:
    build: .
    ports:
     - "5000:5000"
    volumes:
     - .:/code
    depends_on:
     - redis
  redis:
    image: redis
```
> 這個 compose 檔案定義了兩個服務，分別為```web```與```redis```。其中```web```的 build 表示建置 ```.```目錄底下的 Dockerfile; ```web```的 ports 表示要曝露的 port; volumes 表示要 Mount 於主機的目錄; depends_on 為連結 web 服務到 redis 服務。

新增完成後，就可以在目錄透過 docker-compose 指令來建置應用程式：
```sh
$ docker-compose up
Pulling image redis...
Building web...
Starting composetest_redis_1...
Starting composetest_web_1...
```
> 當完成後，就可以開啟 http://MACHINE_VM_IP:5000。

若要執行於背景行程，可以使用以下方式：
```sh
$ docker-compose up -d
Starting composetest_redis_1...
Starting composetest_web_1...
```

這時我們可以透過其他指令來查看資訊，如以下是查看環境變數：
```sh
$ docker-compose run web env
```

當想關閉應用程式時，可以使用以下方式：
```sh
$ docker-compose stop
$ docker-compose rm
```
