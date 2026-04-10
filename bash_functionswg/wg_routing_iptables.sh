#!/bin/bash

while iptables -D FORWARD -p tcp --dport 51821 -j DROP 2>/dev/null; do
  echo "REMOVED iptables -I FORWARD -p tcp --dport 51821 -j DROP"
done
iptables -I FORWARD -p tcp --dport 51821 -j DROP
echo "APPLIED iptables -I FORWARD -p tcp --dport 51821 -j DROP"

while iptables -t mangle -D OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1 2>/dev/null; do
  echo "REMOVED iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1"
done
iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1
echo "APPLIED iptables -t mangle -A OUTPUT -m set --match-set vpn dst -j MARK --set-mark 1"
