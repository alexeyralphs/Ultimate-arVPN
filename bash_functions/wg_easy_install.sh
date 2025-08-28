#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

wg_easy_install() {
    docker stop wg-easy 2> /dev/null
    docker rm wg-easy 2> /dev/null

    wg_password_hash=$(docker run --rm ghcr.io/wg-easy/wg-easy wgpw "$PASSWORD")
    current_wg_password_hash=$(echo $wg_password_hash | sed "s/^[^']*//")

    docker run -d --name=wg-easy \
    -e WG_HOST=$WEB_ADDRESS \
    -e PASSWORD_HASH=$wg_password_hash \
    -e WG_PORT=8080 \
    -e WG_DEFAULT_ADDRESS=10.0.0.x \
    -v /root/.wg-easy:/etc/wireguard \
    -p 8080:51820/udp \
    -p 51821:51821/tcp \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    --sysctl=net.ipv4.conf.all.src_valid_mark=1 \
    --sysctl=net.ipv4.ip_forward=1 \
    --restart unless-stopped \
    ghcr.io/wg-easy/wg-easy

    if docker ps | grep -q "wg-easy"; then
        echo "${BLUE_BG}${BLACK_FG}wg-easy container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}wg-easy container not found. Exiting...${RESET}"
        exit 1
    fi

    echo "Wireguard GUI: http://$WEB_ADDRESS/wireguard | Login: vpnadmin | Password: $PASSWORD" | sudo tee credentials.txt > /dev/null
}
