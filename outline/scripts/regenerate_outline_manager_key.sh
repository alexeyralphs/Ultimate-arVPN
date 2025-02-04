#!/bin/sh

# Переменная для временного файла вывода
TEMP_OUTPUT="outline_manager_output.php"
# Устанавливаем Outline Server и перенаправляем вывод в временный файл
WEB_ADDRESS=$(sudo cat /var/www/vpnadmin/outline/web-address.php)
wget -q --inet4-only https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh
if yes | sudo bash install_server.sh --hostname $WEB_ADDRESS --keys-port 8081 >"$TEMP_OUTPUT"; then
	echo "Outline Server успешно установлен."

	# Извлекаем ключ для подключения к Outline Manager
	OUTLINE_MANAGER_KEY=$(sudo grep -oE '{"api.*"}' "$TEMP_OUTPUT")

	if [ -n "$OUTLINE_MANAGER_KEY" ]; then
		echo "Ключ успешно извлечен."

		# Кладем ключ в файл ../outline_manager_key.php
		sudo tee ../outline_manager_key.php >/dev/null <<EOF
        $OUTLINE_MANAGER_KEY
EOF

		if [ $? -eq 0 ]; then
			echo "Ключ успешно сохранен в ../outline_manager_key.php."
		else
			echo "Ошибка при сохранении ключа в файл." >&2
			exit 1
		fi
	else
		echo "Не удалось извлечь ключ из вывода скрипта." >&2
		exit 1
	fi

	# Удаляем временный файл
	sudo rm "$TEMP_OUTPUT"
	sudo rm install_server.sh -f
	if [ $? -eq 0 ]; then
		echo "Временный файл успешно удален."
	else
		echo "Ошибка при удалении временного файла." >&2
		exit 1
	fi
else
	echo "Ошибка при установке Outline Server." >&2
	exit 1
fi
