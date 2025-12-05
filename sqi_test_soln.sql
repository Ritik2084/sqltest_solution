 
 -- SQL Test Solutions
-- Candidate: Ritik Ranjan
-- Database: sql_test
-- Assumptions:
-- 1) Refund should be excluded when refund_time IS NULL
-- 2) Timestamp calculations use TIMESTAMPDIFF in MySQL


-- Q1: Count of purchases per month (excluding refunded purchases)
SELECT
  YEAR(purchase_time)  AS yr,
  MONTH(purchase_time) AS mn,
  COUNT(*) AS purchase_count
FROM transactions
WHERE refund_time IS NULL
GROUP BY yr, mn
ORDER BY yr, mn;


--  Q2: Stores with at least 5 orders in October 2020


SELECT
  store_id,
  COUNT(*) AS order_count
FROM transactions
WHERE purchase_time >= '2020-10-01'
  AND purchase_time < '2020-11-01'
GROUP BY store_id
HAVING order_count >= 5;

--  Count of such stores
SELECT COUNT(*) AS num_stores
FROM (
  SELECT store_id
  FROM transactions
  WHERE purchase_time >= '2020-10-01'
    AND purchase_time < '2020-11-01'
  GROUP BY store_id
  HAVING COUNT(*) >= 5
) AS x;


-- Q3: Shortest interval (in minutes) from purchase to refund per store
SELECT
  store_id,
  MIN(TIMESTAMPDIFF(MINUTE, purchase_time, refund_time)) AS min_refund_interval_min
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;


-- Q4: Gross transaction value of every store's first order
WITH ranked AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (
      PARTITION BY store_id
      ORDER BY purchase_time
    ) AS rn
  FROM transactions t
)
SELECT
  store_id,
  gross_transaction_value
FROM ranked
WHERE rn = 1;



-- Q5: Most popular item name on buyers' first purchase (excluding refunded)
WITH first_purchase AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (
      PARTITION BY buyer_id
      ORDER BY purchase_time
    ) AS rn
  FROM transactions t
  WHERE refund_time IS NULL
)
SELECT
  i.item_name,
  COUNT(*) AS cnt
FROM first_purchase fp
JOIN items i
  ON fp.store_id = i.store_id
 AND fp.item_id = i.item_id
WHERE fp.rn = 1
GROUP BY i.item_name
ORDER BY cnt DESC
LIMIT 1;



-- Q6: Refund processed flag (1 if refund within 72 hours of purchase)
SELECT
  t.*,
  CASE
    WHEN refund_time IS NOT NULL
     AND TIMESTAMPDIFF(HOUR, purchase_time, refund_time) <= 72
      THEN 1
    ELSE 0
  END AS refund_processed_flag
FROM transactions t;


-- Q7: Second purchase per buyer (ignoring refunded ones)
WITH ranked AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (
      PARTITION BY buyer_id
      ORDER BY purchase_time
    ) AS rn
  FROM transactions t
  WHERE refund_time IS NULL
)
SELECT *
FROM ranked
WHERE rn = 2;



-- Q8: Second transaction time per buyer (no MIN/MAX used)
WITH ordered AS (
  SELECT
    buyer_id,
    purchase_time,
    ROW_NUMBER() OVER (
      PARTITION BY buyer_id
      ORDER BY purchase_time
    ) AS rn
  FROM transactions
)
SELECT
  buyer_id,
  purchase_time AS second_transaction_time
FROM ordered
WHERE rn = 2;
