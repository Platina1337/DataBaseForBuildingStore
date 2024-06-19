-- представление для отображения деталей заказов --
CREATE VIEW orderdetailsview AS
SELECT
    o.order_id,
    o.user_id,
    o.total_amount,
    o.order_status,
    o.order_date,
    od.product_id,
    od.quantity,
    od.price
FROM `order` o
JOIN order_detail od ON o.order_id = od.order_id;
