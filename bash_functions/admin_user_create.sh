#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

admin_user_create() {
    sudo htpasswd -c -b /etc/nginx/$admin_name.htpasswd $admin_name $PASSWORD
    sudo useradd -m $admin_name
    echo "$admin_name:$PASSWORD" | sudo chpasswd
    usermod -aG sudo $admin_name

    sudo sed -i '/^$admin_name /d' /etc/sudoers
    echo "$admin_name ALL=(ALL) NOPASSWD: /usr/bin/wget, /bin/bash, /bin/grep, /bin/rm, /usr/bin/tee, /bin/cat" | sudo tee -a /etc/sudoers
}
