## Ruby 2.0

###安裝

首先，你可以使用以下指令更新及安裝相依套件：

```
sudo apt-get update

sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
```

接著，到 Ruby 官方網站下載 2.0.0 版本壓縮安裝檔案進行解壓縮：

```
wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz

tar -xvzf ruby-2.0.0-p481.tar.gz
```

最後，進入 `ruby-2.0.0-p481` 執行相依套件安裝：

```
./configure --prefix=/usr/local
sudo make
sudo make install
```

###驗證

安裝完畢後，可以使用 `ruby --version` 指令檢查是否正確安裝完成。

```
ruby 2.0.0p481 (2014-05-08 revision 45883) [x86_64-linux]
```