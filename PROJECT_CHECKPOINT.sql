-------------------		--------------------------------------
SELECT LAST_NAME,FIRST_NAME,EMPLOYEE_NUMBER,HIRE_DATE
FROM  employees
WHERE TITLE = 'Mr.'
ORDER BY LAST_NAME,FIRST_NAME,EMPLOYEE_NUMBER,HIRE_DATE DESC;
----------------------------------------------------------------------
select * from PRODUCTS;
SELECT  PRODUCT_REF,product_name,supplier_number,UNIT_PRICE,UNITS_ON_ORDER
FROM products
WHERE quantity LIKE '%bottle%' 
AND (SUBSTRING(product_name, 3, 1) = 't' OR SUBSTRING(product_name, 3, 1) = 'T')
AND supplier_number IN (1, 2, 3)
AND unit_price BETWEEN 70 AND 200
AND UNITS_ON_ORDER IS NOT NULL;
	----------------------------------------------------------------------------------------
select * from CUSTOMERS 
where country=(select country from SUPPLIERS where SUPPLIER_NUMBER=1)
and CITY=(select CITY from SUPPLIERS where SUPPLIER_NUMBER=1)
and right(postal_code,3)=(select right (postal_code,3) from SUPPLIERS where SUPPLIER_NUMBER=1);
	--------------------------------------------------------------------------------------------
	/* For each order number between 10998 and 11003, do the following:  
-Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise.
-Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise. The resulting table should display the columns: order number, new discount rate, and discount rate application note. */

SELECT ORDER_NUMBER,UNIT_PRICE * QUANTITY AS TotalAmountBeforeDiscount,
    CASE 
        WHEN UNIT_PRICE * QUANTITY BETWEEN 0 AND 2000 THEN '0%'
        WHEN UNIT_PRICE * QUANTITY BETWEEN 2001 AND 10000 THEN '5%'
        WHEN UNIT_PRICE * QUANTITY BETWEEN 10001 AND 40000 THEN '10%'
        WHEN UNIT_PRICE * QUANTITY BETWEEN 40001 AND 80000 THEN '15%'
        ELSE '20%'
    END AS Discount,
	    CASE 
        WHEN ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'apply old discount rate'
        ELSE 'apply new discount rate'
    END AS DiscountRateApplicationNote
FROM ORDER_DETAILS
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003;
--------------------------------------------------------------------------------------------------------------------
/* Display suppliers of beverage products. The resulting table should display the columns: supplier number, company, address, and phone number. */
---------------------------------------------------------------------------------------------------------------------
SELECT 
    S.SUPPLIER_NUMBER,
    S.COMPANY,
    S.ADDRESS,
    S.PHONE
FROM SUPPLIERS S
JOIN PRODUCTS P ON S.SUPPLIER_NUMBER = P.SUPPLIER_NUMBER
JOIN CATEGORIES C ON P.CATEGORY_CODE = C.CATEGORY_CODE
WHERE C.CATEGORY_NAME = 'Beverages';
use orders;
------Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. The resulting table should display the column: customer code.--------------------------------------------------------------------------------------------------------
SELECT c.CUSTOMER_CODE
FROM CUSTOMERS c
inner JOIN ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
inner JOIN ORDER_DETAILS od ON o.ORDER_NUMBER = od.ORDER_NUMBER
inner JOIN PRODUCTS p ON od.PRODUCT_REF = p.PRODUCT_REF
inner JOIN CATEGORIES cat ON p.CATEGORY_CODE = cat.CATEGORY_CODE
WHERE c.CITY = 'Berlin' 
and cat.CATEGORY_NAME='desserts'
GROUP BY c.CUSTOMER_CODE 
HAVING count(od.PRODUCT_REF)<=1
------Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 (considering customers who haven't placed any orders yet). The resulting table should display the columns: customer number, company name, phone number, total amount, and country.
SELECT 
    c.CUSTOMER_CODE, 
    c.COMPANY, 
    c.PHONE, 
	c.COUNTRY
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS od ON o.ORDER_NUMBER = od.ORDER_NUMBER
WHERE c.COUNTRY = 'France' 
AND (O.ORDER_DATE IS NULL OR (YEAR(O.ORDER_DATE) = 1998 
AND MONTH(O.ORDER_DATE) = 4 
AND DATENAME(WEEKDAY, O.ORDER_DATE) = 'Monday'))
GROUP BY c.CUSTOMER_CODE, c.COMPANY, c.PHONE, c.COUNTRY
ORDER BY c.CUSTOMER_CODE;
-----Display customers who have ordered all products. The resulting table should display the columns: customer code, company name, and telephone number.------------------------------------------------------------------------------------------------------------------
SELECT c.customer_code, c.COMPANY, c.PHONE
FROM customers c
JOIN orders o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
JOIN order_details od ON o.ORDER_NUMBER = od.ORDER_NUMBER
JOIN products p ON od.PRODUCT_REF = p.PRODUCT_REF
GROUP BY c.customer_code, c.COMPANY, c.PHONE
HAVING COUNT(DISTINCT p.PRODUCT_REF) = (SELECT COUNT(*) FROM products);
select*from CUSTOMERS;
----Display for each customer from France the number of orders they have placed. The resulting table should display the columns: customer code and number of orders.---------------------------------------------------------------------------------------------
select c.customer_code ,COUNT(o.ORDER_NUMBER)AS NUMBER_OF_ORDER
FROM CUSTOMERS C
LEFT JOIN orders o ON c.customer_CODE = o.customer_CODE
WHERE c.country = 'France'
GROUP BY c.customer_code
order by c.customer_code;

-----Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.-----------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM orders WHERE YEAR(order_date) = 1996) AS orders_in_1996,
    (SELECT COUNT(*) FROM orders WHERE YEAR(order_date) = 1997) AS orders_in_1997,
    ((SELECT COUNT(*) FROM orders WHERE YEAR(order_date) = 1997) - 
     (SELECT COUNT(*) FROM orders WHERE YEAR(order_date) = 1996)) AS Difference;




   



 
 


		