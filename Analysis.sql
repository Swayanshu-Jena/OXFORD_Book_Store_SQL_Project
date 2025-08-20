-- Books Table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    Published_Year INT NOT NULL,
    Price NUMERIC(10, 2) NOT NULL,
    Stock INT NOT NULL,
    CHECK (Published_Year > 0),
    CHECK (Price >= 0),
    CHECK (Stock >= 0)
);

-- Customers Table
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(150) NOT NULL,
    UNIQUE (Email)
);

-- Orders Table
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT NOT NULL REFERENCES Customers(Customer_ID),
    Book_ID INT NOT NULL REFERENCES Books(Book_ID),
    Order_Date DATE NOT NULL,
    Quantity INT NOT NULL,
    Total_Amount NUMERIC(10, 2) NOT NULL,
    CHECK (Quantity > 0),
    CHECK (Total_Amount >= 0)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Basic Queries
-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year > '1950';

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS Total_Books_In_Stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
WHERE price = (SELECT MAX(price) FROM Books);

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, o.order_date, o.quantity
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
WHERE o.quantity > 1
ORDER BY c.customer_id;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT o.order_id, c.name AS Customer_Name, b.title AS Book, o.order_date, o.quantity, o.total_amount
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
JOIN Books AS b ON o.book_id = b.book_id
WHERE o.total_amount > 20.00
ORDER BY o.order_id;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre
FROM Books
ORDER BY genre;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books
ORDER BY stock
LIMIT 1;

-- 11) Calculate the monthly revenue generated from all orders:
SELECT 
    TO_CHAR(order_date, 'Month') AS Month_Name,
    EXTRACT(MONTH FROM order_date) AS Month_Number,
    EXTRACT(YEAR FROM order_date) AS Year,
    SUM(total_amount) AS Total_Revenue
FROM orders
GROUP BY Month_Name, Month_Number, Year
ORDER BY Year, Month_Number;

-- 12) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS Total_Revenue
FROM orders;

---
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
---

-- Advance Queries
-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre, SUM(o.quantity) AS Total_books_Sold
FROM Books AS b
JOIN Orders AS o
ON b.book_id = o.book_id
GROUP BY b.genre
ORDER BY Total_books_Sold DESC;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT ROUND(AVG(price), 2) AS Average_Book_Price
FROM Books 
WHERE genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, COUNT(o.order_id) AS Total_Orders
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.phone, c.city, c.country
HAVING COUNT(o.order_id) >= 2
ORDER BY total_orders DESC;

-- 4) Find the most frequently ordered book:
SELECT b.book_id, b.title, b.author, b.genre, b.published_year, COUNT(o.book_id) AS Times_Ordered
FROM Books AS b
JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.author, b.genre, b.published_year
ORDER BY Times_Ordered DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre:
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_books_Sold
FROM Books AS b
JOIN Orders AS o
ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY Total_books_Sold DESC;

-- 7) List the cities where customers who spent over $30 are located:
SELECT c.city, SUM(o.total_amount) AS Total_Amount_Spent
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 30.00
ORDER BY c.city; 

-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, SUM(o.total_amount) AS Total_Spending
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.phone, c.city, c.country
ORDER BY Total_Spending DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.author, b.genre, b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Stock
FROM Books AS b
LEFT JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.author, b.genre, b.stock
ORDER BY b.book_id;