#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

sudo apt update

sudo apt -o Dpkg::Options::="--force-confold" upgrade -y