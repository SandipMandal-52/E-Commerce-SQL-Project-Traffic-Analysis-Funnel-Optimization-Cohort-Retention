/****************************************************************************************
						Phase 4: Product and Profitabilty Analysis 
*****************************************************************************************/
USE WEBANALYSIS
/*
Now write the query showing for each product:

Product name
Total units sold
Total revenue
Total COGS
Total profit
Profit margin %
*/


WITH CTE1 AS (

SELECT 
	P.product_name,
	O.PRICE_USD,
	COUNT(ORDER_ITEM_ID) AS TOTAL_UNIT_SOLD,
	SUM(PRICE_USD) AS TOTAL_REVENUE,
	SUM(COGS_USD) AS TOTAL_COGS,
	SUM(PRICE_USD) - SUM(COGS_USD) AS TOTAL_PROFIT,
	(SUM(PRICE_USD) - SUM(COGS_USD)) / SUM(PRICE_USD) * 100.0 AS PROFIT_PERC
FROM order_items AS O
LEFT JOIN products AS P
ON P.product_id = O.product_id
GROUP BY P.product_name , O.price_usd
) 
-- PERCENTAGE OF REVENUE BY PRODUCTS
SELECT 
	PRODUCT_NAME,
	PRICE_USD,
	SUM(TOTAL_REVENUE) OVER() AS OVERALL_REVENUE,
	TOTAL_REVENUE,
	TOTAL_REVENUE / SUM(TOTAL_REVENUE) OVER() * 100.0 AS PERCN
FROM CTE1


/****************************************************************************************
						Phase 5: REFUND Analysis 
*****************************************************************************************/

SELECT * FROM REFUNDS

/*
Now build the refund analysis.

Which tables do you need to calculate refund rate per product? 
Tell me the tables and join keys before writing the query.
-------------------------------------------------------
order_item_refunds >  order_items >  products
-------------------------------------------
Now write the query showing per product:

Total units sold
Total refunds
Refund rate %
Total refund amount lost
--------------------------------------------*/

SELECT 
P.product_name,
COUNT(O.order_item_id) AS TOTAL_UNIT,
COUNT(R.ORDER_ITEM_REFUND_ID) AS TOTAL_REFUND,
(COUNT(R.ORDER_ITEM_REFUND_ID) * 100.0 ) / COALESCE (COUNT(O.order_item_id),0) AS REFUND_RATE,
SUM(REFUND_AMOUNT_USD) AS TOTAL_REFUND_AMOUNT
FROM order_items AS O
LEFT JOIN REFUNDS AS R
ON R.order_item_id = O.order_item_id
LEFT JOIN products AS P
ON O.product_id = P.product_id
GROUP BY P.product_name



/****************************************************************************************
						Phase 4 & 5: COMBINE Analysis 
*****************************************************************************************/

/*

Product name
Gross revenue
Total refunds amount
Net revenue (gross - refunds)
Total COGS
Net profit (net revenue - COGS)
Net margin %

*/

USE WEBANALYSIS

WITH CTE1 AS 
( 
SELECT
	P.product_name,
	SUM(O.PRICE_USD) AS GROSS_REVENUE,
	SUM(R.REFUND_AMOUNT_USD) AS TOTAL_REFUND,
	SUM(O.PRICE_USD) - SUM(R.REFUND_AMOUNT_USD) AS NET_REVENUE,
	SUM(O.COGS_USD) AS TOTAL_COGS,
	(SUM(O.PRICE_USD) - SUM(R.REFUND_AMOUNT_USD)) - SUM(O.COGS_USD) AS NET_PROFIT
FROM order_items AS O
LEFT JOIN REFUNDS AS R
ON O.order_item_id = R.order_item_id
LEFT JOIN products AS P
ON O.product_id = P.product_id
GROUP BY P.product_name
)
SELECT 
	*,
	NET_PROFIT / GROSS_REVENUE * 100.0 AS NET_MAGIN_PER
	FROM CTE1