/* ========================
   VIEWS (read-only convenience views)
   ======================== */

-- Monthly revenue per restaurant (SUCCESS payments only)
CREATE OR REPLACE VIEW vw_monthly_revenue_per_restaurant AS
SELECT r.restaurant_id,
       r.name AS restaurant_name,
       DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.amount) AS revenue
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'SUCCESS'
GROUP BY r.restaurant_id, restaurant_name, month;

-- Popular items with counts
CREATE OR REPLACE VIEW vw_popular_items AS
SELECT mi.item_id, mi.name AS item_name, mi.restaurant_id, COUNT(oi.order_item_id) AS times_ordered
FROM MenuItems mi
LEFT JOIN OrderItems oi ON mi.item_id = oi.item_id
GROUP BY mi.item_id, mi.name, mi.restaurant_id;

-- Customer order summary (counts, spend, last order)
CREATE OR REPLACE VIEW vw_customer_order_summary AS
SELECT c.customer_id, c.name AS customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COALESCE(SUM(p.amount), 0) AS total_spent,
       MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.name;

-- Delivery partner performance
CREATE OR REPLACE VIEW vw_delivery_partner_stats AS
SELECT dp.partner_id, dp.name AS partner_name,
       COUNT(o.order_id) AS total_assigned,
       SUM(CASE WHEN o.status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_count,
       SUM(CASE WHEN o.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_count
FROM DeliveryPartners dp
LEFT JOIN Orders o ON dp.partner_id = o.delivery_partner_id
GROUP BY dp.partner_id, dp.name;

-- Low stock items view
CREATE OR REPLACE VIEW vw_low_stock_items AS
SELECT item_id, name, stock
FROM MenuItems
WHERE stock <= 10;

-- Order details flattened (items concatenated) for quick reporting
CREATE OR REPLACE VIEW vw_order_details AS
SELECT o.order_id,
       o.order_date,
       c.customer_id, c.name AS customer_name,
       r.restaurant_id, r.name AS restaurant_name,
       p.amount AS payment_amount, p.payment_status,
       GROUP_CONCAT(CONCAT(mi.name, ' x', oi.quantity) SEPARATOR ', ') AS items
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
LEFT JOIN Payments p ON o.order_id = p.order_id
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN MenuItems mi ON oi.item_id = mi.item_id
GROUP BY o.order_id, o.order_date, c.customer_id, c.name, r.restaurant_id, r.name, p.amount, p.payment_status;

/* ========================
   USAGE NOTES
   ======================== */
-- 1) Run this file after schema.sql and data.sql (i.e. after tables & sample data exist).
-- 2) Use EXPLAIN on heavy queries to verify index usage and refine indexes.
-- 3) Avoid adding redundant indexes; each index costs write performance.
-- 4) If database size grows, consider partitioning (by order_date) and more advanced tuning.

