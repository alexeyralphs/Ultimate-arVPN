function get_outline_manager_key() {
    fetch('./scripts/get_outline_manager_key.php')
        .then(response => response.text())
        .then(data => {
            document.getElementById('outline_manager_key').textContent = data;
        })
        .catch(error => console.error('Error:', error));
}