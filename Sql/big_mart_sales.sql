USE big_mart_sales;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS outlets;

CREATE TABLE items (
    Item_Identifier   VARCHAR(20) PRIMARY KEY,
    Item_Weight       DECIMAL(6,3),
    Item_Fat_Content  VARCHAR(20),
    Item_Type         VARCHAR(50)
);

CREATE TABLE outlets (
    Outlet_Identifier          VARCHAR(20) PRIMARY KEY,
    Outlet_Establishment_Year  INT,
    Outlet_Size                VARCHAR(20),
    Outlet_Location_Type       VARCHAR(20),
    Outlet_Type                VARCHAR(30),
    Outlet_Age                 INT
);

CREATE TABLE sales (
    Sale_ID            INT AUTO_INCREMENT PRIMARY KEY,
    Item_Identifier    VARCHAR(20),
    Outlet_Identifier  VARCHAR(20),
    Item_MRP           DECIMAL(8,4),
    Item_Visibility    DECIMAL(10,8),
    Item_Outlet_Sales  DECIMAL(10,4),
    FOREIGN KEY (Item_Identifier) REFERENCES items(Item_Identifier),
    FOREIGN KEY (Outlet_Identifier) REFERENCES outlets(Outlet_Identifier)
);


INSERT INTO items (Item_Identifier, Item_Weight, Item_Fat_Content, Item_Type)
SELECT
    Item_Identifier,
    MIN(Item_Weight),
    MIN(Item_Fat_Content),
    MIN(Item_Type)
FROM bigmart_staging
GROUP BY Item_Identifier;

SELECT COUNT(*) FROM items;
INSERT INTO outlets (Outlet_Identifier, Outlet_Establishment_Year, Outlet_Size, Outlet_Location_Type, Outlet_Type, Outlet_Age)
SELECT
    Outlet_Identifier,
    MIN(Outlet_Establishment_Year),
    MIN(Outlet_Size),
    MIN(Outlet_Location_Type),
    MIN(Outlet_Type),
    MIN(Outlet_Age)
FROM bigmart_staging
GROUP BY Outlet_Identifier;
SELECT COUNT(*) FROM outlets;
INSERT INTO sales (Item_Identifier, Outlet_Identifier, Item_MRP, Item_Visibility, Item_Outlet_Sales)
SELECT
    Item_Identifier,
    Outlet_Identifier,
    Item_MRP,
    Item_Visibility,
    Item_Outlet_Sales
FROM bigmart_staging;

SELECT COUNT(*) FROM sales;

/*
Q1. Which outlet type generates the most sales?
*/
SELECT
    o.Outlet_Type,
    SUM(s.Item_Outlet_Sales)   AS Total_Sales,
    AVG(s.Item_Outlet_Sales)   AS Avg_Sales,
    COUNT(*)                   AS Transaction_Count
FROM sales s
JOIN outlets o ON s.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Type
ORDER BY Total_Sales DESC;

-- Q2. Does outlet size affect sales performance?

SELECT
    o.Outlet_Size,
    SUM(s.Item_Outlet_Sales) AS Total_Sales,
    AVG(s.Item_Outlet_Sales) AS Avg_Sales
FROM sales s
JOIN outlets o ON s.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Size
ORDER BY Avg_Sales DESC;

-- Q3. Which location tier drives the most revenue?
SELECT
    o.Outlet_Location_Type,
    SUM(s.Item_Outlet_Sales) AS Total_Sales,
    AVG(s.Item_Outlet_Sales) AS Avg_Sales
FROM sales s
JOIN outlets o ON s.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- Q4. Do older outlets outperform newer ones?
SELECT
    o.Outlet_Age,
    AVG(s.Item_Outlet_Sales) AS Avg_Sales
FROM sales s
JOIN outlets o ON s.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Age
ORDER BY o.Outlet_Age;

-- Q5. Which item types sell the most vs. least?
SELECT
    i.Item_Type,
    SUM(s.Item_Outlet_Sales) AS Total_Sales
FROM sales s
JOIN items i ON s.Item_Identifier = i.Item_Identifier
GROUP BY i.Item_Type
ORDER BY Total_Sales DESC;

-- Q6. Does item visibility correlate with higher sales?
SELECT
    (COUNT(*) * SUM(s.Item_Visibility * s.Item_Outlet_Sales) - SUM(s.Item_Visibility) * SUM(s.Item_Outlet_Sales))
    /
    (SQRT(COUNT(*) * SUM(POW(s.Item_Visibility,2)) - POW(SUM(s.Item_Visibility),2))
     * SQRT(COUNT(*) * SUM(POW(s.Item_Outlet_Sales,2)) - POW(SUM(s.Item_Outlet_Sales),2)))
    AS Correlation_Visibility_Sales
FROM sales s;

-- Q7. Does price (MRP) correlate with sales?
SELECT
    (COUNT(*) * SUM(s.Item_MRP * s.Item_Outlet_Sales) - SUM(s.Item_MRP) * SUM(s.Item_Outlet_Sales))
    /
    (SQRT(COUNT(*) * SUM(POW(s.Item_MRP,2)) - POW(SUM(s.Item_MRP),2))
     * SQRT(COUNT(*) * SUM(POW(s.Item_Outlet_Sales,2)) - POW(SUM(s.Item_Outlet_Sales),2)))
    AS Correlation_MRP_Sales
FROM sales s;

-- Q8. Does Item_Fat_Content impact sales?
SELECT
    i.Item_Fat_Content,
    SUM(s.Item_Outlet_Sales) AS Total_Sales,
    AVG(s.Item_Outlet_Sales) AS Avg_Sales
FROM sales s
JOIN items i ON s.Item_Identifier = i.Item_Identifier
GROUP BY i.Item_Fat_Content

-- KPI 9. Total Sales & Average Sales per Outlet
 SELECT
    SUM(Item_Outlet_Sales) AS Total_Sales,
    (SELECT AVG(outlet_total) FROM (
        SELECT SUM(Item_Outlet_Sales) AS outlet_total
        FROM sales GROUP BY Outlet_Identifier
    ) t) AS Avg_Sales_Per_Outlet
FROM sales;

-- Q10a. Best outlet type  and  item type combination.
SELECT
    o.Outlet_Type,
    i.Item_Type,
    SUM(s.Item_Outlet_Sales) AS Total_Sales
FROM sales s
JOIN outlets o ON s.Outlet_Identifier = o.Outlet_Identifier
JOIN items i ON s.Item_Identifier = i.Item_Identifier
GROUP BY o.Outlet_Type, i.Item_Type
ORDER BY Total_Sales DESC
LIMIT 10;

-- Q10b. What % of total sales comes from the top 20% of outlets?
WITH outlet_totals AS (
    SELECT
        Outlet_Identifier,
        SUM(Item_Outlet_Sales) AS Total_Sales
    FROM sales
    GROUP BY Outlet_Identifier
),
ranked_outlets AS (
    SELECT
        Outlet_Identifier,
        Total_Sales,
        ROW_NUMBER() OVER (ORDER BY Total_Sales DESC) AS Rank_Num,
        COUNT(*) OVER () AS Total_Outlets
    FROM outlet_totals
)
SELECT
    SUM(CASE WHEN Rank_Num <= Total_Outlets * 0.2 THEN Total_Sales ELSE 0 END) * 100.0
    / SUM(Total_Sales) AS Top20_Pct_Outlet_Sales_Share
FROM ranked_outlets;

-- KPI 11. Average Item MRP across the catalog
SELECT AVG(Item_MRP) AS Average_Item_MRP
FROM sales;

-- KPI 12. Total unique items and total unique outlets
SELECT
    (SELECT COUNT(*) FROM items)   AS Unique_Items,
    (SELECT COUNT(*) FROM outlets) AS Unique_Outlets;
    
    -- Q13. What % of total sales comes from the top 20% of items? (Pareto view)
    WITH item_totals AS (
    SELECT
        Item_Identifier,
        SUM(Item_Outlet_Sales) AS Total_Sales
    FROM sales
    GROUP BY Item_Identifier
),
ranked_items AS (
    SELECT
        Item_Identifier,
        Total_Sales,
        ROW_NUMBER() OVER (ORDER BY Total_Sales DESC) AS Rank_Num,
        COUNT(*) OVER () AS Total_Items
    FROM item_totals
)
SELECT
    SUM(CASE WHEN Rank_Num <= Total_Items * 0.2 THEN Total_Sales ELSE 0 END) * 100.0
    / SUM(Total_Sales) AS Top20_Pct_Item_Sales_Share
FROM ranked_items;