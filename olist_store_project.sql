# Olist Store Analysis project

#KPI 1 :Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
#KPI 2 :Number of Orders with review score 5 and payment type as credit card.
#KPI 3 :Average number of days taken for order_delivered_customer_date for pet_shop
#KPI 4 :Average price and payment values from customers of sao paulo city
#KPI 5 :Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

#KPI 1 :Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

USE olist_store_project;
#KPI 1 :Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT 
	CASE WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) 
    IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
	COUNT(distinct o.order_id) AS TotalOrders,
	round(SUM(p.payment_value)) AS TotalPayments,
    round(AVG(p.payment_value)) AS AveragePayment
FROM
	olist_orders_dataset o
JOIN
	olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY
	DayType;

#KPI 2 :Number of Orders with review score 5 and payment type as credit card.

SELECT
	count(distinct p.order_id) AS NumberOfOrders
FROM
	olist_order_payments_dataset p
JOIN
	olist_order_reviews_dataset r ON p.order_id = r.order_id
WHERE
	r.review_score = 5
    AND p.payment_type = 'credit_card';

#KPI 3 :Average number of days taken for order_delivered_customer_date for pet_shop

SELECT
	product_category_name,
    round(avg(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))) AS avg_delivery_time
FROM
	olist_orders_dataset o
JOIN
	olist_order_items_dataset i ON i.order_id = o.order_id
JOIN
	olist_products_dataset p ON p.product_id = i.product_id
WHERE
	p.product_category_name = 'pet_shop'
    AND o.order_delivered_customer_date IS NOT NULL;

#KPI 4 :Average price and payment values from customers of sao paulo city

SELECT
	round(AVG(i.price)) AS average_price,
    round(AVG(p.payment_value)) AS average_payment
FROM
	olist_customers_dataset c
JOIN
	olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN
	olist_order_items_dataset i ON o.order_id = i.order_id
JOIN
	olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE
	c.customer_city = 'sao paulo'  ;
    
#KPI 5 :Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT
	round(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),0) AS AvgShippingDays,
    review_score
FROM
	olist_orders_dataset o
JOIN
	olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
	order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
GROUP BY
	review_score;