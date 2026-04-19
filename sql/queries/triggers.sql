-- ============================================================
-- Online Food Delivery Management System
-- File: triggers.sql
-- Description: All triggers for business rule enforcement
-- ============================================================

-- ========================
-- TRIGGER 1: Validate rating is between 1 and 5 before insert
-- ========================
DELIMITER //
CREATE TRIGGER trg_check_rating
BEFORE INSERT ON Rating
FOR EACH ROW
BEGIN
    IF NEW.RatingValue < 1 OR NEW.RatingValue > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END;
//
DELIMITER ;

-- ========================
-- TRIGGER 2: Auto-update restaurant's average rating after a new rating is inserted
-- Guard added: only fires when RestaurantID is not NULL (polymorphic rating table)
-- ========================
DELIMITER //
CREATE TRIGGER trg_update_restaurant_rating
AFTER INSERT ON Rating
FOR EACH ROW
BEGIN
    IF NEW.RestaurantID IS NOT NULL THEN
        UPDATE Restaurant
        SET Rating = (
            SELECT AVG(RatingValue)
            FROM Rating
            WHERE RestaurantID = NEW.RestaurantID
        )
        WHERE RestaurantID = NEW.RestaurantID;
    END IF;
END;
//
DELIMITER ;

-- ========================
-- TRIGGER 3: Auto-update order's TotalAmount when a new OrderItem is inserted
-- ========================
DELIMITER //
CREATE TRIGGER trg_update_order_total
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET TotalAmount = (
        SELECT SUM(Subtotal)
        FROM OrderItem
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END;
//
DELIMITER ;

-- ========================
-- TRIGGER 4: Log every order status change into OrderStatusHistory automatically
-- ========================
DELIMITER //
CREATE TRIGGER trg_log_order_status
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    -- Only log if status actually changed
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO OrderStatusHistory (OrderID, Status, StatusTime)
        VALUES (NEW.OrderID, NEW.Status, NOW());
    END IF;
END;
//
DELIMITER ;

-- ========================
-- TRIGGER 5: Prevent cancellation of an already delivered order
-- ========================
DELIMITER //
CREATE TRIGGER trg_prevent_invalid_cancel
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.Status = 'Delivered' AND NEW.Status = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot cancel an order that has already been delivered';
    END IF;
END;
//
DELIMITER ;

-- ========================
-- TEST TRIGGER 1: check_rating
-- ========================
-- Should fail (rating = 6)
-- INSERT INTO Rating (CustomerID, RestaurantID, RatingValue) VALUES (1, 1, 6);

-- Should pass (rating = 4)
INSERT INTO Rating (CustomerID, RestaurantID, PartnerID, RatingValue) VALUES (13, 1, NULL, 4);
SELECT RatingID, RatingValue FROM Rating WHERE CustomerID = 13;

-- ========================
-- TEST TRIGGER 2: update_restaurant_rating
-- ========================
SELECT RestaurantID, Rating FROM Restaurant WHERE RestaurantID = 1;
INSERT INTO Rating (CustomerID, RestaurantID, PartnerID, RatingValue) VALUES (14, 1, NULL, 2);
SELECT RestaurantID, Rating FROM Restaurant WHERE RestaurantID = 1; -- should update avg

-- ========================
-- TEST TRIGGER 3: update_order_total
-- ========================
SELECT OrderID, TotalAmount FROM Orders WHERE OrderID = 1;
INSERT INTO OrderItem (OrderID, ItemID, Quantity, PriceAtOrder, Subtotal) VALUES (1, 5, 1, 80, 80);
SELECT OrderID, TotalAmount FROM Orders WHERE OrderID = 1; -- should increase by 80

-- ========================
-- TEST TRIGGER 4: log_order_status
-- ========================
UPDATE Orders SET Status = 'Confirmed' WHERE OrderID = 200;
SELECT * FROM OrderStatusHistory WHERE OrderID = 200; -- should have new entry

-- ========================
-- TEST TRIGGER 5: prevent_invalid_cancel
-- ========================
-- Should fail (order 1 is already Delivered)
-- UPDATE Orders SET Status = 'Cancelled' WHERE OrderID = 1;
-- ========================
-- TRIGGER 6: Log customer data before deletion (audit trail)
-- ========================
DELIMITER //
CREATE TRIGGER trg_log_customer_delete
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO CustomerDeletionLog (CustomerID, Name, Email, DeletedAt)
    VALUES (OLD.CustomerID, OLD.Name, OLD.Email, NOW());
END;
//
DELIMITER ;

-- ========================
-- TRIGGER 7: Prevent deletion of customer with active orders
-- ========================
DELIMITER //
CREATE TRIGGER trg_prevent_active_customer_delete
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM Orders
    WHERE CustomerID = OLD.CustomerID
    AND Status NOT IN ('Delivered', 'Cancelled');

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete customer with active orders';
    END IF;
END;
//
DELIMITER ;

-- ========================
-- TEST TRIGGER 6 + 7
-- ========================
-- Should fail (CustomerID 1 has active orders)
-- DELETE FROM Customer WHERE CustomerID = 1;
-- Should succeed and log (CustomerID 50 has only delivered orders)
DELETE FROM Customer WHERE CustomerID = 50;
SELECT * FROM CustomerDeletionLog;


-- Test for tigger: Sample Entry
-- add a fresh customer with no orders
INSERT INTO Customer (Name, Email, Phone, Password) 
VALUES ('Test User', 'test@delete.com', '9999999999', 'test123');
-- get the new ID
SELECT CustomerID FROM Customer WHERE Email = 'test@delete.com';
-- delete it (trigger fires, logs it)
DELETE FROM Customer WHERE Email = 'test@delete.com';
-- verify log
SELECT * FROM CustomerDeletionLog;