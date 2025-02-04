#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

outline_install() {
    wget -q --inet4-only https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh
    yes | sudo bash install_server.sh --hostname $WEB_ADDRESS --keys-port 8081 > outline_manager_output.txt
    OUTLINE_MANAGER_KEY=$(sudo grep -oE '\{"api.*"}' outline_manager_output.txt) # Создаем переменную с ключом для подключения к Outline Manager
    sudo rm install_server.sh -f
    sudo rm outline_manager_output.txt -f

    if docker ps | grep -q "watchtower"; then
        echo "${BLUE_BG}${BLACK_FG}watchtower container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}watchtower container not found. Exiting...${RESET}"
        exit 1
    fi

    if docker ps | grep -q "outline"; then
        echo "${BLUE_BG}${BLACK_FG}outline shadowbox container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}outline shadowbox container not found. Exiting...${RESET}"
        exit 1
    fi
    
    echo "Outline Web-GUI: http://$WEB_ADDRESS:8181/outline | Login: vpnadmin | Password: $PASSWORD" | sudo tee -a credentials.txt > /dev/null
    echo "Outline Manager key: $OUTLINE_MANAGER_KEY" | sudo tee -a credentials.txt > /dev/null

    sudo mkdir -vp /var/www/vpnadmin/outline/scripts
    sudo mkdir -vp /var/www/vpnadmin/outline/images
    sudo mkdir -vp /var/www/vpnadmin/outline/css
    sudo mkdir -vp /var/www/vpnadmin/outline/js

    sudo echo $OUTLINE_MANAGER_KEY > /var/www/vpnadmin/outline/outline_manager_key.php
    sudo echo $WEB_ADDRESS > /var/www/vpnadmin/outline/web-address.php

    curl -s -o /var/www/vpnadmin/outline/images/outline-logo-short.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline-logo-short.svg
    curl -s -o /var/www/vpnadmin/outline/css/styles.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/styles.css
    curl -s -o /var/www/vpnadmin/outline/images/logout_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/logout_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/outline_title.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline_title.svg
    curl -s -o /var/www/vpnadmin/outline/images/copy_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/copy_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/delete_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/delete_button.svg
    curl -s -o /var/www/vpnadmin/outline/js/js.js https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/js/js.js
    curl -s -o /var/www/vpnadmin/outline/index.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/index.html
    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/regenerate_outline_manager_key.php
    curl -s -o /var/www/vpnadmin/outline/scripts/new_client_key.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/new_client_key.php
    curl -s -o /var/www/vpnadmin/outline/scripts/get_client_key_list.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/get_client_key_list.php
    curl -s -o /var/www/vpnadmin/outline/scripts/remove_client.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/remove_client.php
    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.sh https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/regenerate_outline_manager_key.sh  
}