#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

nginx_config_create() {
    sudo rm /etc/ssl/${WEB_ADDRESS}.crt
    sudo rm /etc/ssl/${WEB_ADDRESS}.key
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/${WEB_ADDRESS}.key -out /etc/ssl/${WEB_ADDRESS}.crt -subj "/CN=${WEB_ADDRESS}"

    curl -s -o /etc/nginx/sites-available/vpnadmin https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/nginx_config_vpnadmin.conf
    sudo sed -i "s/\$WEB_ADDRESS/$WEB_ADDRESS/g" /etc/nginx/sites-available/vpnadmin
    sudo ln -s /etc/nginx/sites-available/vpnadmin /etc/nginx/sites-enabled/
    sudo mkdir -vp /var/www/vpnadmin

    curl -s -o /var/www/vpnadmin/index.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/index.html

    sudo systemctl restart nginx
    
    certbot certonly --nginx --agree-tos --register-unsafely-without-email -d $WEB_ADDRESS -d www.$WEB_ADDRESS

    if [ -f "/etc/letsencrypt/live/$WEB_ADDRESS/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/$WEB_ADDRESS/privkey.pem" ]; then
        sudo rm /etc/ssl/${WEB_ADDRESS}.crt
        sudo rm /etc/ssl/${WEB_ADDRESS}.key
        ln -s /etc/letsencrypt/live/$WEB_ADDRESS/fullchain.pem /etc/ssl/${WEB_ADDRESS}.crt
        ln -s /etc/letsencrypt/live/$WEB_ADDRESS/privkey.pem /etc/ssl/${WEB_ADDRESS}.key
        echo "${BLUE_BG}${BLACK_FG}Let's Encrypt successfully issued for $WEB_ADDRESS !${RESET}"
    else
        echo "${BLUE_BG}${BLACK_FG}Let's Encrypt didn't succeed issuing for $WEB_ADDRESS . Using selfsigned certificate${RESET}"
    fi

    sudo systemctl restart nginx
}