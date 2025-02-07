#!/bin/sh

TEMP_OUTPUT="outline_install_output.txt"

WEB_ADDRESS=$(sudo cat /var/www/vpnadmin/outline/web-address.php)

wget -q --inet4-only https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh

if yes | sudo bash install_server.sh --hostname $WEB_ADDRESS --keys-port 8081 > "$TEMP_OUTPUT"; then
	OUTLINE_MANAGER_KEY=$(sudo cat "$TEMP_OUTPUT" | sed -E 's/\x1B\[[0-9;]*m//g' | grep -oP '{.*}')

	if [ -n "$OUTLINE_MANAGER_KEY" ]; then
		echo "Outline Manager key has been successfully extracted."
		echo "$OUTLINE_MANAGER_KEY" > ../outline_manager_key.php

		if [ $? -eq 0 ]; then
			echo "Outline Manager key has been successfully saved in ../outline_manager_key.php ."
		else
			echo "Error while saving Outline Manager key in ../outline_manager_key.php !" >&2
			exit 1
		fi
	else
		echo "Error while extracting Outline Manager key!" >&2
		exit 1
	fi

	sudo rm -f "$TEMP_OUTPUT"
	sudo rm -f install_server.sh
else
	echo "Error while installing Outline Server!" >&2
	exit 1
fi
