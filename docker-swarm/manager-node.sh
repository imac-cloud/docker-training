#!/bin/bash

read -p "Please input your manager node name : " MANAGER_NAME
MANAGER_NAME=${MANAGER_NAME:-"manager-1"}

sudo apt-get update
sudo apt-get install -y git make

#install go1.6

wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.6.linux-amd64.tar.gz
export GOROOT="/usr/local/go"
export GOPATH="/home/ubuntu/go"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

#install swarmkit

go get github.com/docker/swarmkit
cd ~/go/src/github.com/docker/swarmkit &&
make binaries
cd ~/go/src/github.com/docker/swarmkit/bin &&
sudo cp protoc-gen-gogoswarm swarm-bench swarmctl swarmd /usr/bin/

#start manager-node

swarmd -d /tmp/$MANAGER_NAME --listen-control-api /tmp/$MANAGER_NAME/swarm.sock --hostname $MANAGER_NAME