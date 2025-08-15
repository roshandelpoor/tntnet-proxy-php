<?php

require 'db.php';

if (isset($_GET['id'])) {
    $stmt = $db->prepare("DELETE FROM users WHERE id = ?");
    $stmt->execute([$_GET['id']]);
}

header("Location: index.php");
