use burger_bash;

CREATE TABLE burger_names(
   burger_id   INTEGER  NOT NULL PRIMARY KEY 
  ,burger_name VARCHAR(10) NOT NULL
);
INSERT INTO burger_names(burger_id,burger_name) VALUES (1,'Meatlovers');
INSERT INTO burger_names(burger_id,burger_name) VALUES (2,'Vegetarian');

CREATE TABLE runner_orders(
  order_id     INTEGER  NOT NULL PRIMARY KEY,
  runner_id    INTEGER  NOT NULL,
  pickup_time  datetime,
  distance     VARCHAR(7),
  duration     VARCHAR(10),
  cancellation VARCHAR(23),
);
INSERT INTO runner_orders VALUES (1,1,'2021-01-01 18:15:34','20km','32 minutes',NULL);
INSERT INTO runner_orders VALUES (2,1,'2021-01-01 19:10:54','20km','27 minutes',NULL);
INSERT INTO runner_orders VALUES (3,1,'2021-01-03 00:12:37','13.4km','20 mins',NULL);
INSERT INTO runner_orders VALUES (4,2,'2021-01-04 13:53:03','23.4','40',NULL);
INSERT INTO runner_orders VALUES (5,3,'2021-01-08 21:10:57','10','15',NULL);
INSERT INTO runner_orders VALUES (6,3,NULL,NULL,NULL,'Restaurant Cancellation');
INSERT INTO runner_orders VALUES (7,2,'2021-01-08 21:30:45','25km','25mins',NULL);
INSERT INTO runner_orders VALUES (8,2,'2021-01-10 00:15:02','23.4 km','15 minute',NULL);
INSERT INTO runner_orders VALUES (9,2,NULL,NULL,NULL,'Customer Cancellation');
INSERT INTO runner_orders VALUES (10,1,'2021-01-11 18:50:20','10km','10minutes',NULL);
select * from runner_orders

CREATE TABLE burger_runner(
   runner_id   INTEGER  NOT NULL PRIMARY KEY 
  ,registration_date date NOT NULL
);
INSERT INTO burger_runner VALUES (1,'2021-01-01');
INSERT INTO burger_runner VALUES (2,'2021-01-03');
INSERT INTO burger_runner VALUES (3,'2021-01-08');
INSERT INTO burger_runner VALUES (4,'2021-01-15');

CREATE TABLE customer_orders(
   order_id    INTEGER  NOT NULL 
  ,customer_id INTEGER  NOT NULL
  ,burger_id    INTEGER  NOT NULL
  ,exclusions  VARCHAR(4)
  ,extras      VARCHAR(4)
  ,order_time  datetime NOT NULL
);
INSERT INTO customer_orders VALUES (1,101,1,NULL,NULL,'2021-01-01 18:05:02');
INSERT INTO customer_orders VALUES (2,101,1,NULL,NULL,'2021-01-01 19:00:52');
INSERT INTO customer_orders VALUES (3,102,1,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orders VALUES (3,102,2,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orders VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (4,103,2,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (5,104,1,NULL,'1','2021-01-08 21:00:29');
INSERT INTO customer_orders VALUES (6,101,2,NULL,NULL,'2021-01-08 21:03:13');
INSERT INTO customer_orders VALUES (7,105,2,NULL,'1','2021-01-08 21:20:29');
INSERT INTO customer_orders VALUES (8,102,1,NULL,NULL,'2021-01-09 23:54:33');
INSERT INTO customer_orders VALUES (9,103,1,'4','1, 5','2021-01-10 11:22:59');
INSERT INTO customer_orders VALUES (10,104,1,NULL,NULL,'2021-01-11 18:34:49');
INSERT INTO customer_orders VALUES (10,104,1,'2, 6','1, 4','2021-01-11 18:34:49');

select * from customer_orders

select * from burger_runner

select * from runner_orders

select * from burger_names


--1. How many burgers were ordered?
SELECT COUNT(*) AS total_burgers_ordered
FROM customer_orders;

--3. How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

--4. How many of each type of burger was delivered?

SELECT 
    bn.burger_name,
    COUNT(co.burger_id) AS delivered_burger_count
FROM 
    customer_orders co
JOIN 
    runner_orders ro ON co.order_id = ro.order_id
JOIN 
    burger_names bn ON co.burger_id = bn.burger_id
WHERE 
    ro.cancellation IS NULL
GROUP BY 
    co.burger_id, bn.burger_name;

--6. What was the maximum number of burgers delivered in a single order?
SELECT TOP 1
    co.order_id,
    COUNT(co.burger_id) AS burger_count
FROM 
    customer_orders co
JOIN 
    runner_orders ro ON co.order_id = ro.order_id
WHERE 
    ro.cancellation IS NULL
GROUP BY 
    co.order_id
ORDER BY 
    burger_count DESC;

--8.What was the total volume of burgers ordered for each hour of the day?

SELECT 
    DATEPART(hour, co.order_time) AS order_hour,
    COUNT(co.burger_id) AS total_burgers_ordered
FROM 
    customer_orders co
GROUP BY 
    DATEPART(hour, co.order_time)
ORDER BY 
    order_hour;


 