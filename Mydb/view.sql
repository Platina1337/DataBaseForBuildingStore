-- представление для отображения деталей заказов --
CREATE
    ALGORITHM = UNDEFINED
    DEFINER = `root`@`localhost`
    SQL SECURITY DEFINER
VIEW `buildingstore`.`orderdetailsview` AS
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
        (`buildingstore`.`order` `o`
        JOIN `buildingstore`.`order_detail` `od` ON ((`o`.`order_id` = `od`.`order_id`)))