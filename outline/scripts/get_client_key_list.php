<?php
$keyFile = '../outline_manager_key.php';
$keyContent = file_get_contents($keyFile);
$keyData = json_decode($keyContent, true);
$apiUrl = $keyData['apiUrl'];
$accessKeysUrl = $apiUrl . '/access-keys/';
$curl = curl_init();
curl_setopt_array($curl, [
	CURLOPT_URL => $accessKeysUrl,
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_SSL_VERIFYPEER => false,
	CURLOPT_SSL_VERIFYHOST => false
]);

$response = curl_exec($curl);
curl_close($curl);
$client_list = json_encode(json_decode($response, true), JSON_PRETTY_PRINT);
echo $client_list;
?>
