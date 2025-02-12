function get_outline_manager_key() {
    fetch('./scripts/get_outline_manager_key.php')
        .then(response => response.json())
        .then(data => {
            if (data && data.output) {
                document.getElementById('outline_manager_key').textContent = data.output;
            } else {
                console.error('Error: Manager key is null!');
            }
        })
        .catch(error => console.error('Error:', error));
}
