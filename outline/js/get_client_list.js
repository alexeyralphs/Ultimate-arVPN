let current_client_list = [];

function populateClientsList() {
    const clientList = document.getElementById('client_list');
    const template = document.getElementById('client-template').content;

    // Очищаем список перед обновлением
    while (clientList.firstChild) {
        clientList.removeChild(clientList.firstChild);
    }

    current_client_list.forEach(client => {
        const clone = document.importNode(template, true);
        clone.querySelector('.client-id').textContent = client.id;
        clone.querySelector('.client-name').textContent = client.name;

        const urlButton = clone.querySelector('.buttonCode');
        urlButton.querySelector('.client-url').textContent = client.accessUrl;

        // Добавляем обработчик события
        urlButton.addEventListener('click', () => copyToClipboard(client.accessUrl));

        const deleteButton = clone.querySelector('.button_styled');
        deleteButton.addEventListener('click', () => deleteClient(client.id));

        clientList.appendChild(clone);
    });
}

async function get_client_list() {
    try {
        const response = await fetch('./scripts/get_client_key_list.php');

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        if (data.status === 'success' && data.output && Array.isArray(data.output.accessKeys)) {
            current_client_list = data.output.accessKeys; // Заполняем список клиентов
            populateClientsList(); // Обновляем DOM с клиентами
        } else {
            console.error("Неверный формат данных:", data);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

get_client_list();
