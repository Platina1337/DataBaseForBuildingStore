-- Триггер автоматически обновляет общую сумму заказа после вставки новой записи в order_detail. --
DROP TRIGGER IF EXISTS UpdateOrderTotalAmount;

DELIMITER //

CREATE TRIGGER UpdateOrderTotalAmount
AFTER INSERT ON order_detail
FOR EACH ROW
BEGIN
    DECLARE new_total DECIMAL(10, 2);
    
    SELECT SUM(price * quantity) INTO new_total
    FROM order_detail
    WHERE order_id = NEW.order_id;
    
    UPDATE `order`
    SET total_amount = new_total
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;