<?php
$configFile = '../outline_manager_key.php';
$config = json_decode(file_get_contents($configFile) , true);
$apiUrl = $config['apiUrl'];
$id = $_POST['id'];

if (!isset($id))
{
	die('ID клиента не указан.');
}

$deleteUrl = $apiUrl . '/access-keys/' . $id;
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $deleteUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($httpCode == 204)
{
	header("Location: /");
	exit;
}
else
{
	echo 'Ошибка при удалении клиента: ' . $response;
}
?>
