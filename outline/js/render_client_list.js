let current_client_list = [];

function render_client_list() {
    const clientList = document.getElementById('client_list');
    const template = document.getElementById('client-template').content;

    while (clientList.firstChild) {
        clientList.removeChild(clientList.firstChild);
    }

    current_client_list.forEach(client => {
        const clone = document.importNode(template, true);
        clone.querySelector('.client-id').textContent = client.id;
        clone.querySelector('.client-name').textContent = client.name;

        const urlButton = clone.querySelector('.buttonCode');
        urlButton.querySelector('.client-url').textContent = client.accessUrl;

        urlButton.addEventListener('click', () => copyToClipboard(client.accessUrl));

        const deleteButton = clone.querySelector('.button_styled');
        deleteButton.addEventListener('click', () => deleteClient(client.id));

        clientList.appendChild(clone);
    });
}