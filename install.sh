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

check_ipv4() {
    IS_IPV4_AVAILABLE=$(curl -s -o /dev/null -w "%{http_code}\n" eth0.me)

    if [ "$IS_IPV4_AVAILABLE" == "000" ]; then
    	echo "${BLUE_BG}${BLACK_FG}IPv4 is not available. Exiting.${RESET}"
        exit 1
    else
        echo "${BLUE_BG}${BLACK_FG}IPv4 is available. Continuing.${RESET}"
	    MAIN_IP=$(curl -s eth0.me)
    fi
}

check_answer_hostname() {
	if [ "$1" == "y" ] || [ "$1" == "n" ]; then
		return 0
	else
		return 1
	fi
}

validate_fqdn() {
    local fqdn="$1"
    
    # Check for the overall length of the FQDN
    if [[ ${#fqdn} -gt 253 ]]; then
        return 1
    fi

    # Check for invalid characters and labels
    if [[ ! "$fqdn" =~ ^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    
    # Check each label length
    IFS='.' read -ra labels <<< "$fqdn"
    for label in "${labels[@]}"; do
        if [[ ${#label} -gt 63 || ${#label} -lt 1 ]]; then
            return 1
        fi
    done
    
    # Ensure the FQDN does not start or end with a hyphen
    if [[ "$fqdn" =~ ^- || "$fqdn" =~ -$ ]]; then
        return 1
    fi

    return 0
}

set_web_address() {
    while true; do
        read -p "Do you want to be able to connect to the server using your own domain name? ${BLUE_BG}${BLACK_FG}For example: my-server.com${RESET}:
        (y/n) " ANSWER_HOSTNAME
        ANSWER_HOSTNAME=$(echo "$ANSWER_HOSTNAME" | tr -d ' ')

        if check_answer_hostname "$ANSWER_HOSTNAME"; then
            break
        else
            echo "Incorrect answer. Please enter '${BLUE_BG}${BLACK_FG}y${RESET}' or '${BLUE_BG}${BLACK_FG}n${RESET}'."
            sleep 1
        fi
    done

    if [ "$ANSWER_HOSTNAME" == "y" ]; then
        while true; do
            read -p "Enter the domain name you're going to use ${BLUE_BG}${BLACK_FG}(Don't forget to set $MAIN_IP as an A-Record value)${RESET}:
            ===> " NEW_HOSTNAME
            NEW_HOSTNAME=$(echo "$NEW_HOSTNAME" | tr -d ' ')

            if [ -n "$NEW_HOSTNAME" ] && validate_fqdn "$NEW_HOSTNAME"; then
                echo "Great, we'll use the ${BLUE_BG}${BLACK_FG}$NEW_HOSTNAME${RESET} domain name."
                WEB_ADDRESS="$NEW_HOSTNAME"
                break
            else
                echo "Hostname cannot be empty and must be a valid FQDN. Please enter a valid domain name. ${BLUE_BG}${BLACK_FG}For example: my-server.com${RESET}"
                sleep 1
            fi
        done
    elif [ "$ANSWER_HOSTNAME" == "n" ]; then
        echo "Okie, then we'll use the IP address ${BLUE_BG}${BLACK_FG}$MAIN_IP${RESET}."
        WEB_ADDRESS="$MAIN_IP"
    fi
}

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

password_generator() {
    SYMBOLS=""

    for SYMBOL in {A..Z} {a..z} {0..9}
        do SYMBOLS=$SYMBOLS$SYMBOL
    done

    SYMBOLS=$SYMBOLS'!@#$%&*()?/\[]{}-+_=<>.,'

    PWD_LENGTH=16
    PASSWORD=""
    RANDOM=256

    for i in `seq 1 $PWD_LENGTH`
        do PASSWORD=$PASSWORD${SYMBOLS:$(expr $RANDOM % ${#SYMBOLS}):1}
    done
}

admin_user_create() {
    sudo htpasswd -c -b /etc/nginx/vpnadmin.htpasswd vpnadmin $PASSWORD
    sudo useradd -m vpnadmin
    echo "vpnadmin:$PASSWORD" | sudo chpasswd
    usermod -aG sudo vpnadmin

    sudo sed -i '/^vpnadmin /d' /etc/sudoers
    echo "vpnadmin ALL=(ALL) NOPASSWD: /usr/bin/wget, /bin/bash, /bin/grep, /bin/rm, /usr/bin/tee, /bin/cat" | sudo tee -a /etc/sudoers
}

php_sock_create() {
    PHP_VERSION=$(sudo php -v | head -n 1 | grep "PHP" | awk '{print $2}' | cut -c 1-3)

    sudo curl -s -o /etc/php/$PHP_VERSION/fpm/pool.d/vpnadmin.conf https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/php-fpm_vpnadmin.conf

    sudo systemctl restart php$PHP_VERSION-fpm
}

nginx_config_create() {
    curl -s -o /etc/nginx/sites-available/vpnadmin https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/nginx_config_vpnadmin.conf
    sudo sed -i "s/\$WEB_ADDRESS/$WEB_ADDRESS/g" /etc/nginx/sites-available/vpnadmin
    sudo ln -s /etc/nginx/sites-available/vpnadmin /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
    sudo mkdir -vp /var/www/vpnadmin
}

wg-easy_install() {
    docker stop wg-easy 2> /dev/null
    docker rm wg-easy 2> /dev/null
    docker run -d \
    	--name=wg-easy \
    	-e WG_HOST=$WEB_ADDRESS \
        -e WG_PORT=8080 \
    	-e WG_DEFAULT_ADDRESS=10.0.0.x \
    	-v ~/.wg-easy:/etc/wireguard \
        -p 8080:51820/udp \
    	-p 51821:51821/tcp \
    	--cap-add=NET_ADMIN \
    	--cap-add=SYS_MODULE \
    	--sysctl="net.ipv4.conf.all.src_valid_mark=1" \
    	--sysctl="net.ipv4.ip_forward=1" \
    	--restart unless-stopped \
    	weejewel/wg-easy

    if docker ps | grep -q "wg-easy"; then
        echo "${BLUE_BG}${BLACK_FG}wg-easy container is running. Continuing...${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}wg-easy container not found. Exiting...${RESET}"
        exit 1
    fi

    echo "Wireguard GUI: http://$WEB_ADDRESS:8181/wireguard | Login: vpnadmin | Password: $PASSWORD" | sudo tee -a credentials.txt > /dev/null
}

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

    sudo echo $OUTLINE_MANAGER_KEY > /var/www/vpnadmin/outline/outline_manager_key.php
    sudo echo $WEB_ADDRESS > /var/www/vpnadmin/outline/web-address.php

    curl -s -o /var/www/vpnadmin/outline/images/outline-logo-short.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline-logo-short.svg
    curl -s -o /var/www/vpnadmin/outline/styles.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/styles.css
    curl -s -o /var/www/vpnadmin/outline/images/logout_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/logout_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/outline_title.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline_title.svg
    curl -s -o /var/www/vpnadmin/outline/images/copy_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/copy_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/delete_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/delete_button.svg
    curl -s -o /var/www/vpnadmin/outline/outline_scripts.js https://it.alexeyralphs.com/ultimate_arvpn/downloads/outline/outline_scripts_js.txt
    curl -s -o /var/www/vpnadmin/outline/index.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/index.html
    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.php https://it.alexeyralphs.com/ultimate_arvpn/downloads/outline/regenerate_outline_manager_key_php.txt
    curl -s -o /var/www/vpnadmin/outline/scripts/new_client_key.php https://it.alexeyralphs.com/ultimate_arvpn/downloads/outline/new_client_key_php.txt
    curl -s -o /var/www/vpnadmin/outline/scripts/get_client_key_list.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/get_client_key_list.php
    curl -s -o /var/www/vpnadmin/outline/scripts/remove_client.php https://it.alexeyralphs.com/ultimate_arvpn/downloads/outline/remove_client_php.txt
    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.sh https://it.alexeyralphs.com/ultimate_arvpn/downloads/outline/regenerate_outline_manager_key_sh.txt  
}

admin_user_permissions() {
    sudo chown -R vpnadmin:vpnadmin /var/www/vpnadmin
    sudo chmod -R 755 /var/www/vpnadmin
}

apt_install_initial

check_ipv4

set_web_address

echo "${BLUE_BG}${BLACK_FG}Getting ready...${RESET}"

sleep 3

apt_install_requirements

apt_install_webserver

apt_install_docker

password_generator

admin_user_create

php_sock_create

nginx_config_create

wg-easy_install

outline_install

admin_user_permissions

echo "---
---
---
---
---"
echo "${BLUE_BG}${BLACK_FG}Wireguard GUI:${RESET} http://$WEB_ADDRESS:8181/wireguard | ${BLUE_BG}${BLACK_FG}Login:${RESET} vpnadmin | ${BLUE_BG}${BLACK_FG}Password:${RESET} $PASSWORD"
echo "${BLUE_BG}${BLACK_FG}Outline Web-GUI:${RESET} http://$WEB_ADDRESS:8181/outline | ${BLUE_BG}${BLACK_FG}Login:${RESET} vpnadmin | ${BLUE_BG}${BLACK_FG}Password:${RESET} $PASSWORD"
