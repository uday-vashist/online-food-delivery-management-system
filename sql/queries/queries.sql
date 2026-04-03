-- ============================================================
-- Online Food Delivery Management System
-- File: queries.sql
-- Description: Complex SELECT queries — joins, aggregates,
--              subqueries, window functions, views
-- ============================================================

-- ============================================================
-- SECTION A: JOIN QUERIES
-- ============================================================

-- Q1: Full order details — customer, restaurant, partner, address
SELECT
    O.OrderID,
    C.Name          AS CustomerName,
    R.Name          AS RestaurantName,
    DP.Name         AS DeliveryPartner,
    DA.AddressLine1,
    DA.City,
    O.Status,
    O.FinalAmount
FROM Orders O
JOIN Customer       C   ON O.CustomerID        = C.CustomerID
JOIN Restaurant     R   ON O.RestaurantID       = R.RestaurantID
LEFT JOIN DeliveryPartner DP ON O.DeliveryPartnerID = DP.PartnerID
JOIN DeliveryAddress DA ON O.AddressID          = DA.AddressID
ORDER BY O.OrderDate DESC;

-- Q2: Menu items with their restaurant and category name
SELECT
    MI.ItemName,
    MI.Price,
    R.Name  AS Restaurant,
    CA.CategoryName
FROM MenuItem MI
JOIN Restaurant R  ON MI.RestaurantID = R.RestaurantID
JOIN Category   CA ON MI.CategoryID   = CA.CategoryID
WHERE MI.IsAvailable = TRUE
ORDER BY CA.CategoryName, MI.Price;

-- Q3: All items ordered in a specific order (OrderID = 1)
SELECT
    OI.OrderID,
    MI.ItemName,
    OI.Quantity,
    OI.PriceAtOrder,
    OI.Subtotal
FROM OrderItem OI
JOIN MenuItem MI ON OI.ItemID = MI.ItemID
WHERE OI.OrderID = 1;

-- Q4: Customers with their total number of orders and total spend
SELECT
    C.CustomerID,
    C.Name,
    COUNT(O.OrderID)    AS TotalOrders,
    SUM(O.FinalAmount)  AS TotalSpent
FROM Customer C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID AND O.Status = 'Delivered'
GROUP BY C.CustomerID, C.Name
ORDER BY TotalSpent DESC;

-- Q5: Payment details joined with order and customer
SELECT
    P.PaymentID,
    C.Name          AS Customer,
    O.OrderID,
    P.PaymentMethod,
    P.Amount,
    P.Status        AS PaymentStatus,
    P.TransactionID
FROM Payment P
JOIN Orders   O ON P.OrderID    = O.OrderID
JOIN Customer C ON O.CustomerID = C.CustomerID
ORDER BY P.PaymentDate DESC;

-- ============================================================
-- SECTION B: AGGREGATE + GROUP BY QUERIES
-- ============================================================

-- Q6: Revenue and order count per restaurant (top performers)
SELECT
    R.RestaurantID,
    R.Name,
    COUNT(O.OrderID)    AS TotalOrders,
    SUM(O.FinalAmount)  AS TotalRevenue,
    AVG(O.FinalAmount)  AS AvgOrderValue,
    R.Rating
FROM Restaurant R
LEFT JOIN Orders O ON R.RestaurantID = O.RestaurantID AND O.Status = 'Delivered'
GROUP BY R.RestaurantID, R.Name, R.Rating
ORDER BY TotalRevenue DESC;

-- Q7: Most popular menu items by quantity ordered
SELECT
    MI.ItemName,
    R.Name          AS Restaurant,
    SUM(OI.Quantity) AS TotalQuantitySold,
    SUM(OI.Subtotal) AS TotalRevenue
FROM OrderItem OI
JOIN MenuItem   MI ON OI.ItemID      = MI.ItemID
JOIN Restaurant R  ON MI.RestaurantID = R.RestaurantID
GROUP BY MI.ItemID, MI.ItemName, R.Name
ORDER BY TotalQuantitySold DESC
LIMIT 10;

-- Q8: Monthly order volume and revenue
SELECT
    MONTH(OrderDate)  AS Month,
    YEAR(OrderDate)   AS Year,
    COUNT(OrderID)    AS TotalOrders,
    SUM(FinalAmount)  AS MonthlyRevenue
FROM Orders
WHERE Status = 'Delivered'
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- Q9: Delivery partner performance summary
SELECT
    DP.PartnerID,
    DP.Name,
    COUNT(O.OrderID)    AS DeliveriesCompleted,
    AVG(DP.Rating)      AS AvgRating,
    SUM(O.DeliveryCharge) AS TotalEarnings
FROM DeliveryPartner DP
LEFT JOIN Orders O ON DP.PartnerID = O.DeliveryPartnerID AND O.Status = 'Delivered'
GROUP BY DP.PartnerID, DP.Name
ORDER BY DeliveriesCompleted DESC;

-- Q10: Cancelled order rate per restaurant
SELECT
    R.Name,
    COUNT(O.OrderID)                                        AS TotalOrders,
    SUM(CASE WHEN O.Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders,
    ROUND(
        SUM(CASE WHEN O.Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(O.OrderID), 2
    ) AS CancelRate_Percent
FROM Restaurant R
JOIN Orders O ON R.RestaurantID = O.RestaurantID
GROUP BY R.RestaurantID, R.Name
ORDER BY CancelRate_Percent DESC;

-- ============================================================
-- SECTION C: SUBQUERIES
-- ============================================================

-- Q11: Customers who have spent more than the average customer spend
SELECT
    C.Name,
    SUM(O.FinalAmount) AS TotalSpent
FROM Customer C
JOIN Orders O ON C.CustomerID = O.CustomerID AND O.Status = 'Delivered'
GROUP BY C.CustomerID, C.Name
HAVING TotalSpent > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(FinalAmount) AS CustomerTotal
        FROM Orders
        WHERE Status = 'Delivered'
        GROUP BY CustomerID
    ) AS Totals
)
ORDER BY TotalSpent DESC;

-- Q12: Restaurants with rating above overall average
SELECT
    RestaurantID,
    Name,
    Rating
FROM Restaurant
WHERE Rating > (SELECT AVG(Rating) FROM Restaurant WHERE Rating > 0)
ORDER BY Rating DESC;

-- Q13: Menu items that have never been ordered
SELECT
    MI.ItemID,
    MI.ItemName,
    R.Name AS Restaurant
FROM MenuItem MI
JOIN Restaurant R ON MI.RestaurantID = R.RestaurantID
WHERE MI.ItemID NOT IN (SELECT DISTINCT ItemID FROM OrderItem);

-- ============================================================
-- SECTION D: WINDOW FUNCTIONS
-- ============================================================

-- Q14: Rank customers by total spend using RANK()
SELECT
    C.Name,
    SUM(O.FinalAmount)                                       AS TotalSpent,
    RANK() OVER (ORDER BY SUM(O.FinalAmount) DESC)           AS SpendRank
FROM Customer C
JOIN Orders O ON C.CustomerID = O.CustomerID AND O.Status = 'Delivered'
GROUP BY C.CustomerID, C.Name;

-- Q15: Running total of revenue by date (cumulative sum)
SELECT
    OrderDate,
    SUM(FinalAmount)                                          AS DailyRevenue,
    SUM(SUM(FinalAmount)) OVER (ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                                                              AS RunningTotal
FROM Orders
WHERE Status = 'Delivered'
GROUP BY OrderDate
ORDER BY OrderDate;

-- Q16: Top 3 menu items per restaurant by revenue (DENSE_RANK with partition)
SELECT *
FROM (
    SELECT
        R.Name      AS Restaurant,
        MI.ItemName,
        SUM(OI.Subtotal)                                          AS ItemRevenue,
        DENSE_RANK() OVER (PARTITION BY R.RestaurantID ORDER BY SUM(OI.Subtotal) DESC) AS ItemRank
    FROM OrderItem OI
    JOIN MenuItem   MI ON OI.ItemID      = MI.ItemID
    JOIN Restaurant R  ON MI.RestaurantID = R.RestaurantID
    GROUP BY R.RestaurantID, R.Name, MI.ItemID, MI.ItemName
) AS Ranked
WHERE ItemRank <= 3;

-- ============================================================
-- SECTION E: VIEWS
-- ============================================================

-- View 1: Available delivery partners with vehicle info
CREATE OR REPLACE VIEW vw_AvailablePartners AS
SELECT
    DP.PartnerID,
    DP.Name,
    DP.Phone,
    DP.Rating,
    V.VehicleType,
    V.PlateNumber
FROM DeliveryPartner DP
JOIN Vehicle V ON DP.PartnerID = V.PartnerID
WHERE DP.IsAvailable = TRUE;

-- View 2: Restaurant analytics — orders, revenue, average rating
CREATE OR REPLACE VIEW vw_RestaurantAnalytics AS
SELECT
    R.RestaurantID,
    R.Name,
    R.CuisineType,
    R.Rating,
    COUNT(O.OrderID)    AS TotalOrders,
    SUM(O.FinalAmount)  AS TotalRevenue,
    AVG(O.FinalAmount)  AS AvgOrderValue
FROM Restaurant R
LEFT JOIN Orders O ON R.RestaurantID = O.RestaurantID AND O.Status = 'Delivered'
GROUP BY R.RestaurantID, R.Name, R.CuisineType, R.Rating;

-- View 3: Customer order history with payment status
CREATE OR REPLACE VIEW vw_CustomerOrderHistory AS
SELECT
    C.CustomerID,
    C.Name      AS CustomerName,
    O.OrderID,
    R.Name      AS Restaurant,
    O.OrderDate,
    O.Status,
    O.FinalAmount,
    P.PaymentMethod,
    P.Status    AS PaymentStatus
FROM Customer C
JOIN Orders  O ON C.CustomerID   = O.CustomerID
JOIN Restaurant R ON O.RestaurantID = R.RestaurantID
LEFT JOIN Payment P ON O.OrderID  = P.OrderID;

-- View 4: Active menu items with full details
CREATE OR REPLACE VIEW vw_ActiveMenu AS
SELECT
    MI.ItemID,
    R.Name      AS Restaurant,
    CA.CategoryName,
    MI.ItemName,
    MI.Price,
    MI.Description
FROM MenuItem MI
JOIN Restaurant R  ON MI.RestaurantID = R.RestaurantID
JOIN Category   CA ON MI.CategoryID   = CA.CategoryID
WHERE MI.IsAvailable = TRUE AND R.IsActive = TRUE;

-- View 5: Order summary with coupon usage
CREATE OR REPLACE VIEW vw_OrderSummary AS
SELECT
    O.OrderID,
    C.Name      AS Customer,
    R.Name      AS Restaurant,
    O.TotalAmount,
    O.DeliveryCharge,
    O.Discount,
    O.FinalAmount,
    COALESCE(CP.CouponCode, 'None') AS CouponUsed,
    O.Status
FROM Orders O
JOIN Customer   C  ON O.CustomerID   = C.CustomerID
JOIN Restaurant R  ON O.RestaurantID  = R.RestaurantID
LEFT JOIN OrderCoupon OC ON O.OrderID = OC.OrderID
LEFT JOIN Coupon      CP ON OC.CouponID = CP.CouponID;

-- ========================
-- USE VIEWS
-- ========================
SELECT * FROM vw_AvailablePartners;
SELECT * FROM vw_RestaurantAnalytics ORDER BY TotalRevenue DESC;
SELECT * FROM vw_CustomerOrderHistory WHERE CustomerID = 1;
SELECT * FROM vw_ActiveMenu WHERE CategoryName = 'Biryani';
SELECT * FROM vw_OrderSummary WHERE CouponUsed != 'None';
