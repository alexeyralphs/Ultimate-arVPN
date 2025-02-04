#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

apt_install_webserver() {
    sudo apt -o Dpkg::Options::="--force-confold" install nginx -y
    if command -v nginx &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}nginx installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}nginx not found, exiting...${RESET}"
        exit 1
    fi

    sudo apt -o Dpkg::Options::="--force-confold" install php-fpm -y
    if ps aux | grep -v grep | grep -q php-fpm; then
        echo "${BLUE_BG}${BLACK_FG}php-fpm is running.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}php-fpm not found, exiting...${RESET}"
        exit 1
    fi

    sudo apt -o Dpkg::Options::="--force-confold" install apache2-utils -y
    if command -v htpasswd &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}apache2-utils installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}apache2-utils not found, exiting...${RESET}"
        exit 1
    fi

    sudo apt -o Dpkg::Options::="--force-confold" install php-curl -y
    if php -m | grep -q curl; then
        echo "${BLUE_BG}${BLACK_FG}php-curl installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}php-curl not found, exiting...${RESET}"
        exit 1
    fi

    sudo rm /etc/nginx/sites-enabled/default 2>/dev/null
    sudo rm /etc/nginx/sites-available/default 2>/dev/null
    sudo systemctl enable nginx
    sudo systemctl start nginx
}