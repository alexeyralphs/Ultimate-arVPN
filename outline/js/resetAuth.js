function resetAuth() {
	let xhr = new XMLHttpRequest();
	xhr.open('GET', `https://invalid:invalid@${host}/outline/`, true);
	xhr.onreadystatechange = function() {
		if (xhr.readyState === 4) {
			window.location.reload(true);
        }
        else {
            console.error('Error: ' + xhr.statusText);
		}
	};
	xhr.send();
}