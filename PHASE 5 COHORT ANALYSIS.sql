
/****************************************************************************************
						Phase 5: COHORT Analysis 
*****************************************************************************************/

--SELECT * FROM ORDERS

--USE WEBANALYSIS


-- Step 1 — Find each customer's first purchase

WITH FIRST_PURCHASE AS
(
SELECT 
	USER_ID,
	MIN(CREATED_AT) AS FIRST_PURCHASE_DATE,
	FORMAT(MIN(CREATED_AT),'yyyy-MM') AS COHORT_MONTH
FROM ORDERS
GROUP BY USER_ID
) 

-- Join back to all orders

, COHORT_DATA
AS(
SELECT 
F.USER_ID,
COHORT_MONTH,
DATEDIFF(MONTH,FIRST_PURCHASE_DATE, created_at) AS MONTHS_SINCE_FIRST
FROM FIRST_PURCHASE AS F
LEFT JOIN ORDERS AS O
ON F.user_id = O.user_id
)

-- Count customers per cohort per month

, COHORT_COUNTS AS (
    SELECT
        cohort_month,
        months_since_first,
        COUNT(DISTINCT user_id) AS customers
    FROM COHORT_DATA
    GROUP BY cohort_month, months_since_first
)

-- Step 4 — Get cohort size (Month 0 count)

, COHORT_SIZE AS (
    SELECT
        cohort_month,
        customers AS cohort_size
    FROM COHORT_COUNTS
    WHERE months_since_first = 0
)

-- Step 5 — Calculate retention % and PIVOT

, RETENTION AS (
    SELECT
        C.cohort_month,
        C.months_since_first,
        ROUND(C.customers * 100.0 / S.cohort_size, 1) AS retention_pct
    FROM COHORT_COUNTS AS C
    LEFT JOIN COHORT_SIZE AS S
        ON C.cohort_month = S.cohort_month
)
SELECT
    COHORT_MONTH,
    CAST(ISNULL([0],0)  AS DECIMAL(5,1)) AS M0,
    CAST(ISNULL([1],0)  AS DECIMAL(5,1)) AS M1,
    CAST(ISNULL([2],0)  AS DECIMAL(5,1)) AS M2,
    CAST(ISNULL([3],0)  AS DECIMAL(5,1)) AS M3,
    CAST(ISNULL([4],0)  AS DECIMAL(5,1)) AS M4,
    CAST(ISNULL([5],0)  AS DECIMAL(5,1)) AS M5,
    CAST(ISNULL([6],0)  AS DECIMAL(5,1)) AS M6,
    CAST(ISNULL([7],0)  AS DECIMAL(5,1)) AS M7,
    CAST(ISNULL([8],0)  AS DECIMAL(5,1)) AS M8,
    CAST(ISNULL([9],0)  AS DECIMAL(5,1)) AS M9,
    CAST(ISNULL([10],0) AS DECIMAL(5,1)) AS M10,
    CAST(ISNULL([11],0) AS DECIMAL(5,1)) AS M11,
    CAST(ISNULL([12],0) AS DECIMAL(5,1)) AS M12
FROM RETENTION
PIVOT (
    SUM(retention_pct)
    FOR months_since_first IN (
        [0],[1],[2],[3],[4],[5],[6],
        [7],[8],[9],[10],[11],[12]
    )
) AS PIVOT_TABLE
ORDER BY COHORT_MONTH;





