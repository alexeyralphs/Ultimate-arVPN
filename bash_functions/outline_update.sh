#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

outline_update() {
    sudo mkdir -vp /var/www/vpnadmin/outline/scripts
    sudo mkdir -vp /var/www/vpnadmin/outline/images
    sudo mkdir -vp /var/www/vpnadmin/outline/css
    sudo mkdir -vp /var/www/vpnadmin/outline/js

    curl -s -o /var/www/vpnadmin/outline/index.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/index.html
    curl -s -o /var/www/vpnadmin/outline/header.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/header.html
    curl -s -o /var/www/vpnadmin/outline/client_list.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/client_list.html
    curl -s -o /var/www/vpnadmin/outline/create_new_client_popup.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/create_new_client_popup.html

    curl -s -o /var/www/vpnadmin/outline/css/styles.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/styles.css
    curl -s -o /var/www/vpnadmin/outline/css/reset.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/reset.css
    curl -s -o /var/www/vpnadmin/outline/css/backgrounds.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/backgrounds.css
    curl -s -o /var/www/vpnadmin/outline/css/containers.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/containers.css
    curl -s -o /var/www/vpnadmin/outline/css/text.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/text.css
    curl -s -o /var/www/vpnadmin/outline/css/buttons.css https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/css/buttons.css

    curl -s -o /var/www/vpnadmin/outline/images/outline-logo-short.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline-logo-short.svg
    curl -s -o /var/www/vpnadmin/outline/images/logout_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/logout_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/logout_button_hover.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/logout_button_hover.svg
    curl -s -o /var/www/vpnadmin/outline/images/outline_title.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/images/outline_title.svg
    curl -s -o /var/www/vpnadmin/outline/images/copy_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/copy_button.svg
    curl -s -o /var/www/vpnadmin/outline/images/delete_button.svg https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/images/delete_button.svg

    curl -s -o /var/www/vpnadmin/outline/js/js.js https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/js/js.js
    curl -s -o /var/www/vpnadmin/outline/js/resetAuth.js https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/js/resetAuth.js
    curl -s -o /var/www/vpnadmin/outline/js/regenerate_outline_manager_key.js https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/js/regenerate_outline_manager_key.js

    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.sh https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/regenerate_outline_manager_key.sh

    curl -s -o /var/www/vpnadmin/outline/scripts/regenerate_outline_manager_key.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/regenerate_outline_manager_key.php
    curl -s -o /var/www/vpnadmin/outline/scripts/new_client_key.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/new_client_key.php
    curl -s -o /var/www/vpnadmin/outline/scripts/get_client_key_list.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/get_client_key_list.php
    curl -s -o /var/www/vpnadmin/outline/scripts/remove_client.php https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/outline/scripts/remove_client.php
}