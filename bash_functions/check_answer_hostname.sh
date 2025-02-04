#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

check_answer_hostname() {
	if [ "$1" == "y" ] || [ "$1" == "n" ]; then
		return 0
	else
		return 1
	fi
}