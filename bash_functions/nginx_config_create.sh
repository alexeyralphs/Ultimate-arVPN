#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

nginx_config_create() {
    curl -s -o /etc/nginx/sites-available/vpnadmin https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/nginx_config_vpnadmin.conf
    sudo sed -i "s/\$WEB_ADDRESS/$WEB_ADDRESS/g" /etc/nginx/sites-available/vpnadmin
    sudo ln -s /etc/nginx/sites-available/vpnadmin /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
    sudo mkdir -vp /var/www/vpnadmin
}