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
        
        $name = sanitize_input($json->name);
        $amount = sanitize_input($json->amount);
        $unit = sanitize_input($json->unit);

        $sql = "SELECT COUNT(*) FROM ITEMS WHERE ITEM_NAME = '{$name}';";

        $result = $connection->query($sql);
        
        if ($result == false) {
            send_response(500, "Server Error");
        }

        $count = 0;
            
        foreach ($result->fetch_assoc() as $a => $b) {
            $count = $b;
        }
        
        if ($count == 0) {
            $sql = "INSERT INTO ITEMS (ITEM_NAME, AMOUNT, UNIT) VALUES ('{$name}', {$amount}, ${unit});";
            
            $result = $connection->query($sql);

            if ($result == false) {
                send_response(500, "Server Error");
            }

        } else {
            $sql = "SELECT AMOUNT FROM ITEMS WHERE ITEM_NAME = '{$name}';";

            $result = $connection->query($sql);
            
            if ($result == false) {
                send_response(500, "Server Error");
            }

            $oldAmount = $result->fetch_assoc()["AMOUNT"];
            $newAmount = $oldAmount + $amount;

            $sql = "UPDATE ITEMS SET AMOUNT = {$newAmount} WHERE ITEM_NAME = '{$name}';";
            
            $result = $connection->query($sql);

            if ($result == false) {
                send_response(500, "Server Error");
            }
        }

        send_response(200, ["Message" => "Success"]);
    }

    send_response(400, "Invalid request method");