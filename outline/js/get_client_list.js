async function get_client_list() {
    try {
        const response = await fetch('./scripts/get_client_key_list.php');

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        if (data.status === 'success' && data.output && Array.isArray(data.output.accessKeys)) {
            current_client_list = data.output.accessKeys; // Заполняем список клиентов
            render_client_list(); // Обновляем DOM с клиентами
        } else {
            console.error("Неверный формат данных:", data);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

get_client_list();
