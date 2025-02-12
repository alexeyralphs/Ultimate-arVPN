const outline_manager_key =  `<?php echo ($keyContent); ?>`;
function get_outline_manager_key(outline_manager_key) {
    document.getElementById('current_outline_manager_key').textContent = outline_manager_key;
}