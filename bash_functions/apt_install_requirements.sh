#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

apt_install_requirements() {
    sudo apt -o Dpkg::Options::="--force-confold" upgrade -y

    sudo apt -o Dpkg::Options::="--force-confold" install fail2ban -y
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    if command -v fail2ban-client &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}fail2ban installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}fail2ban not found, exiting...${RESET}"
        exit 1
    fi
}