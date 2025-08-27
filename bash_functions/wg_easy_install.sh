#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

wg_easy_install() {
    docker stop wg-easy 2> /dev/null
    docker rm wg-easy 2> /dev/null

    docker network create \
        -d bridge --ipv6 \
        -d default \
        --subnet 10.42.42.0/24 \
        --subnet fdcc:ad94:bacf:61a3::/64 wg \
    
    docker run -d \
        --net wg \
        -e INSECURE=true \
        --name wg-easy \
        --ip6 fdcc:ad94:bacf:61a3::2a \
        --ip 10.42.42.42 \
        -v ~/.wg-easy:/etc/wireguard \
        -v /lib/modules:/lib/modules:ro \
        -p 8080:51820/udp \
        -p 51821:51821/tcp \
        --cap-add NET_ADMIN \
        --cap-add SYS_MODULE \
        --sysctl net.ipv4.ip_forward=1 \
        --sysctl net.ipv4.conf.all.src_valid_mark=1 \
        --sysctl net.ipv6.conf.all.disable_ipv6=0 \
        --sysctl net.ipv6.conf.all.forwarding=1 \
        --sysctl net.ipv6.conf.default.forwarding=1 \
        --restart unless-stopped \
        ghcr.io/wg-easy/wg-easy:latest

     

    if docker ps | grep -q "wg-easy"; then
        echo "${BLUE_BG}${BLACK_FG}wg-easy container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}wg-easy container not found. Exiting...${RESET}"
        exit 1
    fi

    echo "Wireguard GUI: http://$WEB_ADDRESS/wireguard | Login: vpnadmin | Password: $PASSWORD" | sudo tee credentials.txt > /dev/null
}
