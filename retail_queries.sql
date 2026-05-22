-- ==============================================================================
-- PROJECT: E-COMMERCE TRANSACTIONAL BUSINESS INTELLIGENCE
-- ==============================================================================

--------------------------------------------------------------------------------
-- 1. REVENUE OVERVIEW: GROSS REVENUE VS. NET REVENUE
--------------------------------------------------------------------------------
SELECT 
    SUM(Quantity * UnitPrice) AS gross_revenue,
    
    -- Filter out negative quantities to calculate actual lost revenue from cancellations
    SUM(CASE WHEN Quantity < 0 THEN (Quantity * UnitPrice) ELSE 0 END) AS total_canceled_value,
    
    -- Net revenue = Gross revenue minus cancellations (adds them because cancellations are negative)
    SUM(Quantity * UnitPrice) + SUM(CASE WHEN Quantity < 0 THEN (Quantity * UnitPrice) ELSE 0 END) AS net_revenue
FROM staging_online_retail;


--------------------------------------------------------------------------------
-- 2. MONTHLY BUSINESS GROWTH TRACKING
--------------------------------------------------------------------------------
SELECT 
    SUBSTRING(InvoiceDate, 1, 7) AS sales_month,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS items_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue
FROM staging_online_retail
WHERE Quantity > 0 -- Focus strictly on completed sales
GROUP BY SUBSTRING(InvoiceDate, 1, 7)
ORDER BY sales_month ASC;


--------------------------------------------------------------------------------
-- 3. PRODUCT PERFORMANCE: TOP 10 REVENUE GENERATING ITEMS
--------------------------------------------------------------------------------
SELECT 
    StockCode,
    Description,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue_generated
FROM staging_online_retail
WHERE Quantity > 0
GROUP BY StockCode, Description
ORDER BY total_revenue_generated DESC
LIMIT 10;


--------------------------------------------------------------------------------
-- 4. GEOGRAPHIC MARKET SHARE
--------------------------------------------------------------------------------
SELECT 
    Country,
    COUNT(DISTINCT InvoiceNo) AS total_unique_orders,
    SUM(Quantity) AS total_items_shipped,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_country_sales
FROM staging_online_retail
GROUP BY Country
ORDER BY total_country_sales DESC;


--------------------------------------------------------------------------------
-- 5. ORDER LEVEL METRICS: AVERAGE SPEND PER INVOICE (BASKET VALUE)
--------------------------------------------------------------------------------
WITH order_summary AS (
    SELECT 
        InvoiceNo,
        SUM(Quantity) AS unique_items_count,
        SUM(Quantity * UnitPrice) AS total_invoice_amount
    FROM staging_online_retail
    WHERE Quantity > 0
    GROUP BY InvoiceNo
)
SELECT 
    COUNT(InvoiceNo) AS total_processed_baskets,
    ROUND(AVG(unique_items_count), 1) AS average_items_per_basket,
    ROUND(AVG(total_invoice_amount), 2) AS average_monetary_value_per_basket
FROM order_summary;


--------------------------------------------------------------------------------
-- 6. CUSTOMER SEGMENATION: INDIVIDUAL SPENDING TIERS
--------------------------------------------------------------------------------
WITH customer_totals AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_frequency,
        SUM(Quantity * UnitPrice) AS customer_total_spend
    FROM staging_online_retail
    WHERE CustomerID IS NOT NULL AND Quantity > 0
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    order_frequency,
    ROUND(customer_total_spend, 2) AS total_spend,
    -- Simple conditional segmentation based on actual business brackets
    CASE 
        WHEN customer_total_spend >= 3000 THEN 'Tier 1: High-Value VIP'
        WHEN customer_total_spend >= 1000 THEN 'Tier 2: Core Regular'
        ELSE 'Tier 3: Occasional Buyer'
    END AS customer_value_segment
FROM customer_totals
ORDER BY total_spend DESC;


--------------------------------------------------------------------------------
-- 7. REVENUE LEAKAGE: TOP CANCELED ITEMS
--------------------------------------------------------------------------------
SELECT 
    StockCode,
    Description,
    COUNT(InvoiceNo) AS total_return_transactions,
    ABS(SUM(Quantity)) AS count_of_items_returned,
    ROUND(ABS(SUM(Quantity * UnitPrice)), 2) AS total_lost_revenue
FROM staging_online_retail
WHERE Quantity < 0 OR InvoiceNo LIKE 'C%'
GROUP BY StockCode, Description
ORDER BY total_lost_revenue DESC
LIMIT 10;
