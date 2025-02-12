<?php
	$keyFile = './outline_manager_key.php';
	$keyContent = file_get_contents($keyFile);
	$keyData = json_decode($keyContent, true);
	echo $keyContent;
?>