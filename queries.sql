-- 1) Top 3 restaurants by rating
SELECT name, rating
FROM Restaurants
ORDER BY rating DESC
LIMIT 3;

-- 2) Most popular menu item (by number of times ordered)
SELECT mi.item_id, mi.name, COUNT(oi.order_item_id) AS times_ordered
FROM OrderItems oi
JOIN MenuItems mi ON oi.item_id = mi.item_id
GROUP BY mi.item_id, mi.name
ORDER BY times_ordered DESC
LIMIT 1;

-- 3) Monthly revenue per restaurant (only SUCCESS payments)
SELECT r.restaurant_id, r.name,
       DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.amount) AS revenue
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'SUCCESS'
GROUP BY r.restaurant_id, r.name, month
ORDER BY revenue DESC;

-- 4) Busiest delivery partner (by completed deliveries)
SELECT dp.partner_id, dp.name, COUNT(o.order_id) AS deliveries
FROM Orders o
JOIN DeliveryPartners dp ON o.delivery_partner_id = dp.partner_id
WHERE o.status = 'DELIVERED'
GROUP BY dp.partner_id, dp.name
ORDER BY deliveries DESC
LIMIT 1;

-- 5) Customer order history with items and payment status (for customer_id = ?)
-- Replace ? with desired customer_id
SELECT o.order_id, o.order_date, o.status, p.amount, p.payment_status,
       GROUP_CONCAT(CONCAT(mi.name, ' x', oi.quantity) SEPARATOR ', ') AS items
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN MenuItems mi ON oi.item_id = mi.item_id
WHERE o.customer_id = 1
GROUP BY o.order_id, o.order_date, o.status, p.amount, p.payment_status
ORDER BY o.order_date DESC;

-- 6) Customers who have never placed an order
SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 7) Restaurants with average order value > 500 (HAVING)
SELECT r.restaurant_id, r.name, AVG(p.amount) AS avg_order_value
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'SUCCESS'
GROUP BY r.restaurant_id, r.name
HAVING avg_order_value > 500
ORDER BY avg_order_value DESC;

-- 8) Data integrity check: Orders containing items from more than one restaurant
-- (Assuming data should only contain items from the same restaurant as the order)
SELECT o.order_id,
       COUNT(DISTINCT mi.restaurant_id) AS restaurants_in_order
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN MenuItems mi ON oi.item_id = mi.item_id
GROUP BY o.order_id
HAVING restaurants_in_order > 1;

-- 9) Items low on stock (threshold = 10)
SELECT item_id, name, stock
FROM MenuItems
WHERE stock <= 10
ORDER BY stock ASC;

-- 10) Top customers by spend (successful payments)
SELECT c.customer_id, c.name, SUM(p.amount) AS total_spend
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'SUCCESS'
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC
LIMIT 10;

-- 11) Delivered vs Cancelled orders percentage
SELECT
  SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered,
  SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled,
  COUNT(*) AS total_orders,
  ROUND(100*SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_delivered,
  ROUND(100*SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_cancelled
FROM Orders;

-- 12) Rank menu items by orders within each restaurant (RANK)
SELECT
  mi.restaurant_id,
  mi.name AS item_name,
  COUNT(oi.order_item_id) AS times_ordered,
  RANK() OVER (PARTITION BY mi.restaurant_id ORDER BY COUNT(oi.order_item_id) DESC) AS item_rank
FROM MenuItems mi
LEFT JOIN OrderItems oi ON mi.item_id = oi.item_id
GROUP BY mi.restaurant_id, mi.name
ORDER BY mi.restaurant_id, item_rank;

-- 13) Second highest priced menu item across all restaurants (without LIMIT)
SELECT MAX(price) AS second_highest_price
FROM MenuItems
WHERE price < (SELECT MAX(price) FROM MenuItems);

-- 14) Orders that were paid after being delivered (anomaly detection)
SELECT o.order_id, o.order_date, p.payment_status, o.status
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE o.status = 'DELIVERED' AND p.payment_status <> 'SUCCESS'
-- this finds delivered orders with non-success payments; adjust as needed
LIMIT 50;

-- 15) Customers with repeat cancellations (more than 1 cancelled order)
SELECT c.customer_id, c.name, COUNT(o.order_id) AS cancelled_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'CANCELLED'
GROUP BY c.customer_id, c.name
HAVING cancelled_count > 1;

-- 16) Revenue growth month-over-month for a restaurant (window functions)
-- Replace 1 with restaurant_id
WITH rev AS (
  SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(p.amount) AS revenue
  FROM Orders o
  JOIN Payments p ON o.order_id = p.order_id
  WHERE o.restaurant_id = 1 AND p.payment_status = 'SUCCESS'
  GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(((revenue - LAG(revenue) OVER (ORDER BY month))/NULLIF(LAG(revenue) OVER (ORDER BY month),0))*100,2) AS pct_change
FROM rev
ORDER BY month;

-- 17) Frequent item combinations (simple pair frequency, market-basket)
SELECT a.item_id AS item_a, b.item_id AS item_b, COUNT(*) AS pair_count
FROM OrderItems a
JOIN OrderItems b ON a.order_id = b.order_id AND a.item_id < b.item_id
GROUP BY a.item_id, b.item_id
ORDER BY pair_count DESC
LIMIT 10;

-- 18) Orders placed per city/location (grouping & formatting)
SELECT c.address AS city, COUNT(o.order_id) AS orders_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.address
ORDER BY orders_count DESC;

-- 19) Transaction demo: update stock and show rollback (example snippet to run manually)
-- START TRANSACTION;
-- UPDATE MenuItems SET stock = stock - 10 WHERE item_id = 1;
-- -- simulate error, then ROLLBACK or COMMIT;
-- ROLLBACK;

-- 20) Find customers who ordered from every restaurant (relational division)
-- Note: may be expensive on big data
SELECT customer_id, name
FROM Customers c
WHERE NOT EXISTS (
  SELECT 1 FROM Restaurants r
  WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.customer_id = c.customer_id AND o.restaurant_id = r.restaurant_id
  )
);

-- 21) Use EXPLAIN for a heavy query (example)
EXPLAIN FORMAT=JSON
SELECT mi.item_id, mi.name, COUNT(oi.order_item_id) AS times_ordered
FROM MenuItems mi
JOIN OrderItems oi ON mi.item_id = oi.item_id
GROUP BY mi.item_id, mi.name
ORDER BY times_ordered DESC;
