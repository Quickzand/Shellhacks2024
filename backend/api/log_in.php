<?php
    include "../database_config.php";

    header('Content-Type: application/json');

    function send_response($status, $response) {
        http_response_code($status);
        die(json_encode($response));
    }

    function sanitize_input($data) {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        return $data;
    }

    $connection = getDbConnection();

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $json = file_get_contents("php://input");
        $json = json_decode($json);
        
        $email = sanitize_input($json->email);
        $password = sanitize_input($json->password);

        $sql = "CALL validate_user('{$email}', '{$password}');";

        $result = $connection->query($sql);
        
        if ($result == false) {
            send_response(500, "Server Error");
        }

        $row = $result->fetch_assoc();

        send_response($row["RESPONSE_STATUS"], ["Message" => "Success", "Token" => $row["TOKEN"]]);
    }

    send_response(400, "Invalid request method");