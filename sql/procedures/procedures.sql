-- ============================================================
-- Online Food Delivery Management System
-- File: procedures.sql
-- Description: Stored procedures and functions
-- ============================================================

-- ========================
-- PROCEDURE 1: Place a new order
-- Creates order record and initial status history entry
-- ========================
DELIMITER //
CREATE PROCEDURE PlaceOrder(
    IN p_CustomerID     INT,
    IN p_RestaurantID   INT,
    IN p_AddressID      INT,
    IN p_DeliveryCharge DECIMAL(10,2),
    OUT p_OrderID       INT
)
BEGIN
    -- Insert order with Pending status
    INSERT INTO Orders (CustomerID, RestaurantID, AddressID, DeliveryCharge, Status)
    VALUES (p_CustomerID, p_RestaurantID, p_AddressID, p_DeliveryCharge, 'Pending');

    SET p_OrderID = LAST_INSERT_ID();

    -- Log initial status
    INSERT INTO OrderStatusHistory (OrderID, Status, StatusTime)
    VALUES (p_OrderID, 'Pending', NOW());
END;
//
DELIMITER ;

-- ========================
-- PROCEDURE 2: Add item to an existing order and recalculate FinalAmount
-- ========================
DELIMITER //
CREATE PROCEDURE AddOrderItem(
    IN p_OrderID     INT,
    IN p_ItemID      INT,
    IN p_Quantity    INT
)
BEGIN
    DECLARE v_Price     DECIMAL(10,2);
    DECLARE v_Subtotal  DECIMAL(10,2);
    DECLARE v_Delivery  DECIMAL(10,2);

    -- Fetch current price of item
    SELECT Price INTO v_Price FROM MenuItem WHERE ItemID = p_ItemID;
    SET v_Subtotal = v_Price * p_Quantity;

    -- Insert order item (trigger will update TotalAmount automatically)
    INSERT INTO OrderItem (OrderID, ItemID, Quantity, PriceAtOrder, Subtotal)
    VALUES (p_OrderID, p_ItemID, p_Quantity, v_Price, v_Subtotal);

    -- Recalculate FinalAmount = TotalAmount + DeliveryCharge
    SELECT DeliveryCharge INTO v_Delivery FROM Orders WHERE OrderID = p_OrderID;

    UPDATE Orders
    SET FinalAmount = TotalAmount + v_Delivery
    WHERE OrderID = p_OrderID;
END;
//
DELIMITER ;

-- ========================
-- PROCEDURE 3: Assign an available delivery partner to an order
-- Picks partner with highest rating who is currently available
-- ========================
DELIMITER //
CREATE PROCEDURE AssignDeliveryPartner(
    IN p_OrderID INT
)
BEGIN
    DECLARE v_PartnerID INT;

    -- Pick best available partner
    SELECT PartnerID INTO v_PartnerID
    FROM DeliveryPartner
    WHERE IsAvailable = TRUE
    ORDER BY Rating DESC
    LIMIT 1;

    IF v_PartnerID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No delivery partner available at the moment';
    END IF;

    -- Assign partner and mark as unavailable
    UPDATE Orders SET DeliveryPartnerID = v_PartnerID WHERE OrderID = p_OrderID;
    UPDATE DeliveryPartner SET IsAvailable = FALSE WHERE PartnerID = v_PartnerID;
END;
//
DELIMITER ;

-- ========================
-- PROCEDURE 4: Update order status with validation
-- Enforces the allowed status transition sequence
-- ========================
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus(
    IN p_OrderID INT,
    IN p_NewStatus VARCHAR(20)
)
BEGIN
    DECLARE v_CurrentStatus VARCHAR(20);

    SELECT Status INTO v_CurrentStatus FROM Orders WHERE OrderID = p_OrderID;

    -- Enforce valid transitions only
    IF (v_CurrentStatus = 'Pending'        AND p_NewStatus = 'Confirmed')      OR
       (v_CurrentStatus = 'Confirmed'      AND p_NewStatus = 'Preparing')      OR
       (v_CurrentStatus = 'Preparing'      AND p_NewStatus = 'OutForDelivery') OR
       (v_CurrentStatus = 'OutForDelivery' AND p_NewStatus = 'Delivered')      OR
       (v_CurrentStatus NOT IN ('Delivered','Cancelled') AND p_NewStatus = 'Cancelled')
    THEN
        UPDATE Orders SET Status = p_NewStatus WHERE OrderID = p_OrderID;
        -- trg_log_order_status trigger will auto-log this change
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid order status transition';
    END IF;
END;
//
DELIMITER ;

-- ========================
-- PROCEDURE 5: Process payment for an order
-- ========================
DELIMITER //
CREATE PROCEDURE ProcessPayment(
    IN p_OrderID       INT,
    IN p_Method        VARCHAR(20),
    IN p_TransactionID VARCHAR(100)
)
BEGIN
    DECLARE v_Amount DECIMAL(10,2);

    SELECT FinalAmount INTO v_Amount FROM Orders WHERE OrderID = p_OrderID;

    INSERT INTO Payment (OrderID, PaymentMethod, Amount, Status, TransactionID)
    VALUES (p_OrderID, p_Method, v_Amount, 'Success', p_TransactionID);
END;
//
DELIMITER ;

-- ========================
-- PROCEDURE 6: Apply coupon to an order and update discount
-- ========================
DELIMITER //
CREATE PROCEDURE ApplyCoupon(
    IN p_OrderID   INT,
    IN p_CouponCode VARCHAR(50)
)
BEGIN
    DECLARE v_CouponID      INT;
    DECLARE v_DiscType      VARCHAR(10);
    DECLARE v_DiscValue     DECIMAL(10,2);
    DECLARE v_MinOrder      DECIMAL(10,2);
    DECLARE v_MaxDisc       DECIMAL(10,2);
    DECLARE v_TotalAmount   DECIMAL(10,2);
    DECLARE v_DiscountApplied DECIMAL(10,2);
    DECLARE v_IsActive      BOOLEAN;

    -- Fetch coupon details
    SELECT CouponID, DiscountType, DiscountValue, MinOrderAmount, MaxDiscount, IsActive
    INTO v_CouponID, v_DiscType, v_DiscValue, v_MinOrder, v_MaxDisc, v_IsActive
    FROM Coupon WHERE CouponCode = p_CouponCode AND ValidTo >= CURDATE();

    IF v_CouponID IS NULL OR v_IsActive = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid or expired coupon';
    END IF;

    SELECT TotalAmount INTO v_TotalAmount FROM Orders WHERE OrderID = p_OrderID;

    IF v_TotalAmount < v_MinOrder THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order amount below minimum required for this coupon';
    END IF;

    -- Calculate discount
    IF v_DiscType = 'FLAT' THEN
        SET v_DiscountApplied = v_DiscValue;
    ELSE
        SET v_DiscountApplied = v_TotalAmount * v_DiscValue / 100;
        IF v_DiscountApplied > v_MaxDisc THEN
            SET v_DiscountApplied = v_MaxDisc;
        END IF;
    END IF;

    -- Apply to order
    UPDATE Orders
    SET Discount    = v_DiscountApplied,
        FinalAmount = TotalAmount + DeliveryCharge - v_DiscountApplied
    WHERE OrderID = p_OrderID;

    -- Record coupon usage
    INSERT INTO OrderCoupon (OrderID, CouponID, DiscountApplied)
    VALUES (p_OrderID, v_CouponID, v_DiscountApplied);
END;
//
DELIMITER ;

-- ========================
-- FUNCTION 1: Get total amount spent by a customer
-- ========================
DELIMITER //
CREATE FUNCTION GetCustomerTotal(p_CustomerID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_Total DECIMAL(10,2);
    SELECT COALESCE(SUM(FinalAmount), 0)
    INTO v_Total
    FROM Orders
    WHERE CustomerID = p_CustomerID AND Status = 'Delivered';
    RETURN v_Total;
END;
//
DELIMITER ;

-- ========================
-- FUNCTION 2: Get total number of orders for a restaurant
-- ========================
DELIMITER //
CREATE FUNCTION GetRestaurantOrderCount(p_RestaurantID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_Count INT;
    SELECT COUNT(*) INTO v_Count
    FROM Orders
    WHERE RestaurantID = p_RestaurantID AND Status = 'Delivered';
    RETURN v_Count;
END;
//
DELIMITER ;

-- ========================
-- TEST PROCEDURES
-- ========================

-- Test PlaceOrder
CALL PlaceOrder(1, 1, 1, 40.00, @newOrderID);
SELECT @newOrderID;

-- Test AddOrderItem (uses the order just created)
CALL AddOrderItem(@newOrderID, 1, 2); -- 2x Butter Chicken
CALL AddOrderItem(@newOrderID, 4, 1); -- 1x Naan
SELECT OrderID, TotalAmount, FinalAmount FROM Orders WHERE OrderID = @newOrderID;

-- Test AssignDeliveryPartner
CALL AssignDeliveryPartner(@newOrderID);
SELECT OrderID, DeliveryPartnerID FROM Orders WHERE OrderID = @newOrderID;

-- Test UpdateOrderStatus
CALL UpdateOrderStatus(@newOrderID, 'Confirmed');
CALL UpdateOrderStatus(@newOrderID, 'Preparing');
SELECT OrderID, Status FROM Orders WHERE OrderID = @newOrderID;

-- Test ProcessPayment
CALL ProcessPayment(@newOrderID, 'UPI', 'TESTTXN999');
SELECT * FROM Payment WHERE OrderID = @newOrderID;

-- Test ApplyCoupon (on a separate order with enough amount)
CALL ApplyCoupon(4, 'FLAT100');
SELECT OrderID, Discount, FinalAmount FROM Orders WHERE OrderID = 4;

-- Test Functions
SELECT GetCustomerTotal(1) AS TotalSpentByCustomer1;
SELECT GetRestaurantOrderCount(4) AS OrdersAtBiryaniHouse;
