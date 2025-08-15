<?php

require 'db.php';

if (!empty($_POST['name'])) {
    $stmt = $db->prepare("INSERT INTO users (name) VALUES (?)");
    $stmt->execute([$_POST['name']]);
}

header("Location: index.php");
