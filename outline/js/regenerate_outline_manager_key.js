/*function regenerate_outline_manager_key() {
	let xhr = new XMLHttpRequest();
	xhr.open('POST', './scripts/regenerate_outline_manager_key.php', true);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.onreadystatechange = function() {
		if (xhr.readyState === 4) {
			if (xhr.status === 200) {
				location.reload();
			} else {
				console.error('Error: ' + xhr.statusText);
			}
		}
	};
	xhr.send();
}*/

function regenerate_outline_manager_key() {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', './scripts/regenerate_outline_manager_key.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                let response = JSON.parse(xhr.responseText);
                if (response.status === 'success') {
                    console.log('Script executed successfully!');
                } else {
                    console.error('Error: ' + response.message);
                }
            } else {
                console.error('Error: ' + xhr.statusText);
            }
        }
    };
    xhr.send();
}