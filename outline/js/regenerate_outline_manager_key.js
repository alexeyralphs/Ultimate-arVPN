function regenerate_outline_manager_key() {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', './scripts/regenerate_outline_manager_key.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                let response = JSON.parse(xhr.responseText);
                if (response.status === 'success') {
                    console.log('regenerate_outline_manager_key executed successfully!', response.output);
                    location.reload();
                } else {
                    console.error('regenerate_outline_manager_key error: ' + response.message);
                }
            } else {
                console.error('Error: ' + xhr.statusText);
            }
        }
    };
    xhr.send();
}