#!/bin/bash

BLUE_BG=$(tput setab 6)
GREEN_BG=$(tput setab 42)
BLACK_FG=$(tput setaf 0)
RESET=$(tput sgr0)

crontab_set() {
lines=(
"PATH=/usr/bin:/bin:/sbin:/usr/sbin"
"45 1 * * * apt update"
"0 2 * * * apt -o Dpkg::Options::=\"--force-confold\" upgrade -y"
"30 6 * * * date >> /var/log/le-renew.log"
"31 6 * * * certbot renew >> /var/log/le-renew.log"
"35 6 * * * systemctl reload nginx"
"45 5 chown -R $admin_name:$admin_name /var/www/$admin_name"
"50 5 chmod -R 755 /var/www/$admin_name"
)

current_cron="$(crontab -l 2>/dev/null || true)"

new_cron="$current_cron"

for line in "${lines[@]}"; do
  regex=$(echo "$line" | sed -E 's/([^a-zA-Z0-9])/\\\1/g' | sed 's/\\ /\\s+/g')
  echo "$current_cron" | grep -Pq "^$regex\$" || new_cron="${new_cron}"$'\n'"${line}"
done

if [[ "$new_cron" != "$current_cron" ]]; then
  echo "$new_cron" | crontab_do -
fi
}
