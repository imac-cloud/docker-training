##快速建置

###Step 1. 安裝 Kontena CLI
> 前置條件：你必須在部屬環境下安裝 Ruby 2.0 或以上版本，若你想知道更多關於安裝資訊，可以查看 [Ruby 官方文件](https://www.ruby-lang.org/en/documentation/installation/)。

你可以透過 Rubygems package manager 安裝 Kontena CLI。

```
$ gem install kontena-cli
```

安裝完成後，你可以使用 `kontena version` 確認 Kontena CLI 成功安裝。

###Step 2. 註冊使用者個人帳號

在 Kontena 環境中，所有使用者必須有自己的個人帳號。Kontena 透過使用者帳號進行存取管控與產生使用者操作記錄。建立你的個人帳號（假如你還沒有）：

```
$ kontena register
```

###Step 3. 安裝 Kontena Master

為了能正常使用 Kontena ，你必須安裝一個以上 Kontena Master ， Kontena Master 提供你一個雲端平台。這裡提供你一個簡單的佈署方式，讓能在你的本機端[建置 Kontena Master](../master/README.md)。

###Step 4. 登入並建立 Grid

在你加入 Kontena node 前，你必須登入 Kontena Master 並且建立一個 Kontena Grid。例如：你的 IP Address 為 `192.168.66.100:8080`，則使用以下指令登入：

```
$ kontena login http://192.168.66.100:8080
Email: your.email@domain.com
Password: *********
 _               _
| | _ ___  _ __ | |_ ___ _ __   __ _
| |/ / _ \| '_ \| __/ _ \ '_ \ / _` |
|   < (_) | | | | ||  __/ | | | (_| |
|_|\_\___/|_| |_|\__\___|_| |_|\__,_|
-------------------------------------
Copyright (c)2016 Kontena, Inc.

...
```

首次登入，你必須建立一個 Grid ， Grid 為你後續加入 Kontena Node 使用。你可以使用 `kontena grid create` 建立。假設你的名字為 `imac` ，則使用以下指令：

```
kontena grid create imac
```

###Step 5. 安裝 Kontena Nodes

你需要一個以上的 Kontena Nodes 執行工作負載，以下提供你一個簡單的 [Kontena Nodes 安裝](../node/README.md)方式。

###Step 6. 開始你 Kontena 第一個操作！

如果你遵循以上的安裝步驟，你目前應該有一個可以運行的 Kontena 環境，我們可以透過 `Kontena node ls` 查看目前運作的節點：

```
Name                                                                   Status     Initial    Labels
kontena-node                                                           online     yes
```