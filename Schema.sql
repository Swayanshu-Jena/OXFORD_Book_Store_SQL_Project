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
