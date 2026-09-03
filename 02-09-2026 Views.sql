-- Views

-- Scenario 1: Simplifying Sales Data Access

-- We frequently need to see order details along with product information and calculated order values. 
-- A view can encapsulate this common join.

-- 1. Create the View:

CREATE OR REPLACE VIEW OrderProductDetails AS
SELECT
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    o.Quantity,
    (o.Quantity * p.Price) AS OrderValue
FROM
    Orders o
JOIN
    Product p ON o.ProductID = p.ProductID;

-- Verify the view creation
select * from OrderProductDetails;

-- Add another order to orders table and check your  view again
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity) VALUES
(1, 1, now(), 30);


-- 2. Querying the View (as if it were a table):

-- Question: Get all details for orders placed by CustomerID 1 on or after your current date.

SELECT
    OrderID,
    OrderDate,
    ProductName,
    Quantity,
    OrderValue
FROM
    OrderProductDetails
WHERE
    CustomerID = 20 AND OrderDate >= '2026-08-26';
    
    

-- Instead of writing the JOIN logic every time, users can simply query OrderProductDetails. 
-- This simplifies ad-hoc reporting and application development.

-- Scenario 2: Pre-aggregating Data for Reporting

-- We often want to see daily or monthly sales summaries. A view can provide these aggregates.
-- 1. Create the View:

CREATE OR REPLACE VIEW DailyCategorySalesSummary AS
SELECT
    DATE(o.OrderDate) AS SaleDate,
    p.Category,
    SUM(o.Quantity * p.Price) AS TotalCategoryRevenue,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders
FROM
    Orders o
JOIN
    Product p ON o.ProductID = p.ProductID
GROUP BY
    DATE(o.OrderDate), p.Category;

-- Verify the view creation
SHOW CREATE VIEW DailyCategorySalesSummary;

-- 2. Querying the View:

-- Question: What was the total revenue for 'Electronics' in May 2025?

SELECT
    SaleDate,
    TotalCategoryRevenue,
    NumberOfOrders
FROM
    DailyCategorySalesSummary
WHERE
    Category = 'Electronics'
    AND SaleDate BETWEEN '2025-05-01' AND '2025-05-31'
ORDER BY
    SaleDate;

-- Provides a simplified, pre-aggregated dataset for reporting. Users don't need to know the underlying aggregation logic, just query the summary.

/* Class Exercise
1. Create a view called ProductSalesSummary that shows the sales performance of each product.
Display:
ProductID
ProductName
Category
Total Quantity Sold
Total Sales Amount
* The result should be grouped by product.
Hint: You will need: SUM(), JOIN, GROUP BY

2. Filtered View — Electronics Products
Create a view called ElectronicsProducts that displays all products belonging to the Electronics category.
The view should show:
ProductID
ProductName
Price

3. View — Products Above Average Price
Create a view called ExpensiveProducts that displays products whose price is higher than the average price of all products.
Display:
ProductID
ProductName
Category
Price
Hint: Use a subquery to calculate the average price.

4. View — Category Sales Summary
Create a view called CategorySalesSummary that shows the sales performance of each product category.
Display:
Category
Total Quantity Sold
Total Sales Amount

5. View — Customer Spending Summary
Create a view called CustomerSpending that shows the total amount spent by each customer.
Display:
CustomerID
Total Orders
Total Quantity
Total Amount Spent

*/