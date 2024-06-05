-- Заполнение таблицы user
INSERT INTO user (username, password, role) VALUES 
('ivan_ivanov', 'password1', 'customer'),
('anna_smirnova', 'password2', 'seller'),
('admin', 'password3', 'admin'),
('petr_petrov', 'password4', 'seller'),
('alexey_alexeev', 'password5', 'customer');

-- Заполнение таблицы category
INSERT INTO category (name) VALUES 
('Строительные материалы'),
('Инструменты'),
('Краски и покрытия'),
('Электрика'),
('Сантехника');

-- Заполнение таблицы product
INSERT INTO product (name, description, price, stock, category_id, seller_id) VALUES 
('Цемент', 'Цемент для строительных работ', 500.00, 100, 1, 2),
('Кирпич', 'Красный кирпич для кладки', 20.00, 1000, 1, 2),
('Дрель', 'Электрическая дрель', 3000.00, 50, 2, 2),
('Краска белая', 'Белая акриловая краска', 600.00, 200, 3, 2),
('Провода', 'Электрические провода', 100.00, 500, 4, 2),
('Смеситель', 'Смеситель для ванной', 1500.00, 100, 5, 2),
('Гипсокартон', 'Листы гипсокартона', 350.00, 300, 1, 4),
('Молоток', 'Строительный молоток', 250.00, 150, 2, 4),
('Клей', 'Клей для обоев', 200.00, 400, 3, 4),
('Розетка', 'Электрическая розетка', 150.00, 200, 4, 4);

-- Заполнение таблицы cart
INSERT INTO cart (user_id, product_id, quantity) VALUES 
(1, 1, 5),
(1, 3, 1),
(1, 6, 2),
(5, 7, 10),
(5, 8, 1);

-- Заполнение таблицы order
INSERT INTO `order` (user_id, total_amount, order_status) VALUES 
(1, 2600.00, 'paid'),
(1, 3600.00, 'processing'),
(5, 3700.00, 'unpaid'),
(5, 3550.00, 'paid'),
(5, 2550.00, 'processing');

-- Заполнение таблицы order_detail
INSERT INTO order_detail (order_id, product_id, quantity, price) VALUES 
(1, 1, 5, 500.00),
(1, 3, 1, 3000.00),
(1, 6, 2, 1500.00),
(2, 7, 10, 350.00),
(3, 8, 1, 250.00),
(4, 8, 1, 250.00),
(4, 7, 10, 350.00),
(5, 8, 1, 250.00);
