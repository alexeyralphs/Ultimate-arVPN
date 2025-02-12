const host = window.location.host;
document.addEventListener('DOMContentLoaded', function() {
	get_outline_manager_key(outline_manager_key);
	render_client_list();
	document.getElementById('clientNameInput').addEventListener('input', function(e) {
		document.getElementById('createClientButton').disabled = e.target.value === '';
	});
	document.getElementById('createClientButton').addEventListener('click', createNewClientHandler);
});

function copyToClipboard(text) {
	const unsecuredCopyToClipboard = (text) => {
		const textArea = document.createElement("textarea");
		textArea.value = text;
		document.body.appendChild(textArea);
		textArea.focus();
		textArea.select();
		try {
			document.execCommand('copy')
		} catch (err) {
			console.error('Unable to copy to clipboard', err)
		}
		document.body.removeChild(textArea)
	};
	if (window.isSecureContext && navigator.clipboard) {
		navigator.clipboard.writeText(text);
	} else {
		unsecuredCopyToClipboard(text);
	}
}

async function createClientKey(name) {
	return new Promise((resolve, reject) => {
		let xhr = new XMLHttpRequest();
		xhr.open('POST', './scripts/new_client_key.php', true);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4) {
				if (xhr.status === 200) {
					try {
						const response = JSON.parse(xhr.responseText);
						resolve(response);
					} catch (e) {
						console.error('Ошибка при парсинге JSON:', e);
						reject(e);
					}
				} else {
					alert('Ошибка при создании ключа.');
					reject(new Error('Ошибка при создании ключа.'));
				}
			}
		};
		xhr.send('name=' + encodeURIComponent(name));
	}).then(async () => {
		await get_client_list();
		render_client_list();
	}).catch(error => {
		console.error('Ошибка:', error);
	});
}

function showPopup() {
	document.getElementById('createNewClientPopup').style.display = 'flex';
}

function closePopup(e) {
	if (e.target === e.currentTarget) {
		document.getElementById('createNewClientPopup').style.display = 'none';
	}
}

async function createNewClientHandler() {
	const clientNameInput = document.getElementById('clientNameInput');
	await createClientKey(clientNameInput.value).then(() => {
		clientNameInput.value = '';
		document.getElementById('createNewClientPopup').style.display = 'none';
		render_client_list();
	});
}
async function deleteClient(id) {
	try {
		const params = new URLSearchParams();
		params.append('id', id);
		const response = await fetch('./scripts/remove_client.php', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded'
			},
			body: params.toString()
		});
		if (!response.ok) {
			throw new Error(`HTTP error! Status: ${response.status}`);
		}
		if (response.ok) {
			await get_client_list();
			render_client_list();
		}
	} catch (error) {
		console.error('Error:', error);
		throw error;
	}
}
