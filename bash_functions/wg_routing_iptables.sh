#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

wg_routing_iptables() {
  while iptables -D FORWARD -p tcp --dport 51821 -j DROP 2>/dev/null; do
    echo "${BLUE_BG}${BLACK_FG}REMOVED iptables -I FORWARD -p tcp --dport 51821 -j DROP${RESET}"
  done
  iptables -I FORWARD -p tcp --dport 51821 -j DROP
  echo "${BLUE_BG}${BLACK_FG}APPLIED iptables -I FORWARD -p tcp --dport 51821 -j DROP${RESET}"

  while iptables -t mangle -D OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1 2>/dev/null; do
    echo "${BLUE_BG}${BLACK_FG}REMOVED iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1${RESET}"
  done
  iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1
  echo "${BLUE_BG}${BLACK_FG}APPLIED iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1${RESET}"
}
