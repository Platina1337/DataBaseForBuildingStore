CREATE USER 'customer'@'localhost' IDENTIFIED BY 'password1';
CREATE USER 'seller'@'localhost' IDENTIFIED BY 'password1';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password1';


--Назначение привилегий для пользователя админа --
GRANT ALL PRIVILEGES ON buildingstore.* TO 'admin'@'localhost';

--Назначение привилегий для пользователя продавца --
GRANT SELECT, INSERT, UPDATE ON buildingstore.product TO 'seller'@'localhost';
GRANT SELECT ON buildingstore.category TO 'seller'@'localhost';
GRANT SELECT ON buildingstore.order TO 'seller'@'localhost';
GRANT SELECT ON buildingstore.order_detail TO 'seller'@'localhost';

--Назначение привилегий для пользователя покупателя --
GRANT SELECT ON buildingstore.product TO 'customer'@'localhost';
GRANT SELECT ON buildingstore.category TO 'customer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON buildingstore.cart TO 'customer'@'localhost';
GRANT SELECT, INSERT ON buildingstore.order TO 'customer'@'localhost';
GRANT SELECT ON buildingstore.order_detail TO 'customer'@'localhost';

-- Обновление привилегий
FLUSH PRIVILEGES;
