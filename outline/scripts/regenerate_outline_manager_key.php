<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST')
{
	$script_path = './regenerate_outline_manager_key.sh';
	$output = [];
	$return_var = 0;
	$log_file = './error_log.txt';

	exec("sh $script_path 2>&1", $output, $return_var);
	header('Content-Type: application/json; charset=utf-8');

	if ($return_var === 0)
	{
		echo json_encode(["status" => "success", "message" => "Script executed successfully!", "output" => $output, "current_directory" => getcwd() ]);
	}
	else
	{
		$error_message = "[" . date('Y-m-d H:i:s') . "] Script execution error: " . implode("\n", $output) . "\n";
		error_log($error_message, 3, $log_file);
		http_response_code(500);
		echo json_encode(["status" => "error", "message" => $error_message, "current_directory" => getcwd() ]);
	}
}
else
{
	$error_message = "[" . date('Y-m-d H:i:s') . "] Invalid request method.\n";
	error_log($error_message, 3, $log_file);
	http_response_code(405);
	echo json_encode(["status" => "error", "message" => $error_message, "current_directory" => getcwd() ]);
}
?>
