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