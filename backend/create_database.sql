DROP TABLE IF EXISTS RECIPE_ITEMS;
DROP TABLE IF EXISTS GROCERY_LIST;
DROP TABLE IF EXISTS ITEMS;
DROP TABLE IF EXISTS RECIPES;
DROP TABLE IF EXISTS TOKENS;
DROP TABLE IF EXISTS USER_LOGIN;

DROP PROCEDURE IF EXISTS insert_new_user;
DROP PROCEDURE IF EXISTS validate_user;
DROP PROCEDURE IF EXISTS remove_item;
DROP PROCEDURE IF EXISTS get_all_items;
DROP PROCEDURE IF EXISTS add_to_groceries;
DROP PROCEDURE IF EXISTS remove_from_groceries;

CREATE TABLE USER_LOGIN(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    EMAIL VARCHAR(255) NOT NULL,
    PASS VARCHAR(255) NOT NULL,
    SALT VARCHAR(255) NOT NULL
);

CREATE TABLE TOKENS(
    ID INT NOT NULL PRIMARY KEY,
    TOKEN CHAR(255) NOT NULL,
    EXPIRATION_DATE TIMESTAMP NOT NULL,
    FOREIGN KEY (ID) REFERENCES USER_LOGIN(ID)
);

CREATE TABLE ITEMS(
    ID VARCHAR(255) AUTO_INCREMENT PRIMARY KEY,
    ITEM_NAME VARCHAR(255) NOT NULL,
    AMOUNT FLOAT NOT NULL,
    UNIT ENUM("tsp", "tbsp", "fl oz", "cup", "pint", "quart", "ounce", "lb"),
    USER_ID INT,
    FOREIGN KEY (USER_ID) REFERENCES USER_LOGIN(ID)
);

CREATE TABLE RECIPES(
    ID VARCHAR(255) AUTO_INCREMENT PRIMARY KEY,
    RECIPE_NAME VARCHAR(255) NOT NULL,
    RECIPE_DESCRIPTION TEXT,
    RECIPE_NOTES TEXT,
    RECIPE_STEPS TEXT,
    USER_ID INT,
    FOREIGN KEY (USER_ID) REFERENCES USER_LOGIN(ID)
);

CREATE TABLE RECIPE_ITEMS(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    RECIPE_ID INT,
    ITEM_ID INT,
    AMOUNT FLOAT NOT NULL,
    UNIT ENUM("tbsp", "tsp", "cup", "oz", "lb"),
    USER_ID INT,
    FOREIGN KEY (RECIPE_ID) REFERENCES RECIPES(ID),
    FOREIGN KEY (ITEM_ID) REFERENCES ITEMS(ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_LOGIN(ID)
);

CREATE TABLE GROCERY_LIST(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    AMOUNT FLOAT NOT NULL,
    UNIT ENUM("tbsp", "tsp", "cup", "oz", "lb"),
    ITEM_ID INT,
    USER_ID INT,
    FOREIGN KEY (ITEM_ID) REFERENCES ITEMS(ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_LOGIN(ID)
);

DELIMITER //
CREATE PROCEDURE insert_new_user(IN input_email VARCHAR(255), IN input_pass VARCHAR(255), IN input_random_bytes CHAR(64))
BEGIN
    DECLARE emailExists INT;
    DECLARE passLength INT;
    DECLARE tokenID CHAR(255);
    DECLARE userID INT;
    DECLARE salt VARCHAR(255);

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT,
        TOKEN CHAR(255)
    );

    SELECT COUNT(*) INTO emailExists FROM USER_LOGIN WHERE EMAIL = input_email;

    SELECT LENGTH(input_pass) INTO passLength;

    IF emailExists > 0 THEN
        INSERT INTO RESPONSE VALUES (400, NULL);
    ELSEIF passLength < 8 THEN
        INSERT INTO RESPONSE VALUES (400, NULL);
    ELSE
        SET salt = input_random_bytes;

        SET tokenID = UUID();

        INSERT INTO USER_LOGIN (EMAIL, PASS, SALT) VALUES (input_email, SHA2(CONCAT(input_pass, salt), 256), salt);

        SELECT ID INTO userID FROM USER_LOGIN WHERE EMAIL = input_email;
        INSERT INTO TOKENS (ID, TOKEN, EXPIRATION_DATE) VALUES (userID, tokenID, DATE_ADD(NOW(), INTERVAL 1 DAY));

        INSERT INTO RESPONSE VALUES (200, tokenID);
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE validate_user(IN input_email VARCHAR(255), IN input_pass VARCHAR(255))
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE userSalt VARCHAR(255);
    DECLARE tokenID CHAR(255);
    DECLARE hashedPass CHAR(255);

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT,
        TOKEN CHAR(255)
    );

    SELECT COUNT(*) INTO isValid FROM USER_LOGIN WHERE EMAIL = input_email;

    IF isValid = 0 THEN
        INSERT INTO RESPONSE VALUES (400, NULL);
    ELSE
        SELECT ID, SALT INTO userID, userSalt FROM USER_LOGIN WHERE EMAIL = input_email;
        SET hashedPass = SHA2(CONCAT(input_pass, userSalt), 256);   

        IF hashedPass != (SELECT PASS FROM USER_LOGIN WHERE ID = userID) THEN
            INSERT INTO RESPONSE VALUES (400, NULL);
        ELSE
            IF (SELECT COUNT(*) FROM TOKENS WHERE ID = userID AND EXPIRATION_DATE > NOW()) > 0 THEN
                SELECT TOKEN INTO tokenID FROM TOKENS WHERE ID = userID;
            ELSE
                INSERT INTO TOKENS (ID, TOKEN, EXPIRATION_DATE) VALUES (userID, tokenID, DATE_ADD(NOW(), INTERVAL 1 DAY));
            END IF;

            INSERT INTO RESPONSE VALUES (200, tokenID);
        END IF;
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_recipes(IN input_token CHAR(255), IN available_only INT)
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKEN WHERE TOKEN = input_token;

        INSERT INTO RESPONSE VALUES (200);
        SELECT * FROM RESPONSE;

        IF available_only = 0 THEN
            SELECT ID FROM RECIPES WHERE USER_ID = userID;
        ELSE
            SELECT r.ID FROM RECIPES r
            JOIN RECIPE_ITEMS ri ON r.ID = ri.ID
            JOIN ITEMS i ON ri.ITEM_ID = i.ID
            GROUP BY r.ID
            HAVING 
                COUNT(*) = SUM(
                    CASE 
                        WHEN i.AMOUNT >= ri.AMOUNT AND i.UNIT = ri.UNIT THEN 1
                        ELSE 0
                    END
                );
        END
    ELSE
        INSERT INTO RESPONSE VALUES (400);
        SELECT * FROM RESPONSE;
    END IF;

    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_recipe(IN input_token CHAR(255), IN input_recipe_id VARCHAR(255))
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE recipeName VARCHAR(255);
    DECLARE recipeDescription TEXT;
    DECLARE recipeNotes TEXT;
    DECLARE recipeSteps TEXT;

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token;

        SELECT COUNT(*) INTO isValid FROM RECIPES WHERE RECIPE_ID = input_recipe_id AND USER_ID = userID;

        IF isValid > 0 THEN
            SELECT RECIPE_NAME INTO recipeName FROM RECIPES WHERE RECIPE_ID = input_recipe_id AND USER_ID = userID;

            INSERT INTO RESPONSE VALUES (200);

            SELECT * FROM RESPONSE;
            SELECT RECIPE_NAME, RECIPE_DESCRIPTION, RECIPE_NOTES, RECIPE_STEPS FROM RECIPES WHERE ID = input_recipe_id AND USER_ID = userID;
            SELECT ITEM_NAME, AMOUNT, UNIT FROM RECIPE_ITEMS WHERE RECIPE_ID = input_recipe_id AND USER_ID = userID;
        ELSE
            INSERT INTO RESPONSE VALUES (400);
            SELECT * FROM RESPONSE;
        END IF;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
        SELECT * FROM RESPONSE;
    END IF;

    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_item(IN input_token CHAR(255), IN input_item_id VARCHAR(255), IN input_item_name VARCHAR(255), IN input_amount FLOAT, IN input_unit)
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE itemExists INT;
    DECLARE oldAmount FLOAT;
    DECLARE newAmount FLOAT;

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();
    
    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token;

        SELECT COUNT(*) INTO itemExists FROM ITEMS WHERE ID = input_item_id AND USER_ID = userID;

        IF itemExists > 0 THEN
            SELECT AMOUNT INTO oldAmount FROM ITEMS WHERE ID = input_item_id AND USER_ID = userID;
            SET newAmount = oldAmount + input_amount;

            UPDATE ITEMS SET AMOUNT = newAmount WHERE ID = input_item_id AND USER_ID = userID;
        ELSE
            INSERT INTO ITEMS (ID, ITEM_NAME, AMOUNT, UNIT, USER_ID) VALUES (input_item_id, input_item_name, input_amount, input_unit, userID);
        END IF;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
    END IF;

    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE remove_item(IN input_token CHAR(255), IN input_item_id VARCHAR(255), IN input_amount FLOAT)
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE oldAmount FLOAT;
    DECLARE newAmount FLOAT;

    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token;

        SELECT COUNT(*) INTO isValid FROM ITEMS WHERE ID = input_item_id AND USER_ID = userID;

        SELECT AMOUNT into oldAmount FROM ITEMS WHERE ID = input_item_id;

        SET newAmount = GREATEST(oldAmount - input_amount, 0);

        IF isValid > 0 THEN
            UPDATE ITEMS SET AMOUNT = newAmount WHERE ID = input_item_id AND USER_ID = userID;

            INSERT INTO RESPONSE VALUES (200);
        ELSE
            INSERT INTO RESPONSE VALUES (400);
        END IF;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_items(IN input_token CHAR(255))
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;

    CREATE TEMPORARY TABLE RESPONSE(
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF (isValid > 0) THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();
        SELECT * FROM ITEMS WHERE USER_ID = userID;
        DROP TEMPORARY TABLE RESPONSE;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
        SELECT * FROM RESPONSE;
        DROP TEMPORARY TABLE RESPONSE;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_to_groceries(IN input_token CHAR(255), IN input_item_id VARCHAR(255), IN input_amount INT)
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE itemUnit ENUM("tsp", "tbsp", "fl oz", "cup", "pint", "quart", "ounce", "lb");

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token;
        SELECT COUNT(*) INTO isValid FROM ITEMS WHERE ID = input_item_id AND USER_ID = userID;

        IF isValid > 0 THEN
            SELECT UNIT INTO itemUnit FROM ITEMS WHERE ID = input_item_id AND USER_ID = userID;

            INSERT INTO GROCERY_LIST (ITEM_ID, AMOUNT, UNIT, USER_ID) VALUES (input_item_id, input_amount, itemUnit, userID);

            INSERT INTO RESPONSE VALUES (200);
        ELSE
            INSERT INTO RESPONSE VALUES (400);
        END IF;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE remove_from_groceries(IN input_token CHAR(255), IN input_item_id VARCHAR(255))
BEGIN
    DECLARE isValid INT;
    DECLARE userID INT;
    DECLARE itemUnit ENUM("tsp", "tbsp", "fl oz", "cup", "pint", "quart", "ounce", "lb");

    CREATE TEMPORARY TABLE RESPONSE (
        RESPONSE_STATUS INT
    );

    SELECT COUNT(*) INTO isValid FROM TOKENS WHERE TOKEN = input_token AND EXPIRATION_DATE > NOW();

    IF isValid > 0 THEN
        SELECT ID INTO userID FROM TOKENS WHERE TOKEN = input_token;
        SELECT COUNT(*) INTO isValid FROM GROCERY_LIST WHERE ID = input_item_id AND USER_ID = userID;

        IF isValid > 0 THEN
            DELETE FROM GROCERY_LIST WHERE ID = input_item_id AND USER_ID = userID;

            INSERT INTO RESPONSE VALUES (200);
        ELSE
            INSERT INTO RESPONSE VALUES (400);
        END IF;
    ELSE
        INSERT INTO RESPONSE VALUES (400);
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

-- Testing time wooooo
insert into RECIPES (RECIPE_NAME) values ("Pasta");
insert into RECIPES (RECIPE_NAME) values ("Pizza");

insert into ITEMS (ITEM_NAME, AMOUNT, UNIT) values ("Pepperoni", 12, 4);

insert into RECIPE_ITEMS (RECIPE_ID, ITEM_ID, AMOUNT, UNIT) values (2, 1, 2, 4);