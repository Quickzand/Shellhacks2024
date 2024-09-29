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
        $recipe = sanitize_input($json->recipe);

        $sql = "CALL get_recipe({$token}, {$recipe});";

        $result = $connection->query($sql);

        if ($result == false) {
            send_response(500, json_encode(["message" => "Server Error"]));
        }

        $json = [];

        $row = $result->fetch_assoc();

        $row = $result->fetch_assoc();
        array_push($json, ["Name" => $row["RECIPE_NAME"], "Description" => $row["RECIPE_DESCRIPTION"], "Notes" => $row["RECIPE_NOTES"], "Steps" => $row["RECIPE_STEPS"]]);


        if ($result->num_rows > 0) {            
            while ($row = $result->fetch_assoc()) {
                array_push($json, ["Name" => $row["ITEM_NAME"], "Amount" => $row["AMOUNT"], "Unit" => $row["UNIT"], "Steps" => $row["RECIPE_STEPS"]]);
            }
        }

        send_response(200, $json);
    }

    send_response(400, "Invalid request method");