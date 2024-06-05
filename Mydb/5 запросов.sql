-- Типовые запросы --
-- Получение всех продуктов категории --
SELECT p.name, p.description, p.price
FROM product p
JOIN category c ON p.category_id = c.category_id
WHERE c.name = 'инструменты';

-- Получение всех заказов пользователя --
SELECT o.order_id, o.total_amount, o.order_status, o.order_date
FROM `order` o
WHERE o.user_id = 2;

-- Получение деталей конкретного заказа --

SELECT od.product_id, od.quantity, od.price
FROM order_detail od
WHERE od.order_id = 1;

-- Получение всех продуктов продавца --

SELECT p.product_id, p.name, p.description, p.price
FROM product p
JOIN user u ON p.seller_id = u.user_id
WHERE u.role = 'seller' AND u.user_id = 3;

-- Обновление статуса заказа --

UPDATE `order`
SET order_status = 'paid'
WHERE order_id = 1;
