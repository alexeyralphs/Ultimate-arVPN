<?php
$script_path = './regenerate_outline_manager_key.sh';
$output = [];
$return_var = 0;

exec("sh $script_path 2>&1", $output, $return_var);
header('Content-Type: application/json; charset=utf-8');

if ($return_var === 0)
{
	echo json_encode([
		"status" => "success",
		"message" => "Script executed successfully!",
		"output" => $output
	], JSON_PRETTY_PRINT);
}
else
{
	$error_message = "[" . date('Y-m-d H:i:s') . "] Script execution error: " . implode("\n", $output) . "\n";
	http_response_code(500);
	echo json_encode([
		"status" => "error",
		"message" => $error_message,
		"output" => ""
	], JSON_PRETTY_PRINT);
}
?>
