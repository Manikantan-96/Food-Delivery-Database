/* ========================
   INDEXES
   ======================== */
-- MenuItems optimizations
CREATE INDEX  idx_menuitems_name ON MenuItems(name);
CREATE INDEX  idx_menuitems_restaurant ON MenuItems(restaurant_id);
CREATE INDEX   idx_menuitems_stock ON MenuItems(stock);
CREATE FULLTEXT INDEX  ft_menuitems_name ON MenuItems(name);

-- Orders & joins
CREATE INDEX  idx_orders_customer ON Orders(customer_id);
CREATE INDEX  idx_orders_restaurant_date ON Orders(restaurant_id, order_date);
CREATE INDEX  idx_orders_status ON Orders(status);
CREATE INDEX  idx_orders_date ON Orders(order_date);

-- OrderItems for join performance
CREATE INDEX  idx_orderitems_order_item ON OrderItems(order_id, item_id);
CREATE INDEX  idx_orderitems_item ON OrderItems(item_id);

-- Payments & DeliveryPartners
CREATE INDEX  idx_payments_order ON Payments(order_id);
CREATE INDEX  idx_payments_status ON Payments(payment_status);
CREATE INDEX  idx_deliverypartners_phone ON DeliveryPartners(phone);

-- Restaurants
CREATE INDEX  idx_restaurants_location ON Restaurants(location);
CREATE INDEX  idx_restaurants_rating ON Restaurants(rating);

/* Note: InnoDB automatically creates indexes for PRIMARY KEY and also for
   FOREIGN KEY columns if they are used in constraints; still explicit
   indexes help complex queries and composite filters. Avoid over-indexing. */