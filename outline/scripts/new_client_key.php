<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['name']))
{
	$name = htmlspecialchars($_POST['name']);
	$configContent = file_get_contents('../outline_manager_key.php');
	$jsonStart = strpos($configContent, '{');
	$jsonEnd = strrpos($configContent, '}') + 1;
	$jsonString = substr($configContent, $jsonStart, $jsonEnd - $jsonStart);
	$config = json_decode($jsonString, true);
	$apiUrl = $config['apiUrl'];

	$data = json_encode(['method' => 'aes-192-gcm', 'name' => $name]);
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $apiUrl . '/access-keys');
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

	$response = curl_exec($ch);
	curl_close($ch);

	echo $response;
}
else
{
	echo json_encode(['error' => 'Invalid request']);
}
?>
