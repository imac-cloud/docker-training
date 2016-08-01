# Swarm mode 概述
在 Swarm mode 中使用 Docker Engine，從 [Docker releases GitHub repository](https://github.com/docker/docker/releases) 安裝 `v1.12.0-rc1` 或更新版本，或者安裝最新的 Docker for Mac 或 Docker for Windows Beta。

Docker Engine 1.12 包含了 Swarm mode ，可提供本機管理 Docker Engines 叢集，我們稱為 Swarm ，使用 Docker CLI 建置一個 Swarm 叢集，部屬一個應用服務在 Swarm 上，並且管理 Swarm。

如果你使用的版本在 v1.12.0-rc1 之前，可查看 [Docker Swarm](https://docs.docker.com/swarm/)

## 亮點功能

- **叢集式管理整個 Docker Engine**：使用 Docker Engine CLI 建立一個 Docker Engines 的 Swarm 叢集，你可以在上面部屬任何應用服務。你不需要建置另外的 orchestration 軟體或管理一個 Swarm。

- **分散式設計**：Docker Engine 在運行時處理任何專業任務，代替部屬時處理不同的節點角色。你可以使用 Docker Engine 部屬 worker 與 manager 兩個不同的節點，換句話說，你可以透過單一的 disk image 部屬整個 Swarm 。

- **宣告服務模式**：Docker Engine 使用一個宣告的方式，讓在你的應用程式中定義不同服務種類的預期狀態，例如：你可以描述一個應用程式的結構式一個 Web front end 有 message queueing 與資料庫服務。

- **可擴充性**：在每個服務，你可以宣告你預期執行的 tasks 數量，當你規模擴大或縮小， swarm manager 會自動依照你期望的狀態適度的增加或減少 tasks 。

- **預期狀態協調**：swarm manager 節點經常監控叢集狀態與當實際狀態與你預期的狀態不同時進行協調，例如：你在 container 上執行安裝一個服務執行 10 個副本，並且在一個工作節點上的兩個副本呈現崩潰狀態，此時，管理節點會建立兩個新的副本取代原先崩潰的兩個副本，swarm manager 會將新的副本分配到可執行與可用的工作節點上。

- **多主機網路**：你可以指定一個網路去執行你的服務，當你初始化或更新應用服務， swarm manager 會自動分配給 containers 個別的網路位址。

- **服務發現**：Swarm manager 節點分配在 Swarm 上的每個服務一個唯一的 DNS 名稱與執行負載平衡，你可以透過在 Swarm 嵌入 DNS 服務來針對 Swarm 上的 container 進行詢問請求。

- **負載平衡**：你可以暴露服務的 port 提供外部負載平衡使用，在內部， Swarm 讓你指定如何在節點上分配服務的 containers。

- **預設安全性**：在 swarm 上的每個節點強制 TLS 手動驗證以及加密，讓本身與其他節點保持通訊的安全。

- **逐步更新**：在發佈前，你可以讓你的應用程式逐步更新到每個節點， swarm manager 允許你在部屬服務於不同節點時設定延遲時間，假如之中有任何差錯，你可以逐步將服務的回溯到前一個版本。

## Swarm 實作

* [環境建置](https://github.com/imac-cloud/docker-tutorial/tree/dev/docker/docker-1.12/Swarm/Installation)
* [佈署應用服務](https://github.com/imac-cloud/docker-tutorial/tree/dev/docker/docker-1.12/Swarm/Service)
