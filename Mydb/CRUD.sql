INSERT INTO `user` (username, password, role) VALUES ('new_user', 'new_password', 'customer');
SELECT * FROM `user` WHERE user_id = 7;
UPDATE `user` SET password = 'updated_password' WHERE user_id = 7;
DELETE FROM `user` WHERE user_id = 7;

INSERT INTO `category` (name) VALUES ('New Category');
SELECT * FROM `category` WHERE category_id = 6;
UPDATE `category` SET name = 'Updated Category' WHERE category_id = 6;
DELETE FROM `category` WHERE category_id = 6;

INSERT INTO `product` (name, description, price, stock, category_id, seller_id) VALUES ('New Product', 'Description of new product', 99.99, 10, 1, 2);
SELECT * FROM `product` WHERE product_id = 11;
UPDATE `product` SET price = 89.99 WHERE product_id = 11;
DELETE FROM `product` WHERE product_id = 11;

INSERT INTO `order` (user_id, total_amount, order_status) VALUES (1, 250.00, 'processing');
SELECT * FROM `order` WHERE order_id = 8;
UPDATE `order` SET order_status = 'paid' WHERE order_id = 8;
DELETE FROM `order` WHERE order_id = 8;

INSERT INTO `order_detail` (order_id, product_id, quantity, price) VALUES (1, 1, 2, 50.00);
SELECT * FROM `order_detail` WHERE order_detail_id = 13;
UPDATE `order_detail` SET quantity = 3 WHERE order_detail_id = 13;
DELETE FROM `order_detail` WHERE order_detail_id = 13;

INSERT INTO `cart` (user_id, product_id, quantity) VALUES (1, 1, 2);
SELECT * FROM `cart` WHERE cart_id = 6;
UPDATE `cart` SET quantity = 3 WHERE cart_id = 6;
DELETE FROM `cart` WHERE cart_id = 6;