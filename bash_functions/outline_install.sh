#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

# outline_update() {}
func_outline_update=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/outline_update.sh)
if [[ -z "$func_outline_update" ]]; then
    echo "Error in func_outline_update!" >&2
    exit 1
fi
source <(echo "$func_outline_update")

outline_install() {
    wget -q --inet4-only https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh
    yes | sudo bash install_server.sh --hostname $WEB_ADDRESS --keys-port 8081 > outline_manager_output.txt
    OUTLINE_MANAGER_KEY=$(sudo cat outline_manager_output.txt | sed -E 's/\x1B\[[0-9;]*m//g' | grep -oP '{.*}')
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
    
    echo "Outline Web-GUI: http://$WEB_ADDRESS/outline | Login: vpnadmin | Password: $PASSWORD" | sudo tee -a credentials.txt > /dev/null
    echo "Outline Manager key: $OUTLINE_MANAGER_KEY" | sudo tee -a credentials.txt > /dev/null

    outline_update

    sudo echo $OUTLINE_MANAGER_KEY > /var/www/vpnadmin/outline/outline_manager_key.php
    sudo echo $WEB_ADDRESS > /var/www/vpnadmin/outline/web-address.php 
}