#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

validate_fqdn() {
    local fqdn="$1"
    
    # Check for the overall length of the FQDN
    if [[ ${#fqdn} -gt 253 ]]; then
        return 1
    fi

    # Check for invalid characters and labels
    if [[ ! "$fqdn" =~ ^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    
    # Check each label length
    IFS='.' read -ra labels <<< "$fqdn"
    for label in "${labels[@]}"; do
        if [[ ${#label} -gt 63 || ${#label} -lt 1 ]]; then
            return 1
        fi
    done
    
    # Ensure the FQDN does not start or end with a hyphen
    if [[ "$fqdn" =~ ^- || "$fqdn" =~ -$ ]]; then
        return 1
    fi

    return 0
}