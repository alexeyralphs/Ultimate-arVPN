#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

admin_user_permissions() {
    sudo chown -R $admin_name:$admin_name /var/www/$admin_name
    sudo chmod -R 755 /var/www/$admin_name
}
