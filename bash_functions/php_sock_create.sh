#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

php_sock_create() {
    PHP_VERSION=$(sudo php -v | head -n 1 | grep "PHP" | awk '{print $2}' | cut -c 1-3)

    sudo curl -s -o /etc/php/$PHP_VERSION/fpm/pool.d/$admin_name.conf https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/php-fpm_vpnadmin.conf
    sudo sed -i "s/\$admin_name/$admin_name/g" /etc/php/$PHP_VERSION/fpm/pool.d/$admin_name.conf

    sudo systemctl restart php$PHP_VERSION-fpm
}
