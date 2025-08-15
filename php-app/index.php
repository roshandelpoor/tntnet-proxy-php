<?php

require 'db.php';

$stmt = $db->query("SELECT * FROM users");
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>

<h1>User List</h1>
<ul>
    <?php foreach ($users as $u): ?>
        <li><?= htmlspecialchars($u['name']) ?>
            <a href="delete.php?id=<?= $u['id'] ?>">[Delete]</a>
        </li>
    <?php endforeach; ?>
</ul>
<form action="create.php" method="POST">
    <input name="name" placeholder="New user name">
    <button type="submit">Add</button>
</form>
