#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

check_ipv4() {
    IS_IPV4_AVAILABLE=$(curl -s -o /dev/null -w "%{http_code}\n" eth0.me)

    if [ "$IS_IPV4_AVAILABLE" == "000" ]; then
    	echo "${BLUE_BG}${BLACK_FG}IPv4 is not available. Exiting.${RESET}"
        exit 1
    else
        echo "${BLUE_BG}${BLACK_FG}IPv4 is available. Continuing.${RESET}"
	    MAIN_IP=$(curl -s eth0.me)
    fi
}