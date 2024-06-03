# README.md

## Название проекта

**Система управления заказами в интернет-магазине**

## Описание

Данная база данных разработана для управления заказами в интернет-магазине. Она включает таблицы для пользователей, категорий продуктов, продуктов, корзины и заказов. Система поддерживает различные бизнес-процессы, такие как управление пользователями и ролями, добавление продуктов, создание заказов и управление запасами.

## Назначение

Основное назначение данной базы данных - обеспечивать хранение и управление информацией о продуктах, пользователях и заказах интернет-магазина, а также поддерживать выполнение ключевых бизнес-процессов, связанных с этими данными.

## Структура базы данных

### Таблицы

- **user**: Хранит информацию о пользователях (идентификатор, имя пользователя, пароль, роль).
- **category**: Хранит категории продуктов.
- **product**: Хранит информацию о продуктах (идентификатор, название, описание, цена, количество на складе, категория, продавец).
- **cart**: Хранит информацию о товарах в корзине пользователей.
- **order**: Хранит информацию о заказах (идентификатор, пользователь, общая сумма, статус, дата заказа).
- **order_detail**: Хранит детали заказов (идентификатор, заказ, продукт, количество, цена).

### Роли

- **Администратор**: Управляет всеми аспектами системы.
- **Продавец**: Может добавлять и управлять продуктами.
- **Покупатель**: Может просматривать и заказывать продукты.

## Функциональные объекты

### Типовые запросы

1. **Получение всех продуктов категории**:
    ```sql
    SELECT p.name, p.description, p.price
    FROM product p
    JOIN category c ON p.category_id = c.category_id
    WHERE c.name = 'инструменты';
    ```

2. **Получение всех заказов пользователя**:
    ```sql
    SELECT o.order_id, o.total_amount, o.order_status, o.order_date
    FROM `order` o
    WHERE o.user_id = 2;
    ```

3. **Получение деталей конкретного заказа**:
    ```sql
    SELECT od.product_id, od.quantity, od.price
    FROM order_detail od
    WHERE od.order_id = 1;
    ```

4. **Получение всех продуктов продавца**:
    ```sql
    SELECT p.product_id, p.name, p.description, p.price
    FROM product p
    JOIN user u ON p.seller_id = u.user_id
    WHERE u.role = 'seller' AND u.user_id = 3;
    ```

5. **Обновление статуса заказа**:
    ```sql
    UPDATE `order`
    SET order_status = 'paid'
    WHERE order_id = 1;
    ```

### Обработчик исключений

 используется в процедуре для добавления нового продукта. Если пользователь, пытающийся добавить продукт, не является продавцом, процедура выдает ошибку.
```sql
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
```
### Пользовательская функция
 Функция для получения общей суммы заказа по его идентификатору.
```sql
CREATE DEFINER=`root`@`localhost` FUNCTION `GetOrderTotal`(order_id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(od.quantity * od.price) INTO total
    FROM order_detail od
    WHERE od.order_id = order_id;
    
    RETURN total;
END
```
###Триггер
Триггер автоматически обновляет общую сумму заказа после вставки новой записи в order_detail.
```sql
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
```
### Представление
Представление для отображения деталей заказов.
```sql
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `orderdetailsview` AS
    SELECT 
        `o`.`order_id` AS `order_id`,
        `o`.`user_id` AS `user_id`,
        `o`.`total_amount` AS `total_amount`,
        `o`.`order_status` AS `order_status`,
        `o`.`order_date` AS `order_date`,
        `od`.`product_id` AS `product_id`,
        `od`.`quantity` AS `quantity`,
        `od`.`price` AS `price`
    FROM
        (`order` `o`
        JOIN `order_detail` `od` ON ((`o`.`order_id` = `od`.`order_id`)));
```
### Хранимая процедура
Процедура для получения деталей заказа по его идентификатору.
```sql
DELIMITER //

CREATE PROCEDURE GetOrderDetails(IN orderId INT)
BEGIN
    SELECT * FROM order_detail WHERE order_id = orderId;
END //

DELIMITER ;

CALL GetOrderDetails(7);
```
### Условие
Условие используется в процедуре для добавления нового продукта с проверкой роли пользователя. Если пользователь не является продавцом, выдается ошибка.
```sql
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
```
### Локальные переменные 
Локальные переменные процедуре для расчета общей стоимости определенного количества продукта.
```sql
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
```
