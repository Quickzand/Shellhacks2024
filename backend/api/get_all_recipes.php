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

    if ($_SERVER["REQUEST_METHOD"] == "GET") {
        $json = file_get_contents("php://input");
        $json = json_decode($json);

        $token = sanitize_input($json->token);
        $available = sanitize_input($json->available);

        $sql = "CALL get_all_recipes({$token}, {$available});";

        $result = $connection->query($sql);

        if ($result == false) {
            send_response(500, json_encode(["message" => "Server Error"]));
        }

        $json = [];

        $row = $result->fetch_assoc();

        if ($result->num_rows > 0) {            
            while ($row = $result->fetch_assoc()) {
                array_push($json, "Recipe" => $row["ID"]);
            }
        }

        send_response(200, $json);
    }

    send_response(400, "Invalid request method");