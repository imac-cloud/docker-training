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

