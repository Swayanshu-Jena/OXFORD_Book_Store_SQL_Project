# OXFORD Book Store Data Analysis using SQL

<img width="3262" height="1160" alt="OXFORD" src="https://github.com/user-attachments/assets/54911efd-58bb-434b-a2ee-ad8de2f83668" />

## Overview
This project is a complete SQL analysis of an online bookstore's database. It uses three core tables—Books, Customers, and Orders—to transform raw data into actionable business intelligence. The goal was to uncover key insights into sales trends, inventory status, and customer behavior to inform strategic decisions. The analysis demonstrates strong proficiency in writing complex SQL queries for data-driven storytelling. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze book distribution across genres and their pricing.
- Identify sales trends and calculate total revenue.
- Understand customer demographics and purchasing patterns.
- Determine the most popular books and authors.
- Manage inventory by calculating remaining stock levels.

## Data Model Structure

<img width="800" height="1000" alt="Schema" src="https://github.com/user-attachments/assets/0010b61d-f5e2-4ced-96d9-52a02d52506c" />

## Schema

```sql
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
```

## Business Problems and Solutions

## Basic Problems

### 1. Retrieve all books in the "Fiction" genre

```sql
SELECT *
FROM Books
WHERE genre = 'Fiction';
```

**Objective:**  Retrieve all books classified under the "Fiction" genre.

### 2. Find books published after the year 1950

```sql
SELECT *
FROM Books
WHERE published_year > '1950';
```

**Objective:** Find all books that were published after the year 1950.

### 3. List all customers from Canada

```sql
SELECT *
FROM Customers
WHERE country = 'Canada';
```

**Objective:** List all customers who are located in Canada.

### 4. Show orders placed in November 2023

```sql
SELECT *
FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';
```

**Objective:** Show all orders that were placed in the month of November 2023.

### 5. Retrieve the total stock of books available

```sql
SELECT SUM(stock) AS Total_Books_In_Stock
FROM Books;
```

**Objective:** Calculate the total number of books currently available in stock.

### 6. Find the details of the most expensive book

```sql
SELECT *
FROM Books
WHERE price = (SELECT MAX(price) FROM Books);
```

**Objective:** Find the details of the most expensive book in the inventory.

### 7. Show customers who ordered more than 1 quantity

```sql
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, o.order_date, o.quantity
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
WHERE o.quantity > 1
ORDER BY c.customer_id;
```

**Objective:** Identify all customers who have ordered more than one copy of a book in a single order.
### 8. Retrieve orders where total amount exceeds $20

```sql
SELECT o.order_id, c.name AS Customer_Name, b.title AS Book, o.order_date, o.quantity, o.total_amount
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
JOIN Books AS b ON o.book_id = b.book_id
WHERE o.total_amount > 20.00
ORDER BY o.order_id;
```

**Objective:** Retrieve all orders where the total amount spent exceeds $20.
### 9. List all genres available

```sql
SELECT DISTINCT genre
FROM Books
ORDER BY genre;
```

**Objective:**  List all unique genres available in the book catalog.

### 10. Find the book with the lowest stock

```sql
SELECT *
FROM Books
ORDER BY stock
LIMIT 1;
```

**Objective:** Find the book with the lowest remaining stock quantity.

### 11. Calculate monthly revenue

```sql
SELECT 
    TO_CHAR(order_date, 'Month') AS Month_Name,
    EXTRACT(MONTH FROM order_date) AS Month_Number,
    EXTRACT(YEAR FROM order_date) AS Year,
    SUM(total_amount) AS Total_Revenue
FROM orders
GROUP BY Month_Name, Month_Number, Year
ORDER BY Year, Month_Number;
```

**Objective:** Calculate the monthly revenue generated from all orders.

### 12. Calculate total revenue

```sql
SELECT SUM(total_amount) AS Total_Revenue
FROM orders;
```

**Objective:** Calculate the total overall revenue generated from all orders.


## Advance Problems

### 13. Total books sold for each genre

```sql
SELECT b.genre, SUM(o.quantity) AS Total_books_Sold
FROM Books AS b
JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.genre
ORDER BY Total_books_Sold DESC;
```

**Objective:** Determine the total number of books sold for each genre.

### 14. Average price of Fantasy books

```sql
SELECT ROUND(AVG(price), 2) AS Average_Book_Price
FROM Books WHERE genre = 'Fantasy';
```

**Objective:** Find the average price of books in the "Fantasy" genre.

### 15. Customers with at least 2 orders

```sql
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, COUNT(o.order_id) AS Total_Orders
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.phone, c.city, c.country
HAVING COUNT(o.order_id) >= 2
ORDER BY total_orders DESC;
```

**Objective:** Identify customers who have placed at least two orders.

### 16. Most frequently ordered book

```sql
SELECT b.book_id, b.title, b.author, b.genre, b.published_year, COUNT(o.book_id) AS Times_Ordered
FROM Books AS b
JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.author, b.genre, b.published_year
ORDER BY Times_Ordered DESC
LIMIT 1;
```

**Objective:** Find the most frequently ordered book.

### 17. Top 3 most expensive Fantasy books

```sql
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;
```

**Objective:** Show the top 3 most expensive books in the 'Fantasy' genre.

### 18. Total books sold by each author

```sql
SELECT b.author, SUM(o.quantity) AS Total_books_Sold
FROM Books AS b
JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY Total_books_Sold DESC;
```

**Objective:** Calculate the total quantity of books sold by each author.

### 19. Cities where customers spent over $30

```sql
SELECT c.city, SUM(o.total_amount) AS Total_Amount_Spent
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 30.00
ORDER BY c.city;
```

**Objective:** List the cities where the total spending by customers exceeds $30.

### 20. Customer who spent the most

```sql
SELECT c.customer_id, c.name AS Customer_Name, c.email, c.phone, c.city, c.country, SUM(o.total_amount) AS Total_Spending
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.phone, c.city, c.country
ORDER BY Total_Spending DESC
LIMIT 1;
```

**Objective:** Identify the customer who has spent the most money on all orders.

### 21. Calculate remaining stock after orders

```sql
SELECT b.book_id, b.title, b.author, b.genre, b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Stock
FROM Books AS b
LEFT JOIN Orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.author, b.genre, b.stock
ORDER BY b.book_id;
```

**Objective:** Calculate the remaining stock for each book after subtracting all ordered quantities.

## Findings and Conclusion

- **Genre Popularity:** Identified the genres with the highest number of books sold, providing insight into customer reading preferences.
- **Revenue Analysis:** Calculated the total revenue generated and broke it down by month to identify seasonal sales trends.
- **Customer Insights:** Pinpointed the top-spending customers and those who are most loyal (placed multiple orders).
- **Bestsellers:** Determined the most frequently ordered book and the author with the highest total sales.
- **Inventory Status:** Calculated the remaining stock for each book after fulfilling all orders, highlighting items that need restocking.
- **Geographical Reach:** The customer base is international, with orders coming from numerous countries around the world.

This SQL analysis extracts key business insights from bookstore data, demonstrating strong data querying and analysis skills. The project effectively transforms raw data into actionable intelligence for informed decision-making.

## Author - Swayanshu Jena

This project is part of my portfolio, showcasing my SQL skills in database querying, analysis, and generating business intelligence. Open to feedback, questions, or potential collaboration.

### Stay Updated

Make sure to follow me on social media:

- **Instagram**: [Follow me](https://www.instagram.com/sway_anshu_jena/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/swayanshu-jena)

Thank you for your support, and I look forward to connecting with you!
