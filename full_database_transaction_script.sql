-- Docker Command: docker exec -it mysql-8.3.0-bbt3104 mysql -u root -p
-- Browser URL (phpMyAdmin): http://localhost:8080/
USE classicmodels;

START TRANSACTION;

SET @orderNumber = (SELECT MAX(orderNumber)+1 FROM orders);

INSERT INTO orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
VALUES(@orderNumber,
       DATE(NOW()),
       DATE(DATE_ADD(NOW(), INTERVAL 3 DAY)),
       DATE(DATE_ADD(NOW(), INTERVAL 2 DAY)),
       'In Process',
        145);

SAVEPOINT before_product_1;

INSERT INTO orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES(@orderNumber,'S18_1749', 2724, '136', 1); 

SET @quantityInStock = (SELECT quantityInStock FROM products WHERE `productCode` = 'S18_1749');

UPDATE `products` SET `quantityInStock` = @quantityInStock - 2724 WHERE `productCode` = 'S18_1749';

SAVEPOINT before_product_2;

INSERT INTO orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES(@orderNumber,'S18_2248', 540, '55.09', 2); 

SET @quantityInStock = (SELECT quantityInStock FROM products WHERE `productCode` = 'S18_2248');

UPDATE `products` SET `quantityInStock` = @quantityInStock - 540 WHERE `productCode` = 'S18_2248';

ROLLBACK TO SAVEPOINT before_product_2;

SAVEPOINT before_product_3;

INSERT INTO orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES(@orderNumber,'S12_1099', 68, '95.34', 3);

SET @quantityInStock = (SELECT quantityInStock FROM products WHERE `productCode` = 'S12_1099');

UPDATE `products` SET `quantityInStock` = @quantityInStock - 68 WHERE `productCode` = 'S12_1099';

INSERT INTO payments
(customerNumber, checkNumber, paymentDate, amount)
VALUES (145, 'JM555210', DATE(NOW()), 12000);

COMMIT;

SELECT *
FROM
	classicmodels.orderdetails
WHERE
	orderNumber = 10426;