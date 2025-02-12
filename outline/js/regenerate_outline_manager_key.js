function regenerate_outline_manager_key() {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', './scripts/regenerate_outline_manager_key.php', true);

    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                let response = JSON.parse(xhr.responseText);
                if (response.status === 'success') {
                    console.log('regenerate_outline_manager_key executed successfully!', response.output);
                    get_outline_manager_key(current_outline_manager_key);
                } else {
                    console.error('regenerate_outline_manager_key error: ' + response.message);
                }
            } catch (error) {
                console.error('Failed to parse response JSON:', error);
            }
        } else {
            console.error('Request failed with status:', xhr.status);
        }
    };

    xhr.onerror = function() {
        console.error('Request error:', xhr.status, xhr.statusText);
    };

    xhr.send();
}
