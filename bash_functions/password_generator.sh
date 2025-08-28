#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

password_generator() {
    SYMBOLS=""

    for SYMBOL in {A..Z} {a..z} {0..9}
        do SYMBOLS=$SYMBOLS$SYMBOL
    done

    SYMBOLS=$SYMBOLS'@#%*()?/\[]{}-+_=<>.'

    PWD_LENGTH=16
    PASSWORD=""
    RANDOM=256

    for i in `seq 1 $PWD_LENGTH`
        do PASSWORD=$PASSWORD${SYMBOLS:$(expr $RANDOM % ${#SYMBOLS}):1}
    done
}
