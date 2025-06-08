CREATE DATABASE Ecommerce;
USE Ecommerce;

-- 2. Create Tables

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at DATE
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 3. Insert Sample Data

INSERT INTO Customers (name, email, created_at) VALUES
('Alice Smith', 'alice@example.com', '2024-01-15'),
('Bob Johnson', 'bob@example.com', '2024-02-10'),
('Charlie Brown', 'charlie@example.com', '2024-03-05');

INSERT INTO Products (name, category, price, stock) VALUES
('Laptop', 'Electronics', 1200.00, 10),
('Headphones', 'Electronics', 200.00, 50),
('Coffee Mug', 'Home', 15.00, 100),
('Notebook', 'Stationery', 5.00, 200);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-04-01', 1215.00),
(2, '2024-04-03', 205.00),
(1, '2024-05-10', 10.00);

INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 3, 1, 15.00),
(2, 2, 1, 200.00),
(2, 4, 1, 5.00),
(3, 4, 2, 5.00);
SELECT * FROM CUSTOMERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERS;
SELECT * FROM ORDERITEMS;

-- 4. Sample Queries
-- A. List customers who registered in 2024
SELECT customer_id, name, email, created_at
FROM Customers
WHERE YEAR(created_at) = 2024
ORDER BY created_at DESC;

-- B. Total spent by each customer
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- C. Products that have never been ordered (LEFT JOIN)
SELECT p.product_id, p.name
FROM Products p
LEFT JOIN OrderItems oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- D. Customers who spent more than average
SELECT customer_id, name
FROM Customers
WHERE customer_id IN (
  SELECT o.customer_id
  FROM Orders o
  GROUP BY o.customer_id
  HAVING SUM(o.total_amount) > (
    SELECT AVG(total_amount) FROM Orders
  )
);

-- E. View for Monthly Sales Summary
CREATE OR REPLACE VIEW Monthly_Sales_Summary AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(total_amount) AS revenue,
       COUNT(*) AS order_count
FROM Orders
GROUP BY month;
SELECT * FROM ORDERS;

-- F. Index for Optimization
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
SELECT * FROM ORDERS;








