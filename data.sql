-- Customers
INSERT INTO Customers (name, phone, email, address) VALUES
('Arjun Mehta', '9876543210', 'arjun@example.com', 'Bangalore'),
('Meena Sharma', '9123456780', 'meena@example.com', 'Hyderabad'),
('Ravi Kumar', '9988776655', 'ravi@example.com', 'Delhi'),
('Priya Nair', '9765432109', 'priya@example.com', 'Chennai'),
('Karthik Reddy', '9112233445', 'karthik@example.com', 'Mumbai');

-- Restaurants
INSERT INTO Restaurants (name, location, rating) VALUES
('Spice Hub', 'Bangalore', 4.5),
('Pizza World', 'Hyderabad', 4.2),
('Burger Junction', 'Delhi', 4.0),
('Healthy Bites', 'Chennai', 4.7),
('Tandoori Treats', 'Mumbai', 4.3);

-- Menu Items
INSERT INTO MenuItems (restaurant_id, name, price, available, stock) VALUES
(1, 'Paneer Butter Masala', 220.00, TRUE, 30),
(1, 'Veg Biryani', 180.00, TRUE, 50),
(2, 'Margherita Pizza', 250.00, TRUE, 40),
(2, 'Farmhouse Pizza', 350.00, TRUE, 20),
(3, 'Chicken Burger', 150.00, TRUE, 60),
(3, 'Veg Burger', 120.00, TRUE, 70),
(4, 'Quinoa Salad', 200.00, TRUE, 25),
(4, 'Smoothie Bowl', 180.00, TRUE, 30),
(5, 'Tandoori Chicken', 300.00, TRUE, 35),
(5, 'Butter Naan', 40.00, TRUE, 100);

-- Delivery Partners
INSERT INTO DeliveryPartners (name, phone, vehicle_no) VALUES
('Suresh', '9000011111', 'KA01AB1234'),
('Anita', '9000022222', 'TS09CD5678'),
('Mohit', '9000033333', 'DL05EF9101'),
('Lakshmi', '9000044444', 'TN22GH3456'),
('Rajesh', '9000055555', 'MH12JK7890');

-- Orders
INSERT INTO Orders (customer_id, restaurant_id, status, delivery_partner_id) VALUES
(1, 1, 'DELIVERED', 1),
(2, 2, 'DELIVERED', 2),
(3, 3, 'CANCELLED', 3),
(4, 4, 'DELIVERED', 4),
(5, 5, 'PLACED', 5),
(1, 2, 'DELIVERED', 2),
(2, 3, 'DELIVERED', 3);

-- Order Items
INSERT INTO OrderItems (order_id, item_id, quantity) VALUES
(1, 1, 2),  -- Arjun ordered 2 Paneer Butter Masala
(1, 2, 1),  -- Arjun also 1 Veg Biryani
(2, 3, 1),  -- Meena ordered 1 Margherita Pizza
(2, 4, 2),  -- Meena also 2 Farmhouse Pizzas
(3, 5, 1),  -- Ravi ordered Chicken Burger (cancelled later)
(4, 7, 1),  -- Priya ordered Quinoa Salad
(5, 9, 2),  -- Karthik ordered Tandoori Chicken
(6, 3, 1),  -- Arjun ordered Margherita Pizza
(6, 6, 2),  -- Arjun also 2 Veg Burgers
(7, 5, 1);  -- Meena ordered Chicken Burger

-- Payments
INSERT INTO Payments (order_id, amount, payment_method, payment_status) VALUES
(1, 620.00, 'CARD', 'SUCCESS'),  -- Arjun’s order success
(2, 950.00, 'UPI', 'SUCCESS'),   -- Meena’s order success
(3, 150.00, 'CASH', 'FAILED'),   -- Ravi’s order failed (cancelled)
(4, 200.00, 'CARD', 'SUCCESS'),  -- Priya’s order success
(5, 600.00, 'UPI', 'PENDING'),   -- Karthik’s order still pending
(6, 490.00, 'UPI', 'SUCCESS'),   -- Arjun’s second order
(7, 150.00, 'CARD', 'SUCCESS');  -- Meena’s burger order
