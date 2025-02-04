<?php
$keyFile = '../outline_manager_key.php';
$keyContent = file_get_contents($keyFile);
$keyData = json_decode($keyContent, true);
$apiUrl = $keyData['apiUrl'];
$accessKeysUrl = $apiUrl . '/access-keys/';
$curl = curl_init();
curl_setopt_array($curl, [CURLOPT_URL => $accessKeysUrl, CURLOPT_RETURNTRANSFER => true, CURLOPT_SSL_VERIFYPEER => false, CURLOPT_SSL_VERIFYHOST => false]);

$response = curl_exec($curl);
curl_close($curl);
$responseData = json_decode($response, true);

$formattedData = '';
foreach ($responseData['accessKeys'] as $key)
{
	$formattedData .= $key['id'] . ' | ' . $key['name'] . ' | ' . $key['accessUrl'] . "\n";
}

$outputFile = './client_key_list.php';
file_put_contents($outputFile, $formattedData);

if (php_sapi_name() === 'cli')
{
	echo 'Keys saved to ' . $outputFile . "\n";
}

echo json_encode($responseData);
?>
