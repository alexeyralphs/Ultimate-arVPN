#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

sudo apt update

sudo apt -o Dpkg::Options::="--force-confold" upgrade -y

# outline_update() {}
func_outline_update=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/outline_update.sh)
if [[ -z "$func_outline_update" ]]; then
    echo "Error in func_outline_update!" >&2
    exit 1
fi
source <(echo "$func_outline_update")

# admin_user_permissions() {}
func_admin_user_permissions=$(curl -s https://raw.githubusercontent.com/alexeyralphs/Ultimate-arVPN/refs/heads/main/bash_functions/admin_user_permissions.sh)
if [[ -z "$func_admin_user_permissions" ]]; then
    echo "Error in func_admin_user_permissions!" >&2
    exit 1
fi
source <(echo "$func_admin_user_permissions")

outline_update

admin_user_permissions