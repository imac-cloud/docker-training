## Kontena

### 什麼是 Kontena ?

Kontena 是一套叢集式分派工作與執行容器化工作負載的開放原始碼套件，Kontena 系統是由數個 Kontena Nodes（實體機器或 VM 執行容器化工作負載）與一個控制與監控 Nodes 的 Kontena Master 組成。

在 Kontena 中，你可以透過 Kontena Service 定義你的應用程式，一個服務的定義包含 Container 的 Image、網路、規模與狀態/無狀態屬性。建立期望的架構可能需要將服務串接在一起，每個服務自動分派 internal DNS address 將你的應用程式中，內部服務通訊串接。

**Kontena 主要功能概述：**

* Scheduler with affinity filtering
* Built-in private Docker image registry
* Remote VPN access for workload services
* Ready made load-balancing service
* Log and statistics aggregation with streaming
* Access control and roles for Kontena users

Kontena 透過 Kontena command line (Kontena CLI) 進行操作，目前還沒有一個圖形化介面（基於 Web）提供使用者使用。

### 安裝 Kontena

如果你對於 Kontena 有興趣想嘗試安裝環境，可查閱 [Kontena 安裝](installation/cli/README.md)
 