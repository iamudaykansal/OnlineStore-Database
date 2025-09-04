-- Online Store Database (DDL + DML)

/* ==========================
   DATABASE SCHEMA (DDL)
   ========================== */

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    stock_quantity INT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order Items Table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

/* ==========================
   SAMPLE DATA + QUERIES (DML)
   ========================== */

-- Insert Customers
INSERT INTO Customers (name, email, phone, address)
VALUES 
('Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Delhi, India'),
('Priya Verma', 'priya@gmail.com', '9876501234', 'Mumbai, India');

-- Insert Products
INSERT INTO Products (name, description, price, stock_quantity)
VALUES 
('Laptop', '15-inch, 16GB RAM', 75000.00, 10),
('Smartphone', '5G, 128GB Storage', 30000.00, 20),
('Headphones', 'Wireless, Noise Cancelling', 5000.00, 50);

-- Create Order
INSERT INTO Orders (customer_id, status)
VALUES (1, 'pending');

-- Add Items to Order
INSERT INTO Order_Items (order_id, product_id, quantity, subtotal)
VALUES 
(1, 1, 1, 75000.00),   -- 1 Laptop
(1, 3, 2, 10000.00);   -- 2 Headphones

-- Update Product Stock
UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1;
UPDATE Products SET stock_quantity = stock_quantity - 2 WHERE product_id = 3;

-- Payment for Order
INSERT INTO Payments (order_id, amount, payment_method)
VALUES (1, 85000.00, 'Credit Card');

-- Update Order Status
UPDATE Orders SET status = 'shipped' WHERE order_id = 1;

-- Reports / Queries

-- 1. List all orders with customer details
SELECT o.order_id, c.name, c.email, o.order_date, o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 2. Show products in order 1
SELECT oi.order_item_id, p.name, oi.quantity, oi.subtotal
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

-- 3. Total sales by product
SELECT p.name, SUM(oi.quantity) AS total_sold, SUM(oi.subtotal) AS revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.name;
