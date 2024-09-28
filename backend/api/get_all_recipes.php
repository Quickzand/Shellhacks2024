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
        $availableOnly = filter_input(INPUT_GET, "available_only");
        $availableOnly = sanitize_input($availableOnly);

        $sql;
        if ($availableOnly == "true") {
            $sql = "SELECT r.RECIPE_NAME, r.ID FROM RECIPES r
                    JOIN RECIPE_ITEMS ri ON r.ID = ri.ID
                    JOIN ITEMS i ON ri.ITEM_ID = i.ID
                    GROUP BY r.ID
                    HAVING 
                        COUNT(*) = SUM(
                            CASE 
                                WHEN i.AMOUNT >= ri.AMOUNT AND i.UNIT = ri.UNIT THEN 1
                                ELSE 0
                            END
                        );";
        } else {
            $sql = "SELECT * FROM RECIPES";
        }

        $result = $connection->query($sql);

        if ($result == false) {
            send_response(500, json_encode(["message" => "Server Error"]));
        }

        $json = [];

        if ($result->num_rows > 0) {            
            while ($row = $result->fetch_assoc()) {
                array_push($json, ["RecipeID" => $row["ID"], "RecipeName" => $row["RECIPE_NAME"]]);
            }
        }

        send_response(200, $json);
    }

    send_response(400, "Invalid request method");