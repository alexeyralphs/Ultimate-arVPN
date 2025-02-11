let client_list = [];

function populateClientsList() {
    const clientList = document.getElementById('client_list');
    const template = document.getElementById('client-template').content;

    clientList.innerHTML = ''; // Очищаем список перед обновлением

    client_list.forEach(client => {
        const clone = document.importNode(template, true);
        clone.querySelector('.client-id').textContent = client.id;
        clone.querySelector('.client-name').textContent = client.name;

        const urlButton = clone.querySelector('.buttonCode');
        urlButton.querySelector('.client-url').textContent = client.accessUrl;
        urlButton.setAttribute('onclick', `copyToClipboard('${client.accessUrl}')`);

        const deleteButton = clone.querySelector('.button_styled');
        deleteButton.setAttribute('onclick', `deleteClient(${client.id})`);

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
        if (data.status === 'success' && data.output && data.output.accessKeys) {
            client_list = data.output.accessKeys; // Заполняем список клиентов
            populateClientsList(); // Обновляем DOM с клиентами
        } else {
            console.error("Неверный формат данных:", data);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

// Инициализация получения списка клиентов
get_client_list();