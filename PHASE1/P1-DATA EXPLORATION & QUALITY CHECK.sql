
/* -----------------------------------------------------------------
			PHASE 1 — DATA EXPLORATION & QUALITY CHECKS
 -------------------------------------------------------------------*/

 /*

 
 -*******************************- 1. Exploration Framework -*******************************-


For every table, run three checks:

•	Row count — understand dataset volume
•	Date range — understand the time period covered
•	NULL checks on critical columns — identify data quality issues

-----------------------------------------------------------------------------------------------*/

--				*************** 1. WEB_SESSIONS   ***************


SELECT * from WEB_SESSIONS

-- TOTAL_ROWS
SELECT COUNT(*) AS TOTAL_ROWS FROM WEB_SESSIONS

-- FIRST & LAST ORDERDATE
SELECT 
	MIN(created_at) AS FIRST_ORDER,
	MAX(created_at) AS LAST_ORDER
FROM WEB_SESSIONS

-- UTM NULL

SELECT 
 COUNT(CASE WHEN utm_source IS NULL OR UTM_SOURCE = 'NULL' THEN 1
  END) AS TOTAL_NULL
FROM WEB_SESSIONS


SELECT DISTINCT UTM_SOURCE FROM WEB_SESSIONS

------------------------------------------------------------------------------------------------

--				*************** 2. ORDERS   ***************

-- ROW COUNT

SELECT COUNT(*) AS TOTAL_ROWS FROM ORDERS

-- DATE RANGE
SELECT 
	MIN(CREATED_AT) AS FIRST_ORDER,
	MAX(CREATED_AT) AS LAST_ORDER
FROM ORDERS

-- NULL ANALYSIS
SELECT 
	COUNT(CASE WHEN price_usd IS NULL THEN	1 END) AS PRICE_NULL,
	COUNT(CASE WHEN cogs_usd IS NULL THEN	1 END) AS COGS_NULL,
	COUNT(CASE WHEN website_session_id IS NULL THEN	1 END) AS WEBSITE_SESSION_NULL
FROM ORDERS

--------------------------------------------------------------------------------------------

--				*************** 3. ORDER ITEMS   ***************

	SELECT * FROM order_items 

	-- ROW COUNT

	SELECT COUNT(*) AS ROW_COUNT FROM order_items

	-- DATE RANGE
	SELECT 
		min(CREATED_AT) AS FIRST_ORDER,
		MAX(CREATED_AT) AS LAST_ORDER
	FROM order_items

	-- NULL CHECK
	SELECT 
		COUNT(CASE WHEN ORDER_ID IS NULL THEN 1 END) AS ORDER_ID_NULL,
		COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS PRODUCT_ID_NULL,
		COUNT(CASE WHEN price_usd IS NULL THEN 1 END) AS PRICE_NULL,
		COUNT(CASE WHEN cogs_usd IS NULL THEN 1 END) AS COGS_NULL
	FROM order_items


--------------------------------------------------------------------------------------------

--				*************** 4. REFUNDS   ***************

SELECT * FROM REFUNDS

-- ROW COUNT

SELECT COUNT(*) AS TOTAL_ROWS FROM REFUNDS

-- DATE RANGE

SELECT 
MIN(CREATED_AT) AS FIRST_ORDER,
MAX(CREATED_AT) AS LAST_ORDER
FROM REFUNDS

-- NULL CHECK

SELECT 
	COUNT(CASE WHEN ORDER_ITEM_ID IS NULL THEN 1 END) AS ORDER_ITEM_ID_NULL,
	COUNT(CASE WHEN refund_amount_usd IS NULL THEN 1 END) AS refund_amount_usd_NULL
FROM REFUNDS

--------------------------------------------------------------------------------------------

--				*************** 5. PAGEVIEW   ***************


SELECT * FROM PAGEVIEW

-- ROW COUNT
SELECT COUNT(*) AS TOTAL_ROWS FROM PAGEVIEW

-- DATE RANGE
SELECT MIN(CREATED_AT) AS FIRST_ORDER,MAX(CREATED_AT) AS LAST_ORDER FROM PAGEVIEW

-- NULL CHECK 
SELECT COUNT(CASE WHEN website_session_id IS NULL THEN 1 END) AS SESSION_NULL, 
	   COUNT(CASE WHEN PAGEVIEW_URL IS NULL THEN 1 END ) URL_NULL
FROM PAGEVIEW

--------------------------------------------------------------------------------------------

--				*************** 6. PRODUCTS   ***************


SELECT * FROM products

-- ROW COUNT
SELECT COUNT(*) AS TOTAL_ROW FROM products

-- DATE RANGE
SELECT MIN(CREATED_AT) AS FIRST_DATE,MAX(CREATED_AT) AS LAST_DATE FROM products

-- NULL CHECK
SELECT 
	COUNT(CASE WHEN PRODUCT_ID IS NULL THEN 1 END ) AS PRODUCT_ID_NULL,
	COUNT(CASE WHEN PRODUCT_NAME IS NULL THEN 1 END) AS NAME_NUL
FROM products



