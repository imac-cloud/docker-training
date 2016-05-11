# 建立 Base Image
要從本機匯入一個映像檔，可以使用 OpenVZ（容器虛擬化的先鋒技術）的模板來建立： OpenVZ 的模板下載位址為 http://openvz.org/Download/templates/precreated。
```sh
$ sudo cat ubuntu-14.04-x86_64-minimal.tar.gz  |docker import - ubuntu:14.04
```

# 視覺化工具
* [dockers-ui](https://github.com/crosbymichael/not-dockers-ui)
* [dockerboard](https://github.com/dockerboard/dockerboard/blob/master/README.md)
* [dockery](https://github.com/lexandro/dockery)
* [albatros](https://github.com/dcylabs/albatros)
* [cAdvisor](https://github.com/google/cadvisor)

# 其他參考
* [A Scalable Web Services Demo using Docker Swarm, Compose and Blockbridge](https://www.blockbridge.com/a-scalable-web-services-demo-using-docker-swarm-compose-and-blockbridge/)
* [How to Build an High Availability MQTT Cluster for the Internet of Things](https://medium.com/@lelylan/how-to-build-an-high-availability-mqtt-cluster-for-the-internet-of-things-8011a06bd000#.9duafxm14)
* [Hypernetes](https://feiskyer.gitbooks.io/hypernetes/content/index.html)
* [swarm + interlock + nginx + redis 達到保有 session 的 HA 及 dynamic scaling 架構](http://genchilu-blog.logdown.com/posts/509176)
* [The Ultimate NodeJS Development Setup with Docker](http://paislee.io/the-ultimate-nodejs-development-setup-with-docker/?mkt_tok=3RkMMJWWfF9wsRonuqTMZKXonjHpfsX54uQqUKO1lMI%2F0ER3fOvrPUfGjI4DScBkI%2BSLDwEYGJlv6SgFQ7LMMaZq1rgMXBk%3D)
