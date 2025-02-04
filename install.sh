#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

# apt_install_initial() {}
func_apt_install_initial=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/apt_install_initial.sh)
if [[ -z "$func_apt_install_initial" ]]; then
    echo "Error in func_apt_install_initial!" >&2
    exit 1
fi
source <(echo "$func_apt_install_initial")

# check_ipv4() {}
func_check_ipv4=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/check_ipv4.sh)
if [[ -z "$func_check_ipv4" ]]; then
    echo "Error in func_check_ipv4!" >&2
    exit 1
fi
source <(echo "$func_check_ipv4")

# check_answer_hostname() {}
func_check_answer_hostname=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/check_answer_hostname.sh)
if [[ -z "$func_check_answer_hostname" ]]; then
    echo "Error in func_check_answer_hostname!" >&2
    exit 1
fi
source <(echo "$func_check_answer_hostname")

# validate_fqdn() {}
func_validate_fqdn=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/validate_fqdn.sh)
if [[ -z "$func_validate_fqdn" ]]; then
    echo "Error in func_validate_fqdn!" >&2
    exit 1
fi
source <(echo "$func_validate_fqdn")


# set_web_address() {}
func_set_web_address=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/set_web_address.sh)
if [[ -z "$func_set_web_address" ]]; then
    echo "Error in func_set_web_address!" >&2
    exit 1
fi
source <(echo "$func_set_web_address")

# apt_install_requirements() {}
func_apt_install_requirements=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/apt_install_requirements.sh)
if [[ -z "$func_apt_install_requirements" ]]; then
    echo "Error in func_apt_install_requirements!" >&2
    exit 1
fi
source <(echo "$func_apt_install_requirements")

# apt_install_webserver() {}
func_apt_install_webserver=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/apt_install_webserver.sh)
if [[ -z "$func_apt_install_webserver" ]]; then
    echo "Error in func_apt_install_webserver!" >&2
    exit 1
fi
source <(echo "$func_apt_install_webserver")

# apt_install_docker() {}
func_apt_install_docker=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/apt_install_docker.sh)
if [[ -z "$func_apt_install_docker" ]]; then
    echo "Error in func_apt_install_docker!" >&2
    exit 1
fi
source <(echo "$func_apt_install_docker")


# password_generator() {}
func_password_generator=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/password_generator.sh)
if [[ -z "$func_password_generator" ]]; then
    echo "Error in func_password_generator!" >&2
    exit 1
fi
source <(echo "$func_password_generator")

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
