#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

apt_install_initial() {
    grep -P '^\s*127\.0\.0\.1\s+localhost\s*$' /etc/hosts > /dev/null || echo "127.0.0.1 localhost" | sudo tee -a /etc/hosts > /dev/null

    sudo apt update

    sudo apt -o Dpkg::Options::="--force-confold" install curl -y
    if command -v curl &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}curl installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}curl not found, exiting...${RESET}"
        exit 1
    fi

    sudo apt -o Dpkg::Options::="--force-confold" install wget -y
    if command -v wget &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}wget installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}wget not found, exiting..."
        exit 1
    fi

    (crontab -l 2>/dev/null | grep -Pq '^0\s+2\s+\*\s+\*\s+\*\s+apt\s+update\s*&&\s*apt\s+upgrade\s+-y$') || (crontab -l 2>/dev/null; echo "0 2 * * * apt update && apt upgrade -y") | crontab -
}