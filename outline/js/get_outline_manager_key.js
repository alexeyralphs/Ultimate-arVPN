<?php
	$keyFile = './outline_manager_key.php';
	$keyContent = file_get_contents($keyFile);
	$keyData = json_decode($keyContent, true);
	?>
    
const outline_manager_key =  `<?php echo ($keyContent); ?>`;
function get_outline_manager_key(current_outline_manager_key) {
    document.getElementById('outline_manager_key').textContent = current_outline_manager_key;
}