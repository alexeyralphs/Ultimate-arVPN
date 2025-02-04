#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

apt_install_docker() {
    sudo mkdir -vp /etc/docker/
    mv /etc/docker/daemon.json /etc/docker/daemon.json-backup-$(date +"%Y%m%d") 2>/dev/null

sudo tee /etc/docker/daemon.json > /dev/null <<'ENDOFFILE'
{
    "registry-mirrors": [
        "https://dockerhub.timeweb.cloud",
        "https://dockerhub1.beget.com",
        "https://mirror.gcr.io"
    ]
}
ENDOFFILE
sudo systemctl restart docker

    sudo apt -o Dpkg::Options::="--force-confold" install ca-certificates -y
    sudo apt -o Dpkg::Options::="--force-confold" install gnupg -y
    sudo apt -o Dpkg::Options::="--force-confold" install lsb-release -y
    sudo apt -o Dpkg::Options::="--force-confold" install software-properties-common -y

    if ! command -v docker &>/dev/null; then
        sudo curl -s https://get.docker.com | sudo sed '/sleep 20/d' | sudo sh -f
    elif ! command -v docker &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}Docker CE is not installed. Installing docker.io...${RESET}"
        sudo apt -o Dpkg::Options::="--force-confold" install docker.io -y
    elif command -v docker &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}docker installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}docker not found, exiting...${RESET}"
        exit 1
    fi
}