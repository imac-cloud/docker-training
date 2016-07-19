#!/bin/bash

read -p "Please input your work node name : " WORKER_NAME
read -p "Please input your manager node ip address : " MANAGER_IP
WORKER_NAME=${WORKER_NAME:-"worker-1"}
MANAGER_IP=${MANAGER_IP:-"127.0.0.1"}

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

#start worker-node

swarmd -d /tmp/$WORKER_NAME --hostname $WORKER_NAME --join-addr $MANAGER_IP:4242
