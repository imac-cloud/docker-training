# Kubernetes
Kubernetes 是 Google 的開源專案，主要用於管理跨主機容器化叢集系統。該專案脫胎於 Google 內部叢集管理工具 Borg，早期主要貢獻者更是參與 Borg 專案的人員，大概基本上都認為 Kubernetes 許多概念與架構是來至 Google 十餘年的設計、部署、管理大規模容器的經驗。

Kubernetes 在 Docker 叢集管理中是很重要的一員，其實作了許多功能，包含應用程式部署、叢集節點擴展、自動容錯機制等，並且能夠統一管理跨主機的管理。其架構如下圖所示。

![](images/kubernets-arch.png)

使用 Kubernetes 的好處，網路上已有許多相關資訊，這邊列舉幾個：
* 輕易的 Scale out/in 容器
* 自動化容錯與擴展，如容器的部署與副本
* 以多個容器組成群組，並提供容器負載平衡
* 容易擴展節點
* 以叢集的方式來管理跨機器的容器。
* 基於 Docker 的應用程式封裝、實例化與執行。

如架構圖所示，Kubernetes 由多個元件組合而成，然而在了解 Kubernetes 元件之前，我們需要先知道 Kubernetes 的生態圈中的一些重要概念，這些概念將影響對於 Kubernetes 進一步的探索，其主要概念如下：
* **Pods（po）**：是 k8s 的最基本執行單元，即包含一組容器與 Volumes。在同一個 Pod 裡的容器會共享使用一個網路命名空間，並利用 localhost 溝通，Pod 生命週期是短暫的。

* **Services（svc）**：由於 k8s 的 Pods 中的容器 IP 會隨著排程、故障等因素而改變，因此 k8s 利用 Service 來定義一系列存取這些 Pod 應用程式服務的抽象層。Service 透過 Proxy 的 port 與 Selector 來決定服務請求要傳送給後端哪些 Pods 中的容器，因此對外是單一的存取介面，。

* **Replication Controllers（rc）**：主要確保 k8s 叢集所指定 Pod 中的容器被正常運作的副本數量，當正在執行的容器發生故障，而少於副本數時，Replication Controller 會在任一節點啟動一個新的容器，然後若是多於副本數量則會自動移除一個容器。

* **Lable**：被用來區分 Pod、Service 與 Replication Controllers 的 Key/Vaule 標籤，用來傳遞使用者定義的屬性。Label 是 rc 與 svc 的執行基礎，rc 透過標示容器 label 來讓 svc 服務請求正確選擇要存取容器。

* **Node**：是運行 k8s worker 的實體或者虛擬機器，一般稱為 Minion 節點。該節點會運作幾個 k8s 關鍵元件：
  * kubelet：為 master 節點的 agent。
  * kube-proxy： Sevice 使用其將服務請求連接路由到 Pod 的容器中。
  * docker engine（或 rocket）：主要建立容器的引擎。

* **Master**：每一個 k8s 叢集都會有一個或多個 Master，主要提供 REST APIs、管理 k8s 工具、運行 Etcd 、Scheduler 以及 Pod 的 Replication Controller 等服務。
