<?php
$keyFile = '../outline_manager_key.php';

if (!file_exists($keyFile)) {
    echo json_encode([
        "status" => "error",
        "message" => "Manager key file does not exist.",
        "output" => ""
    ]);
} else {
    $keyContent = file_get_contents($keyFile);
    
    if ($keyContent === false) {
        echo json_encode([
            "status" => "error",
            "message" => "Error while reading manager key.",
            "output" => ""
        ]);
    } else {
        echo json_encode([
            "status" => "success",
            "message" => "",
            "output" => $keyContent
        ]);
    }
}
?>
