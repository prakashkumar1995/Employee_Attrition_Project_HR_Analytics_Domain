-- CREATE DATABASE Olist_Project;
# 3) Average number of days taken for order_delivered_customer_date for pet_shop

USE Olist_Project;
SELECT 
   p.product_category_name,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset i ON o.order_id = i.order_id
JOIN 
    olist_products_dataset p ON i.product_id = p.product_id
WHERE 
    p.product_category_name = 'pet_shop' 
    AND o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL;