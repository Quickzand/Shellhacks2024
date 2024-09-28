<?php
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

    if ($_SERVER["REQUEST_METHOD"] == "GET") {
        $availableOnly = filter_input(INPUT_GET, "available_only");
        $availableOnly = sanitize_input($availableOnly);

        send_response(200, ["message" => "recipes go here"]);
    }

    send_response(400, ["message" => "Method not allowed."]);
?>