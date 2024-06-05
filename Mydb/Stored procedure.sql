-- Процедура для получения деталей заказа по его идентификатору. --
DELIMITER //

CREATE PROCEDURE GetOrderDetails(IN orderId INT)
BEGIN
    SELECT * FROM order_detail WHERE order_id = orderId;
END //

DELIMITER ;

CALL GetOrderDetails(5);