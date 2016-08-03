## Kontena Nodes 安裝

> 本篇教學是敘述如何在 Ubuntu 14.04 環境上安裝 Kontena Nodes ，若你需要在其他平台上安裝，可查閱[官方文件](https://www.kontena.io/docs/getting-started/installing/nodes#ubuntu-14-04)教學。

###Step 1. 安裝 Kontena Ubuntu Packages

```
$ wget -qO - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
$ echo "deb http://dl.bintray.com/kontena/kontena /" | sudo tee -a /etc/apt/sources.list
$ sudo apt-get update
$ sudo apt-get install kontena-agent
```

> * 注意，使用以上指令需安裝 Docker 環境，若你不知道如何建置 Docker 可查閱本篇[教學](../docker-1.10/README.md)。
> * 這裡需要輸入 Kontena Master IP 與 Token ，你可以在 Kontena CLI 使用 `kontena grid show <name>` 查詢 Token。

###Step 2. 重新啟動 Docker

```
$ sudo restart docker
```