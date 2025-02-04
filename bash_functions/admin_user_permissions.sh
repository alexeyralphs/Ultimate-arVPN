#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

admin_user_permissions() {
    sudo chown -R vpnadmin:vpnadmin /var/www/vpnadmin
    sudo chmod -R 755 /var/www/vpnadmin
}