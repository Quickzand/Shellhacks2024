<?php
    include "database_config.php";

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
        $recipe = filter_input(INPUT_GET, "recipe");
        $recipe = sanitize_input($recipe);

        $sql = "SELECT r.RECIPE_NAME, r.ID, i.ITEM_NAME, ri.AMOUNT, ri.UNIT FROM RECIPES r
                JOIN  RECIPE_ITEMS ri ON r.ID = ri.RECIPE_ID
                JOIN ITEMS i on ri.ITEM_ID = i.ID
                WHERE r.RECIPE_NAME = '" . $recipe . "';";

        $result = $connection->query($sql);

        if ($result == false) {
            send_response(500, json_encode(["message" => "Server Error"]));
        }

        $json = [];

        if ($result->num_rows > 0) {            
            while ($row = $result->fetch_assoc()) {
                array_push($json, ["itemID" => $row["ID"], "itemName" => $row["ITEM_NAME"], "amount" => $row["AMOUNT"], "unit" => $row["UNIT"]]);
            }
        }

        send_response(200, $json);
    }

    send_response(400, "Invalid request method");