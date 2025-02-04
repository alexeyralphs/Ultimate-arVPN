#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

set_web_address() {
    while true; do
        read -p "Do you want to be able to connect to the server using your own domain name? ${BLUE_BG}${BLACK_FG}For example: my-server.com${RESET}:
        (y/n) " ANSWER_HOSTNAME
        ANSWER_HOSTNAME=$(echo "$ANSWER_HOSTNAME" | tr -d ' ')

        if check_answer_hostname "$ANSWER_HOSTNAME"; then
            break
        else
            echo "Incorrect answer. Please enter '${BLUE_BG}${BLACK_FG}y${RESET}' or '${BLUE_BG}${BLACK_FG}n${RESET}'."
            sleep 1
        fi
    done

    if [ "$ANSWER_HOSTNAME" == "y" ]; then
        while true; do
            read -p "Enter the domain name you're going to use ${BLUE_BG}${BLACK_FG}(Don't forget to set $MAIN_IP as an A-Record value)${RESET}:
            ===> " NEW_HOSTNAME
            NEW_HOSTNAME=$(echo "$NEW_HOSTNAME" | tr -d ' ')

            if [ -n "$NEW_HOSTNAME" ] && validate_fqdn "$NEW_HOSTNAME"; then
                echo "Great, we'll use the ${BLUE_BG}${BLACK_FG}$NEW_HOSTNAME${RESET} domain name."
                WEB_ADDRESS="$NEW_HOSTNAME"
                break
            else
                echo "Hostname cannot be empty and must be a valid FQDN. Please enter a valid domain name. ${BLUE_BG}${BLACK_FG}For example: my-server.com${RESET}"
                sleep 1
            fi
        done
    elif [ "$ANSWER_HOSTNAME" == "n" ]; then
        echo "Okie, then we'll use the IP address ${BLUE_BG}${BLACK_FG}$MAIN_IP${RESET}."
        WEB_ADDRESS="$MAIN_IP"
    fi
}