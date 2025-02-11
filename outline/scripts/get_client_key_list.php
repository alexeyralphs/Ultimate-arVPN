<?php
header('Content-Type: application/json; charset=utf-8');

$keyFile = '../outline_manager_key.php';
$keyContent = @file_get_contents($keyFile);
$keyData = json_decode($keyContent, true);

if (!$keyContent || !isset($keyData['apiUrl'])) {
    http_response_code(500);
    die(json_encode([
		"status" => "error",
		"message" => "[" . date('Y-m-d H:i:s') . "] Error while reading manager key!",
		"output" => ""
	], JSON_PRETTY_PRINT));
}

$apiUrl = $keyData['apiUrl'];
$accessKeysUrl = $apiUrl . '/access-keys/';

$curl = curl_init();
curl_setopt_array($curl, [
    CURLOPT_URL => $accessKeysUrl,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_SSL_VERIFYHOST => 2,
	CURLOPT_VERBOSE => true,
    CURLOPT_STDERR => fopen('php://stderr', 'w'),
]);

$response = curl_exec($curl);
$httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
curl_close($curl);

if ($response === false || $httpCode !== 200) {
    http_response_code(500);
    die(json_encode([
		"status" => "error",
		"message" => "[" . date('Y-m-d H:i:s') . "] Error while connecting to manager API!",
		"output" => ""
	], JSON_PRETTY_PRINT));
}

echo json_encode([
	"status" => "success",
	"message" => "",
	"output" => json_decode($response, true)
], JSON_PRETTY_PRINT);
?>

