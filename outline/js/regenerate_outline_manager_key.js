function regenerate_outline_manager_key() {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', './scripts/regenerate_outline_manager_key.php', true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    let response = JSON.parse(xhr.responseText);
                    if (response.status === 'success') {
                        console.log('regenerate_outline_manager_key executed successfully!', response.output);
                        location.reload();
                    } else {
                        console.error('regenerate_outline_manager_key error: ' + response.message);
                    }
                } catch (error) {
                    console.error('Failed to parse response JSON:', error);
                }
            } else {
                console.error('Error: ' + xhr.statusText);
            }
        }
    };
    
    xhr.send();
}