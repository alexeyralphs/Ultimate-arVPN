#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

wg_easy_install() {
    docker stop wg-easy 2> /dev/null
    docker rm wg-easy 2> /dev/null

    docker run -d --name=wg-easy \
    -e WG_HOST=$WEB_ADDRESS \
    -e PASSWORD_HASH="$(docker run --rm ghcr.io/wg-easy/wg-easy wgpw "$PASSWORD" | awk -F"'" '{print $2 ? $2 : $1}')" \
    -e WG_PORT=8080 \
    -e WG_DEFAULT_ADDRESS=10.0.0.x \
    -v /root/.wg-easy:/etc/wireguard \
    -p 8080:8080/udp \
    -p 8081:51821/tcp \
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

    while iptables -D FORWARD -p tcp --dport 51821 -j DROP 2>/dev/null; do
        echo "REMOVED iptables -I FORWARD -p tcp --dport 51821 -j DROP"
    done
    iptables -I FORWARD -p tcp --dport 51821 -j DROP
    echo "APPLIED iptables -I FORWARD -p tcp --dport 51821 -j DROP"

        sudo apt -o Dpkg::Options::="--force-confold" install ipset -y
    if command -v ipset &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}ipset installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}ipset not found, exiting..."
        exit 1
    fi
    ipset destroy vpn
    ipset create vpn hash:ip

    sudo apt -o Dpkg::Options::="--force-confold" install dnsmasq -y
    if command -v dnsmasq &>/dev/null; then
        echo "${BLUE_BG}${BLACK_FG}dnsmasq installed.${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}dnsmasq not found, exiting..."
        exit 1
    fi
    systemctl restart dnsmasq

    echo "Wireguard GUI: http://$WEB_ADDRESS/wireguard | Password: $PASSWORD" | sudo tee credentials.txt > /dev/null
}
