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
        
        $ingredients = $json->ingredients;

        $recipe = sanitize_input($json->recipe);
        $description = sanitize_input($json->description);
        $notes = sanitize_input($json->notes);
        $steps = sanitize_input($json->steps);

        $sql = "INSERT INTO RECIPES (RECIPE_NAME, RECIPE_DESCRIPTION, RECIPE_NOTES, RECIPE_STEPS) VALUES ('{$recipe}', '{$description}', '{$notes}', '{$steps}');";

        $result = $connection->query($sql);
        
        if ($result == false) {
            send_response(500, json_encode(["message" => "Server Error"]));
        }
        
        foreach ($ingredients as $i => $ingredient) {
            $sql = "SELECT COUNT(*) FROM ITEMS WHERE ITEM_NAME = '{$ingredient->name}'";
            
            $result = $connection->query($sql);
            
            if ($result == false) {
                send_response(500, ["Message" => "Server Error"]);
            }
            
            $count = 0;
            
            foreach ($result->fetch_assoc() as $a => $b) {
                $count = $b;
            }

            if ($count == 0) {
                $ingredientName = sanitize_input($ingredient->name);
                $ingredientUnit = sanitize_input($ingredient->unit);

                $sql = "INSERT INTO ITEMS (ITEM_NAME, AMOUNT, UNIT) VALUES ('{$ingredientName}', 0, {$ingredientUnit})";

                $result = $connection->query($sql);

                if ($result == false) {
                    send_response(500, ["Message" => "Server Error"]);
                }
            }

            $ingredientName = sanitize_input($ingredient->name);
            $ingredientAmount = sanitize_input($ingredient->amount);
            $ingredientUnit = sanitize_input($ingredient->unit);
            
            $sql = "INSERT INTO RECIPE_ITEMS (RECIPE_ID, ITEM_ID, AMOUNT, UNIT) 
                VALUES ((SELECT ID FROM RECIPES WHERE RECIPE_NAME = '{$recipe}'), (SELECT ID FROM ITEMS WHERE ITEM_NAME = '{$ingredientName}'), {$ingredientAmount}, {$ingredientUnit});";
                

            $result = $connection->query($sql);

            if ($result == false) {
                send_response(500, ["Message" => "Server Error"]);
            }
        }

        send_response(200, ["Message" => "Success"]);
    }

    send_response(400, "Invalid request method");