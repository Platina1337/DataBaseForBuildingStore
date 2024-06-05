-- Процедура для получения деталей заказа по его идентификатору. --
DELIMITER //

CREATE PROCEDURE GetOrderDetails(IN orderId INT)
BEGIN
    SELECT * FROM order_detail WHERE order_id = orderId;
END //

DELIMITER ;
CALL GetOrderDetails(5);

-- Процедура для создания заказа и удаления записи из корзины с обновлением количеста продукта в таблице product --
DELIMITER //
CREATE PROCEDURE CreateOrder(IN p_user_id INT)
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE last_order_id INT;
    
    -- Начинаем транзакцию
    START TRANSACTION;

    -- Вычисляем общую сумму заказа
    SELECT IFNULL(SUM(p.price * c.quantity), 0) INTO total
    FROM cart c
    JOIN product p ON c.product_id = p.product_id
    WHERE c.user_id = p_user_id;

    -- Вставляем запись в таблицу заказов
    INSERT INTO `order` (user_id, total_amount, order_status, order_date)
    VALUES (p_user_id, total, 'processing', NOW());

    -- Получаем последний вставленный идентификатор заказа
    SET last_order_id = LAST_INSERT_ID();

    -- Вставляем детали заказа и обновляем запасы продукта
    INSERT INTO order_detail (order_id, product_id, quantity, price)
    SELECT last_order_id, c.product_id, c.quantity, p.price
    FROM cart c
    JOIN product p ON c.product_id = p.product_id
    WHERE c.user_id = p_user_id;

    -- Обновляем запасы продукта
    UPDATE product p
    JOIN cart c ON p.product_id = c.product_id
    SET p.stock = p.stock - c.quantity
    WHERE c.user_id = p_user_id;

    -- Очищаем корзину
    DELETE FROM cart WHERE user_id = p_user_id;

    -- Подтверждаем транзакцию
    COMMIT;
END //

DELIMITER ;
CALL CreateOrder(1);

-- процедура для добавления нового продукта с проверкой роли пользователя --
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
-- Локальные переменные процедуре для расчета общей стоимости определенного количества продукта. -- 

DELIMITER //

CREATE PROCEDURE CalculateTotalPrice(IN productId INT, IN quantity INT)
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    DECLARE product_price DECIMAL(10, 2);

    SELECT price INTO product_price FROM product WHERE product_id = productId;
    SET total_price = product_price * quantity;

    SELECT total_price;
END //

DELIMITER ;