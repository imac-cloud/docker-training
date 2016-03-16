# OpenStack Docker 整合
在 OpenStack 與 Docker 之間的關係擁有許多的討論與分析，究竟是 Docker 可能會取代 OpenStack 呢？還是 OpenStack 與 Docker 的整合呢？從目前的發展與文章來看，後者已經浮出水面。OpenStack 與 Docker 之間被明確的分為了不同的服務層，前者著重於 IaaS，然而後者則是著重於 PaaS，因此彼此之間會有很好的互補關係。目前 OpenStack 中與 Docker 相關的專案有以下幾個：
* **Nova**：為 OpenStack 的核心專案之一，主要提供運算資源與虛擬化技術，如 KVM、QEMU、Xen等，也提供了 Docker Driver，是 OpenStack 與 Docker 的第一次整合。
* **Heat**：為 OpenStack 的編配服務（Orchestration service），使用者可以定義部署板模來快速部署 OpenStack 中的運算、儲存、網路等資源。由於 Nova 的 Docker 無法使用一些高層次的功能，因此 OpenStack 透過 Heat 的特性，讓我們完全相容 Docker API。
* **Magnum**：為 OpenStack 中的容器即服務（Container as a Service）專案，在 OpenStack Liberty 版本正式釋出第一版，提供了快速部署 Docker 的叢集與擴展能力，並採用統一的管理介面進行操作。
* **Murano**：為 OpenStack 的應用程式目錄服務（Application Catalog service）專案，由於 Murano 也整合了 Kubernetes 與 Docker 的部署，因此我們可以透過 Murano 來快速部署容器服務。然而 Murano 與 Solum 有關係，Solum 被用來開發應用程式，而 Murano 用來做發佈與部署。
* **Kolla**：Kolla 比較特殊，它被用來提供基於 Docker 容器的 OpenStack 服務部署與更新升級解決方案，主要將 OpenStack 各服務的粒度縮小到容器級別，並透過 Docker 的特性來快速部署（Pull、Run）。
* **Kuryr**：Kuryr 主要被用於 OpenStack 提供容器網路服務的專案，它作為 libnetwork 的一個遠程類別驅動，來支援連接 CNM（Container Network Model）與 Neutron 所提供的網路服務。

> 以上不代表全部，詳細會在 OpenStack Project List 中再找出相關專案，並更新到該列表。
