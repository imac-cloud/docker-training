#!/bin/bash

#add the new GPG key
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

#create docker.list in /etc/apt/source.list.d
sudo sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main \
> /etc/apt/sources.list.d/docker.list"

#update apt-get and install docker-engine
sudo apt-get update
sudo apt-get install -y docker-engine

#install pip and docker-compose
sudo apt-get install -y python-pip
sudo pip install docker-compose