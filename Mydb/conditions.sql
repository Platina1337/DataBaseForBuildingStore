-- Условие используется в процедуре для добавления нового продукта с проверкой роли пользователя. Если пользователь не является продавцом, выдается ошибка. --
DELIMITER //

CREATE PROCEDURE AddProduct(
    IN p_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(10,2),
    IN p_stock INT,
    IN p_category_id INT,
    IN p_seller_id INT
)
BEGIN
    DECLARE user_role ENUM('customer', 'seller', 'admin');

    SELECT role INTO user_role
    FROM user
    WHERE user_id = p_seller_id;

    IF user_role = 'seller' THEN
        INSERT INTO product (name, description, price, stock, category_id, seller_id)
        VALUES (p_name, p_description, p_price, p_stock, p_category_id, p_seller_id);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only sellers can add products';
    END IF;
END //

DELIMITER ;