-- Creating database
CREATE DATABASE food_deliver;
USE food_deliver;

-- 1. Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- 2. Restaurants
CREATE TABLE Restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5)
);

-- 3. Menu Items
CREATE TABLE MenuItems (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    stock INT default 50,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- 4. Orders
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PLACED','PREPARING','DELIVERED','CANCELLED') DEFAULT 'PLACED',
    delivery_partner_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- 5. Order Items (junction table)
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- 6. Delivery Partners
CREATE TABLE DeliveryPartners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15) UNIQUE,
    vehicle_no VARCHAR(20)
);

-- 7. Payments
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH','UPI','CARD') NOT NULL,
    payment_status ENUM('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
