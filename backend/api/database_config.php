<?php
    $db_host = getenv("DB_HOST");
    $db_user = getenv("DB_USER");
    $db_pass = getenv("DB_PASS");
    $db_name = getenv("DB_NAME");

    $connection = new mysqli($db_host, $db_user, $db_pass, $db_name);

    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
    }

    echo "Connected Successfully";
?>