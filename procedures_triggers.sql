
DELIMITER $$
-- PROCEDURE: PlaceOrderSimple
-- Places a single-item order: inserts Orders, OrderItems, and Payments inside a transaction.
CREATE PROCEDURE PlaceOrderSimple (
  IN p_customer_id INT,
  IN p_restaurant_id INT,
  IN p_partner_id INT,
  IN p_item_id INT,
  IN p_quantity INT,
  IN p_payment_method VARCHAR(10)
)
BEGIN
  DECLARE new_order_id INT;
  DECLARE total_price DECIMAL(10,2);

  START TRANSACTION;

  INSERT INTO Orders (customer_id, restaurant_id, delivery_partner_id, status)
  VALUES (p_customer_id, p_restaurant_id, p_partner_id, 'PLACED');
  SET new_order_id = LAST_INSERT_ID();

  INSERT INTO OrderItems (order_id, item_id, quantity)
  VALUES (new_order_id, p_item_id, p_quantity);

  SELECT price * p_quantity INTO total_price FROM MenuItems WHERE item_id = p_item_id;

  INSERT INTO Payments (order_id, amount, payment_method, payment_status)
  VALUES (new_order_id, total_price, UPPER(p_payment_method), 'PENDING');

  -- reduce stock; if insufficient stock, rollback
  UPDATE MenuItems SET stock = stock - p_quantity WHERE item_id = p_item_id AND stock >= p_quantity;
  IF ROW_COUNT() = 0 THEN
    -- not enough stock
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSUFFICIENT_STOCK';
  ELSE
    COMMIT;
    SELECT 'PlaceOrderd' as status;
  END IF;
END$$

-- TRIGGER: ReduceStockAfterOrder (after inserting order items)
CREATE TRIGGER ReduceStockAfterOrder
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
  UPDATE MenuItems
  SET stock = stock - NEW.quantity
  WHERE item_id = NEW.item_id;
END$$

-- TRIGGER: UpdateOrderAfterPayment
CREATE TRIGGER UpdateOrderAfterPayment
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
  IF NEW.payment_status = 'SUCCESS' THEN
    UPDATE Orders SET status = 'DELIVERED' WHERE order_id = NEW.order_id;
  END IF;
END$$

-- PROCEDURE: GetCustomerOrders
CREATE PROCEDURE GetCustomerOrders (
  IN p_customer_id INT
)
BEGIN
  SELECT o.order_id, o.order_date, o.status, p.amount, p.payment_status,
         GROUP_CONCAT(CONCAT(mi.name, ' x', oi.quantity) SEPARATOR ', ') AS items
  FROM Orders o
  JOIN Payments p ON o.order_id = p.order_id
  JOIN OrderItems oi ON o.order_id = oi.order_id
  JOIN MenuItems mi ON oi.item_id = mi.item_id
  WHERE o.customer_id = p_customer_id
  GROUP BY o.order_id, o.order_date, o.status, p.amount, p.payment_status
  ORDER BY o.order_date DESC;
END$$

-- PROCEDURE: GetRestaurantRevenue
CREATE PROCEDURE GetRestaurantRevenue (
  IN p_restaurant_id INT
)
BEGIN
  SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
         SUM(p.amount) AS total_revenue
  FROM Orders o
  JOIN Payments p ON o.order_id = p.order_id
  WHERE o.restaurant_id = p_restaurant_id
    AND p.payment_status = 'SUCCESS'
  GROUP BY month
  ORDER BY month DESC;
END$$

-- PROCEDURE: DemoTransactionRollback (example usage showing rollback behavior)
CREATE PROCEDURE DemoTransactionRollback()
BEGIN
  START TRANSACTION;
  UPDATE MenuItems SET stock = stock - 1000 WHERE item_id = 1; -- likely to fail
  -- simulate check
  IF (SELECT stock FROM MenuItems WHERE item_id = 1) < 0 THEN
    ROLLBACK;
  ELSE
    COMMIT;
  END IF;
END$$
DELIMITER ;
