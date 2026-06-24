
/*************************************************************************************************
                               TABLE CREATION AND DATA IMPORT
**************************************************************************************************/

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    created_at DATETIME,
    order_id INT,
    product_id INT,
    is_primary_item BIT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2)
);

SELECT * FROM order_items

BULK INSERT ORDER_ITEMS
FROM 'D:\Data Science\SQL queries\PROJECTS\factory\order_items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n')


/***********************************************************************************************/

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    user_id INT,
    primary_product_id INT,
    items_purchased INT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2)
    )

    SELECT * FROM ORDERS

BULK INSERT orders
FROM 'D:\Data Science\SQL queries\PROJECTS\factory\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    FORMAT = 'CSV'
);


/***********************************************************************************************/

CREATE TABLE REFUNDS(
    order_item_refund_id INT,
    created_at DATETIME,
    order_item_id INT,
    order_id INT,
    refund_amount_usd DECIMAL(10,2)
    )

SELECT * FROM REFUNDS

BULK INSERT REFUNDS
    FROM 'D:\Data Science\SQL queries\PROJECTS\factory\order_item_refunds.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
        )


/***********************************************************************************************/


CREATE TABLE PAGEVIEW(
    website_pageview_id INT,
    created_at DATETIME,
    website_session_id INT,
    pageview_url VARCHAR(255)
    )

    SELECT * FROM PAGEVIEW

    BULK INSERT pageview
    FROM 'D:\Data Science\SQL queries\PROJECTS\factory\website_pageviews.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001',
        TABLOCK
);

/***********************************************************************************************/

CREATE TABLE WEB_SESSIONS
    (
    website_session_id INT,
    created_at DATETIME,
    user_id INT,
    is_repeat_session INT,
    utm_source VARCHAR(255),
    utm_campaign VARCHAR(255),
    utm_content VARCHAR(255),
    device_type VARCHAR(255),
    http_referer VARCHAR(255)
    )

BULK INSERT WEB_SESSIONS
   FROM 'D:\Data Science\SQL queries\PROJECTS\factory\website_sessions.csv'
   WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001',
        TABLOCK
        )
   
   SELECT * FROM WEB_SESSIONS


/***********************************************************************************************/









