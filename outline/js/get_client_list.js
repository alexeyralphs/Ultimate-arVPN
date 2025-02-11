async function get_client_list() {
	return fetch('./scripts/get_client_key_list.php').then((response) => response.json()).then((data) => {
		clients = data.accessKeys;
		populateClientsList();
	}).catch((error) => {
		console.error('Error:', error);
	});
}
get_client_list();