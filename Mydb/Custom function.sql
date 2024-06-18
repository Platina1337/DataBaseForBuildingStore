-- Пользовательская функция для получения общей суммы заказа по его идентификатору. -- 
DELIMITER //

CREATE FUNCTION `GetOrderTotal`(p_order_id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2) DEFAULT 0.00;
    
    -- Подсчитываем общую сумму заказа
    SELECT SUM(price * quantity) INTO total
    FROM order_detail
    WHERE order_id = p_order_id;

    RETURN total;
END //

DELIMITER ;

