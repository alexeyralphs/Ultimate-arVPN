async function get_client_list() {
    try {
        const response = await fetch('./scripts/get_client_key_list.php');
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        clients = data.accessKeys;
        populateClientsList();
    } catch (error) {
        console.error('Error:', error);
    }
}

get_client_list();