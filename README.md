 # 🍔 Food Delivery Database (MySQL Project)

This project is a *Food Delivery System Database* built with *MySQL*.  
It demonstrates schema design, sample data, complex queries, transactions, triggers, stored procedures, indexes, and views.  
Aimed to showcase *SQL + MySQL skills* for backend developer interviews and portfolio.

---

## 📂 Project Structure

food_delivery_db/
├── schema.sql                 Database schema (tables + sample data)
├── queries.sql                20+ analytical and interview-style queries
├── procedures_triggers.sql    Stored procedures, triggers, transactions
├── indexes.sql                Indexes for optimization
├── views.sql                  views for faster analysis
├── docs/
│   ├── ER_Diagram.png         ER diagram of the system
│   └── screenshots/           Query outputs, views, procedures results
└── README.md

---

## 🗄 Database Design
- *Customers*: Stores customer details  
- *Restaurants*: Partner restaurants with ratings  
- *MenuItems*: Items offered by restaurants with stock tracking  
- *Orders & OrderItems*: Orders placed by customers, linked to items  
- *DeliveryPartners*: Riders handling deliveries  
- *Payments*: Tracks payment method and status  

📌 Full ER Diagram available in docs/ER_Diagram.png

---

## 🔑 Features
✅ Proper *schema with normalization*  
✅ *Sample data* for demo/testing  
✅ *20+ queries* (aggregations, joins, subqueries, window functions, anomalies, market-basket analysis)  
✅ *Stored Procedures* (e.g., PlaceOrder with stock check, revenue reports)  
✅ *Triggers* (stock updates, order status updates)  
✅ *Transactions* (commit/rollback examples)  
✅ *Indexes* (single, composite, fulltext)  
✅ *Views* (monthly revenue, customer summary, popular items, low stock, etc.)  

---

## 📊 Example Queries
- Top 3 restaurants by rating  
- Most popular menu item  
- Monthly revenue per restaurant  
- Delivered vs Cancelled order ratio  
- Frequent item combinations (market basket analysis)  
- Customers who ordered from *all restaurants* (relational division)

👉 Full list inside queries.sql

---

## ⚙ How to Run
1. Install MySQL 8.x  
2. Clone this repo  
3. Run in order:
   ```sql
   SOURCE schema.sql;
   SOURCE queries.sql;
   SOURCE procedures_triggers.sql;
   SOURCE Indexes.sql;
   SOURCE views.sql;
4. Explore data using:

SHOW TABLES;
SELECT * FROM Customers;




---

## 📷 Screenshots

Screenshots of:

Queries

Views

Stored Procedures

Indexes


### 📌 Available inside docs/screenshots/


---

## 💡 Future Improvements

Add stored functions

Role-based access (admin, customer, delivery partner)

Partitioning large tables by order_date

Integration with a sample Java/Spring Boot backend

--

## Tags

mysql, sql, database, food-delivery, backend, triggers, stored-procedures, views, indexes, analytics, springboot-ready

---

### ✍ Author: Deevanooru Manikantan
### 📌 GitHub:https://github.com/Manikantan-96/Food-Delivery-Database

---  

