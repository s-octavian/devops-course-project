#!/bin/bash

dnf -y install dnf-plugins-core

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

systemctl start docker
systemctl enable docker
#systemctl enable --now docker

docker run hello-world
docker -v
