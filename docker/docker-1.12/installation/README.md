## 安裝

官方已於 2016/07/28 釋出 Docker 1.12 安裝腳本，提供使用者快速安裝。

- deb/rpm install：
```
curl -fsSL https://experimental.docker.com/ | sh
```

- [Linux 64bit tgz](https://experimental.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz)

- [Darwin/OSX 64bit client tgz](https://experimental.docker.com/builds/Darwin/x86_64/docker-1.12.0.tgz)

- [Windows 64bit zip](https://experimental.docker.com/builds/Windows/x86_64/docker-1.12.0.zip)

- [Windows 32bit client zip](https://experimental.docker.com/builds/Windows/i386/docker-1.12.0.zip)

安裝完，可使用 `docker version` 查看版本，確認安裝無誤。

```
ubuntu@docker:~$ docker version
Client:
 Version:      1.12.0
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   8eab29e
 Built:        Thu Jul 28 22:00:36 2016
 OS/Arch:      linux/amd64

Server:
 Version:      1.12.0
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   8eab29e
 Built:        Thu Jul 28 22:00:36 2016
 OS/Arch:      linux/amd64
```