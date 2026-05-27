DROP TABLE IF EXISTS books; 
CREATE TABLE books 
(Book_ID SERIAL PRIMARY KEY, Title VARCHAR (100), Author VARCHAR (100), Genre VARCHAR (50),
Published_Year INT, Price NUMERIC (10,2), Stock INT );


DROP TABLE IF EXISTS customers; 
CREATE TABLE customers (Customer_ID SERIAL PRIMARY KEY, Name VARCHAR(100), 
Email VARCHAR(100), 
Phone VARCHAR(15), City VARCHAR (50) , Country VARCHAR(150));

DROP TABLE IF EXISTS orders; 
CREATE TABLE orders(
Order_ID SERIAL PRIMARY KEY ,
Customer_ID INT REFERENCES customers(Customer_ID),
Book_ID INT REFERENCES books(Book_ID), Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2));


--1)
Select * from books where genre='Fiction';

--2)RETRIEVE ALL BOOKS PUBLISHED AFTER 1950
Select * from books where Published_Year>1950;

--3)LIST ALL CUSTOMERS FROM CANADA
Select Name from customers where Country='Canada';

--4)SHOW ORDERS PLACED IN NOV 2023
Select * from orders where order_date 
BETWEEN '2023-11-01' AND '2023-11-30';

--5)RETRIEVE TOTAL STOCKS OF BOOKS AVAILABLE
Select SUM(stock) AS Total_stock from books;

--6)FIND THE DETAILS OF THE MOST EXP BOOK
Select MAX(Price) AS expensive_book from books;
Select * from books ORDER BY Price DESC LIMIT 1;

--7)Show all customers who ordered more than 1 quantity of book
 Select * from orders where quantity > 1;

 --8)Retrieve all orders where total amt exceeds 20 dollars
 Select * from orders where total_amount > 20;

 --9)List all the genres available in bookstable
Select DISTINCT genre from books;
Select COUNT(DISTINCT genre) AS total_genres from books;

--10)Select book with lowest stock
Select Title FROM books ORDER BY  stock ASC LIMIT 1;
Select * FROM books ORDER BY  stock ASC LIMIT 1;

 --11)Calculate total revenue generated in all orders
 Select SUM(Total_Amount) AS Total_revenue from orders;

--12) Show customers who placed more than 3 orders
SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 3;
--13) Retrieve top 5 most expensive books
Select * FROM books ORDER BY  price DESC LIMIT 5;
Select title FROM books ORDER BY  price DESC LIMIT 5;
--14) Show all books whose price is greater than average book price

SELECT *
FROM books
WHERE price >
(
    SELECT AVG(price)
    FROM books
);
--15) Find customers who never placed any order
SELECT c.customer_id,
       c.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--16) Display total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM orders;

--17) Show total quantity sold for each book
SELECT b.book_id,
       b.title,
       SUM(o.quantity) AS total_quantity_sold
FROM books b
JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.book_id, b.title;
--18) Retrieve the most sold book based on quantity
SELECT b.book_id,
       b.title,
       SUM(o.quantity) AS total_sold
FROM orders o
JOIN books b
ON o.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY total_sold DESC
LIMIT 1;
--19) Show each customer with total amount spent on orders
SELECT c.customer_id,
       c.name,
       SUM(o.total_amount) AS total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
order by total_amount desc ;

--20) Find customer who spent highest total amount
SELECT c.customer_id,
       c.name,
       SUM(o.total_amount) AS total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_amount DESC
LIMIT 1;
--21) Show monthly total sales revenue
SELECT EXTRACT(YEAR FROM order_date) AS year,
       EXTRACT(MONTH FROM order_date) AS month,
       SUM(total_amount) AS total_sales
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date),
         EXTRACT(MONTH FROM order_date)
ORDER BY year, month;


--24) Retrieve orders placed in the last 30 days from max order date in table
SELECT *
FROM orders
WHERE order_date >= (SELECT MAX(order_date) - INTERVAL '30 days' FROM orders);
--25) Show customers who ordered books from genre = 'Fiction'
SELECT DISTINCT c.customer_id,
       c.name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN books b
ON o.book_id = b.book_id
WHERE b.genre = 'Fiction';
--26) Find authors whose books sold more than 10 total quantity
SELECT b.author,
       SUM(o.quantity) AS total_sold
FROM books b
JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.author
HAVING SUM(o.quantity) > 10;
--27) Show top 3 customers by total spending
SELECT c.customer_id,
       c.name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;
--28) Retrieve second highest priced book
Select title,book_id FROM
(
Select title,book_id,price,DENSE_RANK() OVER 
(ORDER BY price DESC) As rnk FROM books
) 
t WHERE rnk=3;
select title,book_id from books order by price desc limit 1 offset 2;

SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY price DESC) AS rnk 
    FROM books
) t
WHERE rnk = 2;
--29) Show duplicate customer emails if any exist
SELECT email,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


--30) Find average order amount for each customer
select customer_id,avg(total_amount) as average from orders
 group by customer_id
 order by average;






--31) Show books that were never ordered
SELECT b.book_id,
       b.title
FROM books b
LEFT JOIN orders o
ON b.book_id = o.book_id
WHERE o.book_id IS NULL;

--32) Retrieve customers who ordered more than one different book

SELECT c.customer_id,
       c.name,
       COUNT(DISTINCT o.book_id) AS different_books_ordered
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT o.book_id) > 1;


--33) Show order details with customer name, book title, quantity and total amount
SELECT c.name,
       b.title,
       o.quantity,
       o.total_amount
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN books b
ON o.book_id = b.book_id;


--34) Find the day on which highest sales amount happened
SELECT order_date,
       SUM(total_amount) AS sales
FROM orders
GROUP BY order_date
ORDER BY sales DESC
LIMIT 1;


--35) Show running total of sales based on order date
SELECT order_date,
       SUM(total_amount) AS daily_sales,
       SUM(SUM(total_amount)) OVER(ORDER BY order_date) AS running_total
FROM orders
GROUP BY order_date
ORDER BY order_date;


--36) Rank customers based on total spending

SELECT c.customer_id,
       c.name,
       SUM(o.total_amount) AS total_spending,
       RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS customer_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
--37) Find books whose price is higher than every Fiction genre book
SELECT *
FROM books
WHERE price > ALL
(
    SELECT price
    FROM books
    WHERE genre = 'Fiction'
);
SELECT *
FROM books
WHERE price > 
(
    SELECT MAX(price)
    FROM books
    WHERE genre = 'Fiction'
);

--38) Show customer who placed first order in the table
SELECT c.customer_id,
       c.name,
       o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY o.order_date
LIMIT 1;


--39) Retrieve latest order of every customer
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM orders
) x
WHERE rn = 1;


--40) Show percentage contribution of each customer in total revenue
SELECT c.customer_id,
       c.name,
       SUM(o.total_amount) AS total_spent,
       ROUND(SUM(o.total_amount) * 100.0 / SUM(SUM(o.total_amount)) OVER(),2) AS percentage_contribution
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- 41) Find the top 3 most expensive books in each genre using window functions.
SELECT book_id,title,author,genre,
     price
FROM
(
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY genre ORDER BY price DESC) AS rnk
    FROM books
) x
WHERE rnk <= 3;


-- 43) Find all books that have never been ordered. (Use a subquery)
SELECT *
FROM books b
LEFT JOIN orders o
ON b.book_id = o.book_id
WHERE o.book_id IS NULL;

--44) Using a CTE, calculate the total revenue generated per genre and
--    return only genres where total revenue exceeds 100 dollars.

WITH cte_name AS
(
    SELECT b.genre,
           SUM(o.total_amount) AS total_revenue
    FROM books b
    JOIN orders o
    ON b.book_id = o.book_id
    GROUP BY b.genre
)
SELECT *
FROM cte_name
WHERE total_revenue > 100;


--45) Retrieve the full name, email, and their most recent order date
--    for each customer. (Use subquery or window function)

SELECT name,
       email,
       recent_order_date
FROM
(
    SELECT c.name,
           c.email,
           o.order_date AS recent_order_date,
           ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY o.order_date DESC) AS rn
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
) x
WHERE rn = 1;


--46) Find customers who placed their first ever order in the year 2024.
--    (Use date functions)

SELECT c.customer_id,
       c.name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING EXTRACT(YEAR FROM MIN(o.order_date)) = 2024;


--47) Using a window function, rank customers based on their total spending
--    (sum of Total_Amount). Show customer name and their rank.
SELECT 
    c.name,
    SUM(o.total_amount) AS total_spending,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS customer_rank
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY  c.customer_id,c.name;

SELECT 
    c.name,
    SUM(o.total_amount) AS total_spending,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS customer_rank
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) > 990;

--48) Write a query to find month-wise total revenue across all orders.
--    Display month name (e.g. January, February) and total revenue,
--    sorted by month number. (Use date functions)

SELECT TO_CHAR(order_date,'Month') AS month_name,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date),
         TO_CHAR(order_date,'Month')
ORDER BY EXTRACT(MONTH FROM order_date);


--49) Find all customers whose name starts with a vowel (A, E, I, O, U).
--    (Use string functions)

SELECT *
FROM customers
WHERE UPPER(LEFT(name,1)) IN ('A','E','I','O','U');


--50) Using a CTE, find the average order value per customer,
--    then return only those customers whose average is above
--    the overall average order value.

WITH cte AS
(
    SELECT customer_id,
           AVG(total_amount) AS avg_order_value
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM cte
WHERE avg_order_value >
(
    SELECT AVG(total_amount)
    FROM orders
);

--51) Retrieve the title of the book, total quantity sold, and
--    its percentage contribution to overall total quantity sold.
--    (Use window functions)

SELECT b.title,
       SUM(o.quantity) AS total_quantity_sold,
       ROUND(SUM(o.quantity) * 100.0 /
       SUM(SUM(o.quantity)) OVER(),2) AS percentage_contribution
FROM books b
JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.title;


--53) For each customer, show their name, total number of orders,
--    total amount spent, and label them as 'High Value' if total > 100,
--    'Medium Value' if between 50-100, else 'Low Value'.

SELECT c.name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent,
       CASE
           WHEN SUM(o.total_amount) > 100 THEN 'High Value'
           WHEN SUM(o.total_amount) BETWEEN 50 AND 100 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_label
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

Select * from orders;
--54) Using a self join or subquery, find customers who are from
--    the same city as at least one other customer.

SELECT DISTINCT c1.customer_id,
       c1.name,
       c1.city
FROM customers c1
JOIN customers c2
ON c1.city = c2.city
AND c1.customer_id <> c2.customer_id;


-- 55) Write a query using LEAD() or LAG() window function to show,
--     for each order, the previous order date of the same customer
--     and the gap in days between the two orders.
SELECT order_id,
       customer_id,
       order_date,
       LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
       order_date - LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS gap_in_days
FROM orders;
--56)Retrieve totak no of bookssold for each genre
Select b.genre,o.quantity
FROM orders o JOIN books b 
ON o.book_id = b.book_id ;

Select b.genre,SUM(o.quantity) AS total_booksSold
FROM orders o JOIN books b 
ON o.book_id = b.book_id 
GROUP BY b.genre;

--57)Find the avg price of books in "fantasy" genre
Select AVG(price) AS fantasy_avg_price
FROM books
where genre = 'Fantasy';

--58)Find the list of customers who have placed atleast 2 orders
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 2;

SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

--59)Find the most frequently ordered book
SELECT .customer_id,
       c.name,
       COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;