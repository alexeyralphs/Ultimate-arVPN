#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

admin_user_create() {
    sudo htpasswd -c -b /etc/nginx/vpnadmin.htpasswd vpnadmin $PASSWORD
    sudo useradd -m vpnadmin
    echo "vpnadmin:$PASSWORD" | sudo chpasswd
    usermod -aG sudo vpnadmin

    sudo sed -i '/^vpnadmin /d' /etc/sudoers
    echo "vpnadmin ALL=(ALL) NOPASSWD: /usr/bin/wget, /bin/bash, /bin/grep, /bin/rm, /usr/bin/tee, /bin/cat" | sudo tee -a /etc/sudoers
}