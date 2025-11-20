-- Drop existing tables to ensure a clean setup
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerId SERIAL PRIMARY KEY,
    CustomerEmail VARCHAR(255) NOT NULL UNIQUE,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerSurname VARCHAR(100) NOT NULL
);

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierId SERIAL PRIMARY KEY,
    SupplierName VARCHAR(150) NOT NULL
);

-- Create Products table
CREATE TABLE Products (
    ProductId SERIAL PRIMARY KEY,
    ProductCode VARCHAR(50) NOT NULL UNIQUE,
    ProductName VARCHAR(150) NOT NULL,
    ProductPrice NUMERIC(10,2) NOT NULL,
    SupplierId INT NOT NULL REFERENCES Suppliers(SupplierId)
);

-- Create Orders table with timestamp and timezone
CREATE TABLE Orders (
    OrderId SERIAL PRIMARY KEY,
    CustomerId INT NOT NULL REFERENCES Customers(CustomerId),
    OrderDate TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemId SERIAL PRIMARY KEY,
    OrderId INT NOT NULL REFERENCES Orders(OrderId),
    ProductId INT NOT NULL REFERENCES Products(ProductId),
    Quantity INT NOT NULL CHECK (Quantity > 0)
);

-- Insert data into Customers
INSERT INTO Customers (CustomerEmail, CustomerName, CustomerSurname) VALUES
( 'alice@example.com', 'Alice', 'Smith'),
( 'bob.j@example.com', 'Bob', 'Jones'),
( 'clara.lee@example.com', 'Clara', 'Lee'),
( 'david.chan@example.com', 'David', 'Chan');

-- Insert data into Suppliers
INSERT INTO Suppliers (SupplierId, SupplierName) VALUES
(1, 'TechGear'),
(2, 'ConnectPro'),
(3, 'KeyMasters'),
(4, 'VisionTech'),
(5, 'ErgoLift'),
(6, 'CableCo'),
(7, 'SoundWave');

-- Insert data into Products
INSERT INTO Products (ProductId, ProductCode, ProductName, ProductPrice, SupplierId) VALUES
(1, 'P001', 'Wireless Mouse', 25.99, 1),
(2, 'P002', 'USB-C Hub', 39.99, 2),
(3, 'P003', 'Mechanical Keyboard', 89.50, 3),
(4, 'P004', 'Webcam', 49.99, 4),
(5, 'P005', 'Laptop Stand', 29.99, 5),
(6, 'P006', 'HDMI Cable', 12.99, 6),
(7, 'P007', 'Bluetooth Speaker', 59.00, 7);

-- Insert data into Orders (explicit timestamps with timezone)
INSERT INTO Orders (CustomerId, OrderDate) VALUES
( 1, '2025-10-18T09:15:00+00'),
( 2, '2025-10-19T11:30:00+00'),
( 3, '2025-10-20T15:45:00+00'),
(4, '2025-10-21T17:20:00+00');

-- Insert data into OrderItems
INSERT INTO OrderItems (OrderId, ProductId, Quantity) VALUES
(1, 1, 1),  -- Alice ordered 1 Wireless Mouse
(1, 2, 2),  -- Bob ordered 2 USB-C Hubs
(2, 3, 1),  -- Clara ordered 1 Mechanical Keyboard
(3, 4, 1),  -- David ordered 1 Webcam
(3, 5, 1),  -- Clara ordered 1 Laptop Stand
(3, 6, 3),  -- Clara ordered 3 HDMI Cables
(4, 7, 2);  -- David ordered 2 Bluetooth Speakers