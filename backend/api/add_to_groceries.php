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
        
        $itemID = sanitize_input($json->itemID);
        $token = sanitize_input($json->token);
        $amount = sanitize_input($json->amount);

        $sql = "CALL add_to_groceries('${token}', ${itemID}, ${amount});";

        $result = $connection->query($sql);
        
        if ($result == false) {
            send_response(500, "Server Error");
        }

        $row = $result->fetch_assoc();

        send_response($row["RESPONSE_STATUS"], ["Message" => "Success"]);
    }

    send_response(400, "Invalid request method");