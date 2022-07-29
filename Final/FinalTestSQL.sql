use Final;

-- Liệt kê tên các văn phòng theo tên thành phố và số lượng nhân viên thuộc các văn phòng đó
SELECT city, COUNT(employeeNumber)
FROM offices o 
INNER JOIN employees e ON o.officeCode = e.officeCode
GROUP BY city;

-- Liệt kê nước nào có số lượng văn phòng nhiều nhất
CREATE OR REPLACE VIEW emNumView AS 
SELECT country, COUNT(officeCode) AS Office_Number
FROM offices o 
GROUP BY country;

SELECT *
FROM emNumView
WHERE Office_Number = (
	SELECT MAX(Office_Number)
	FROM emNumView);

-- Liệt kê tình trạng các đơn hàng và số lượng đơn hàng thuộc tình trạng đó
SELECT status, COUNT(quantityOrdered)
FROM orders o 
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY status;

-- Liệt kê productLine và số lượng sản phẩm thuộc các line đó
SELECT productLine, COUNT(quantityInStock)
FROM products
GROUP BY productLine;

-- Liệt kê thông tin những đơn hàng bị hủy gồm: id đơn hàng, id khách hàng, tên khách hàng, orderDate, requireDate, nguyên nhân đơn hàng bị hủy (comment)
SELECT o.orderNumber, c.customerNumber, customerName, o.orderDate, o.requiredDate, o.comments
FROM customers c 
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE status = 'Cancelled';

-- Liệt kê id đơn hàng, id khách hàng, tên khách hàng, orderDate, requireDate, sản phẩm (id, tên, số lượng) , comment của đơn hàng có id 10165
SELECT od.orderNumber, c.customerNumber, c.customerName, orderDate, requiredDate, p.productCode As Product_ID
, p.productName, p.quantityInStock As ProductNumber, o.comments
FROM customers c 
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p ON od.productCode = p.productCode
Where od.orderNumber = 10165;

-- Liệt kê thông tin các nhân viên thực hiện công việc Sales Rep làm việc ở văn phòng San Francisco
SELECT * 
FROM employees e
INNER JOIN offices o ON o.officeCode = e.officeCode
WHERE jobTitle ='Sales Rep' AND city = 'San Francisco';

-- Liệt kê thông tin 5 khách hàng order nhiều nhất
    SELECT c.*
    FROM customers c
    INNER JOIN (
	SELECT c.customerNumber, COUNT(o.orderNumber) AS orNumber
	FROM customers c 
	INNER JOIN orders o ON c.customerNumber = o.customerNumber
	GROUP BY c.customerNumber
	ORDER BY orNumber DESC
	LIMIT 5) As sub_table ON c.customerNUmber = sub_table.customerNumber;
    
    
    SELECT COUNT(o.orderNumber) AS orNumber
	FROM customers c 
	INNER JOIN orders o ON c.customerNumber = o.customerNumber
    GROUP BY c.customerNumber
    ORDER BY orNumber DESC
    LIMIT 5;
    

-- Tạo store procedure lấy ra thông tin id đơn hàng, id khách hàng, tên khách hàng, 
-- orderDate, requireDate, shippedDate, sản phẩm (id, tên, số lượng), comment, với tham số truyền vào là status
DELIMITER $$
CREATE PROCEDURE store_procedure(
	 IN status_input VARCHAR(20)
)

BEGIN
	SELECT od.orderNumber, c.customerNumber, c.customerName, orderDate, requiredDate, p.productCode As Product_ID
	, p.productName, p.quantityInStock As ProductNumber, o.comments
	FROM customers c 
	INNER JOIN orders o ON c.customerNumber = o.customerNumber
	INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
	INNER JOIN products p ON od.productCode = p.productCode
    WHERE status = status_input;
END $$
DELIMITER ;

CALL store_procedure('Shipped');
