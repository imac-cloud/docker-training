## Kontena Master 安裝

> 本篇教學是敘述如何在 Ubuntu 14.04 環境上安裝 Kontena Master ，若你需要在其他平台上安裝，可查閱[官方文件](https://www.kontena.io/docs/getting-started/installing/master#ubuntu-14-04)教學。

###Step 1. 安裝 Kontena Ubuntu Packages

```
$ wget -qO - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
$ echo "deb http://dl.bintray.com/kontena/kontena /" | sudo tee -a /etc/apt/sources.list
$ sudo apt-get update
$ sudo apt-get install kontena-server
```

>注意，使用以上指令需安裝 Docker 環境，若你不知道如何建置 Docker 可查閱本篇[教學](../docker-1.10/README.md)。

###Step 2. 安裝 ssl certificate

使用你善用的編輯軟體，例如：vim ，開啟 `/etc/default/kontena-server-haproxy` 並修改如下：

```
# HAProxy SSL certificate
SSL_CERT=/path/to/certificate.pem
```

###Step 3. 啟動 Kontena 服務

```
$ sudo start kontena-server-api
```