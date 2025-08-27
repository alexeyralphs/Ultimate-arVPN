#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

wg_easy_install() {
    docker compose stop wg-easy 2> /dev/null
    docker compose rm wg-easy 2> /dev/null

    sudo mkdir -p /etc/docker/containers/wg-easy
    sudo curl -o /etc/docker/containers/wg-easy/docker-compose.yml https://raw.githubusercontent.com/wg-easy/wg-easy/master/docker-compose.yml
    docker compose -f /etc/docker/containers/wg-easy/docker-compose.yml up -d \
        -e PASSWORD=$PASSWORD \
        -e WG_HOST=$WEB_ADDRESS \
        -e PORT=8080

    if docker ps | grep -q "wg-easy"; then
        echo "${BLUE_BG}${BLACK_FG}wg-easy container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}wg-easy container not found. Exiting...${RESET}"
        exit 1
    fi

    echo "Wireguard GUI: http://$WEB_ADDRESS/wireguard | Login: vpnadmin | Password: $PASSWORD" | sudo tee credentials.txt > /dev/null
}
