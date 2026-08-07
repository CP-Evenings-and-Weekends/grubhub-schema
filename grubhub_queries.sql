SELECT * FROM public.bridge_order_item_id;
SELECT * FROM public.dim_cuisine;
SELECT * FROM public.dim_item;
SELECT * FROM public.dim_restaurant;
SELECT * FROM public.dim_user;
SELECT * FROM public.fact_order;


-- 1. Top spending user per restaurant (window function - RANK() + PARTITION BY)


WITH order_totals AS (
	SELECT 
			fo.id AS order_id, 
			fo.dim_rest_id, 
			fo.dim_user_id,
			SUM(boi.quantity * di.price) AS order_total
	FROM 	fact_order fo  
	JOIN 	bridge_order_item_id boi 
			ON boi.fact_order_id = fo.id 
	JOIN 	dim_item di on di.id = boi.item_id  
	GROUP BY fo.id, fo.dim_rest_id, fo.dim_user_id
	
), 
user_spend AS (
	SELECT 
			dim_rest_id, 
			dim_user_id,
			SUM(order_total) AS total_spent, 
			RANK() OVER (PARTITION BY dim_rest_id ORDER BY SUM(order_total) DESC) AS spend_rank
	FROM 	order_totals
	GROUP BY dim_rest_id, dim_user_id
)
SELECT 
		dr."Name" AS restaurant,
		u.email, 
		us.total_spent
FROM 	user_spend us
JOIN 	dim_restaurant dr 
		ON dr.id = us.dim_rest_id
JOIN 	dim_user u 
		ON u.id = us.dim_user_id
WHERE 
		spend_rank = 1
ORDER BY 
	total_spent DESC;


-- 2. Running monthly order count per cuisine (window function - running total)

SELECT 
	dim_cuisine_id,
	date_trunc('month', order_date_time) AS order_month,
	COUNT(*) AS orders_this_month,
	SUM(COUNT(*)) OVER (
		PARTITION BY dim_cuisine_id
		ORDER BY date_trunc('month', order_date_time)
	) AS running_total
FROM fact_order  
GROUP BY 
	dim_cuisine_id,
	date_trunc('month', order_date_time)
ORDER BY 
	dim_cuisine_id, order_month;


-- 3. Users who have never ordered from a given cuisine (correlated subquery / NOT EXISTS)

SELECT 
	u.email, 
	u.first_name,
	u.last_name
FROM dim_user u
WHERE NOT EXISTS (
	SELECT 	1
	FROM 	fact_order fo
	JOIN 	dim_cuisine c
	ON 		c.id = fo.dim_cuisine_id
	WHERE 	fo.dim_user_id = u.ID 
		AND c.cuisine_type = 'Thai'
);
	

-- 4. Most ordered item per cuisine, with rank (window function - ROW_NUMBER() tie-break)

WITH item_counts AS (
    SELECT
        fo.dim_cuisine_id,
        di.item_name,
        SUM(boi.quantity) AS total_qty,
        ROW_NUMBER() OVER (
            PARTITION BY fo.dim_cuisine_id
            ORDER BY SUM(boi.quantity) DESC
        ) AS rn
    FROM fact_order fo
    JOIN bridge_order_item_id boi ON boi.fact_order_id = fo.id
    JOIN dim_item di ON di.id = boi.item_id
    GROUP BY fo.dim_cuisine_id, di.item_name
)
SELECT c.cuisine_type, ic.item_name, ic.total_qty
FROM item_counts ic
JOIN dim_cuisine c ON c.id = ic.dim_cuisine_id
WHERE rn = 1
ORDER BY c.cuisine_type;


-- 5. Restaurants with above average order value (Subquery HAVING)

SELECT
    r."Name",
    COUNT(DISTINCT fo.id) AS order_count,
    AVG(order_total.total) AS avg_order_value
FROM dim_restaurant r
JOIN fact_order fo ON fo.dim_rest_id = r.id
JOIN (
    SELECT
        	boi.fact_order_id,
        	SUM(boi.quantity * di.price) AS total
    FROM 	bridge_order_item_id boi
    JOIN 	dim_item di ON di.id = boi.item_id
    GROUP BY boi.fact_order_id
) order_total 
	ON order_total.fact_order_id = fo.id
GROUP BY r."Name"
HAVING AVG(order_total.total) > (
    SELECT 	AVG(boi2.quantity * di2.price)
    FROM 	bridge_order_item_id boi2
    JOIN 	dim_item di2 ON di2.id = boi2.item_id
);