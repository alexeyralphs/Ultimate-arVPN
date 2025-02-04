<?php
	$keyFile = './outline_manager_key.php';
	$keyContent = file_get_contents($keyFile);
	$keyData = json_decode($keyContent, true);
	?>
<!DOCTYPE html>
<html>
	<head>
		<title>Outline Home</title>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="icon" type="image/svg+xml" href="images/outline-logo-short.svg" />
		<link rel="stylesheet" href="./styles.css">
	</head>
	<body>
		<div class="container">
			<div id="createNewClientPopup" class="popupWrapper" style="display: none;" onclick="closePopup(event)">
				<div class="popup">
					<h3>Create new client</h3>
					<input type="text" id="clientNameInput" class="input" placeholder="Enter name">
					<button class="button" id="createClientButton" disabled>Create</button>
				</div>
			</div>
			<div class="manageWrapper">
				<img src="images/outline_title.svg" alt="Outline Title" height="40">
				<button class="button logout" onclick="resetAuth()">
				<img src="images/logout_button.svg" alt="Logout Button" height="20">
				Logout
				</button>
			</div>
			<div class="wrapper">
				<div class="manageWrapper">
					<h1>Outline Manager key:</h1>
					<button class="button buttonDelete buttonRegenerate" onclick="createManagerKey()">Regenerate</button>
				</div>
				<button class="button buttonCode" onclick="copyToClipboard(jsonString)">
				<span id="jsonStringDisplay"></span>
				<img src="images/copy_button.svg" alt="Copy Button" height="20">
				</button>
			</div>
			<div class="listWrapper">
				<div class="titleWrapper">
					<p>Clients</p>
					<button class="button" onclick="showPopup()">+ New</button>
				</div>
				<ul class="list" id="clientsList">
				</ul>
			</div>
		</div>
		<script>
			const jsonString =  `<?php echo ($keyContent); ?>`;
		</script>
		<script src="outline_scripts.js"></script>
	</body>
</html>
