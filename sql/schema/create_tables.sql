-- ============================================================
-- Online Food Delivery Management System
-- File: create_tables.sql
-- Description: All CREATE TABLE statements with constraints
-- ============================================================
CREATE DATABASE food_delivery;
USE food_delivery;
-- Drop existing tables in reverse FK order to avoid constraint errors
DROP TABLE IF EXISTS OrderCoupon;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS OrderStatusHistory;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS DeliveryAddress;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS MenuOption;
DROP TABLE IF EXISTS MenuItem;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Coupon;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS RestaurantOwner;
DROP TABLE IF EXISTS DeliveryPartner;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Admin;

-- ========================
-- STRONG ENTITIES
-- ========================

-- Stores customer account details
CREATE TABLE Customer (
    CustomerID   INT PRIMARY KEY AUTO_INCREMENT,
    Name         VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE,
    Phone        VARCHAR(15)  NOT NULL UNIQUE,
    Password     VARCHAR(255) NOT NULL,
    RegistrationDate DATE DEFAULT (CURRENT_DATE)
);

-- Stores restaurant owner details
CREATE TABLE RestaurantOwner (
    OwnerID INT PRIMARY KEY AUTO_INCREMENT,
    Name    VARCHAR(100) NOT NULL,
    Phone   VARCHAR(15)  NOT NULL,
    Email   VARCHAR(100) NOT NULL
);

-- Stores delivery partner details
CREATE TABLE DeliveryPartner (
    PartnerID     INT PRIMARY KEY AUTO_INCREMENT,
    Name          VARCHAR(100) NOT NULL,
    Phone         VARCHAR(15)  NOT NULL UNIQUE,
    Email         VARCHAR(100) NOT NULL UNIQUE,
    LicenseNumber VARCHAR(50)  NOT NULL UNIQUE,
    IsAvailable   BOOLEAN DEFAULT TRUE,
    Rating        DECIMAL(3,2) DEFAULT 0.00,
    JoinDate      DATE DEFAULT (CURRENT_DATE)
);

-- Stores system admin details
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY AUTO_INCREMENT,
    Name    VARCHAR(100) NOT NULL,
    Email   VARCHAR(100) NOT NULL UNIQUE,
    Role    VARCHAR(50)  NOT NULL
);

-- Food categories (e.g. Pizza, Biryani, Dessert)
CREATE TABLE Category (
    CategoryID   INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Coupon/discount codes
CREATE TABLE Coupon (
    CouponID        INT PRIMARY KEY AUTO_INCREMENT,
    CouponCode      VARCHAR(50)    NOT NULL UNIQUE,
    DiscountType    ENUM('FLAT','PERCENT') NOT NULL,
    DiscountValue   DECIMAL(10,2)  NOT NULL,
    MinOrderAmount  DECIMAL(10,2)  DEFAULT 0,
    MaxDiscount     DECIMAL(10,2),
    ValidFrom       DATE           NOT NULL,
    ValidTo         DATE           NOT NULL,
    IsActive        BOOLEAN        DEFAULT TRUE,
    UsageLimit      INT            DEFAULT 1
);

-- Restaurant details linked to an owner
CREATE TABLE Restaurant (
    RestaurantID   INT PRIMARY KEY AUTO_INCREMENT,
    OwnerID        INT            NOT NULL,
    Name           VARCHAR(150)   NOT NULL,
    Address        VARCHAR(255)   NOT NULL,
    Phone          VARCHAR(15)    NOT NULL,
    Email          VARCHAR(100)   NOT NULL UNIQUE,
    CuisineType    VARCHAR(100),
    OperatingHours VARCHAR(100),
    Rating         DECIMAL(3,2)   DEFAULT 0.00,
    IsActive       BOOLEAN        DEFAULT TRUE,
    RegistrationDate DATE         DEFAULT (CURRENT_DATE),
    FOREIGN KEY (OwnerID) REFERENCES RestaurantOwner(OwnerID) ON DELETE CASCADE
);

-- Menu items belonging to a restaurant and category
CREATE TABLE MenuItem (
    ItemID       INT PRIMARY KEY AUTO_INCREMENT,
    RestaurantID INT            NOT NULL,
    CategoryID   INT            NOT NULL,
    ItemName     VARCHAR(150)   NOT NULL,
    Description  TEXT,
    Price        DECIMAL(10,2)  NOT NULL,
    IsAvailable  BOOLEAN        DEFAULT TRUE,
    ImageURL     VARCHAR(255),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID)   REFERENCES Category(CategoryID)
);

-- Weak entity: customization options for a menu item (e.g. size, spice level)
CREATE TABLE MenuOption (
    OptionID   INT          NOT NULL,
    ItemID     INT          NOT NULL,
    OptionName VARCHAR(100) NOT NULL,
    ExtraPrice DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (ItemID, OptionID),               -- composite PK (weak entity)
    FOREIGN KEY (ItemID) REFERENCES MenuItem(ItemID) ON DELETE CASCADE
);

-- Vehicle details for a delivery partner
CREATE TABLE Vehicle (
    VehicleID   INT PRIMARY KEY AUTO_INCREMENT,
    PartnerID   INT         NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    PlateNumber VARCHAR(20) NOT NULL UNIQUE,
    FOREIGN KEY (PartnerID) REFERENCES DeliveryPartner(PartnerID) ON DELETE CASCADE
);

-- Saved delivery addresses for a customer
CREATE TABLE DeliveryAddress (
    AddressID    INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID   INT          NOT NULL,
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255),
    City         VARCHAR(100) NOT NULL,
    State        VARCHAR(100) NOT NULL,
    Pincode      VARCHAR(10)  NOT NULL,
    Landmark     VARCHAR(150),
    AddressType  ENUM('Home','Work','Other') DEFAULT 'Home',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

-- Main orders table
CREATE TABLE Orders (
    OrderID          INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID       INT            NOT NULL,
    RestaurantID     INT            NOT NULL,
    DeliveryPartnerID INT,
    AddressID        INT            NOT NULL,
    OrderDate        DATE           DEFAULT (CURRENT_DATE),
    OrderTime        TIME           DEFAULT (CURRENT_TIME),
    Status           ENUM('Pending','Confirmed','Preparing','OutForDelivery','Delivered','Cancelled') DEFAULT 'Pending',
    TotalAmount      DECIMAL(10,2)  DEFAULT 0.00,
    DeliveryCharge   DECIMAL(10,2)  DEFAULT 0.00,
    Discount         DECIMAL(10,2)  DEFAULT 0.00,
    FinalAmount      DECIMAL(10,2)  DEFAULT 0.00,
    FOREIGN KEY (CustomerID)        REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID)      REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (DeliveryPartnerID) REFERENCES DeliveryPartner(PartnerID),
    FOREIGN KEY (AddressID)         REFERENCES DeliveryAddress(AddressID)
);

-- Tracks every status change for an order (audit trail)
CREATE TABLE OrderStatusHistory (
    HistoryID  INT PRIMARY KEY AUTO_INCREMENT,
    OrderID    INT         NOT NULL,
    Status     ENUM('Pending','Confirmed','Preparing','OutForDelivery','Delivered','Cancelled') NOT NULL,
    StatusTime DATETIME    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Payment record for each order (1:1 with Orders)
CREATE TABLE Payment (
    PaymentID     INT PRIMARY KEY AUTO_INCREMENT,
    OrderID       INT            NOT NULL UNIQUE,   -- UNIQUE enforces 1:1
    PaymentMethod ENUM('Cash','Card','UPI','Wallet') NOT NULL,
    Amount        DECIMAL(10,2)  NOT NULL,
    Status        ENUM('Pending','Success','Failed') DEFAULT 'Pending',
    TransactionID VARCHAR(100)   UNIQUE,
    PaymentDate   DATE           DEFAULT (CURRENT_DATE),
    PaymentTime   TIME           DEFAULT (CURRENT_TIME),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Polymorphic rating: either restaurant OR delivery partner (not both, not neither)
CREATE TABLE Rating (
    RatingID     INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID   INT NOT NULL,
    RestaurantID INT,                              -- nullable: rated only if restaurant rating
    PartnerID    INT,                              -- nullable: rated only if partner rating
    RatingValue  INT NOT NULL,
    RatingDate   DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (CustomerID)   REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (PartnerID)    REFERENCES DeliveryPartner(PartnerID),
    -- Exactly one of RestaurantID or PartnerID must be filled
    CONSTRAINT chk_rating_target CHECK (
        (RestaurantID IS NOT NULL AND PartnerID IS NULL) OR
        (RestaurantID IS NULL     AND PartnerID IS NOT NULL)
    )
);

-- Customer reviews for restaurants (text feedback)
CREATE TABLE Review (
    ReviewID   INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT  NOT NULL,
    RestaurantID INT NOT NULL,
    ReviewText TEXT NOT NULL,
    ReviewDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (CustomerID)   REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- ========================
-- BRIDGE TABLES (M:N resolvers)
-- ========================

-- Resolves M:N between Orders and MenuItem
CREATE TABLE OrderItem (
    OrderItemID  INT PRIMARY KEY AUTO_INCREMENT,
    OrderID      INT            NOT NULL,
    ItemID       INT            NOT NULL,
    Quantity     INT            NOT NULL DEFAULT 1,
    PriceAtOrder DECIMAL(10,2)  NOT NULL,          -- snapshot of price at order time
    Subtotal     DECIMAL(10,2)  NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID)  REFERENCES MenuItem(ItemID)
);

-- Resolves M:N between Orders and Coupon
CREATE TABLE OrderCoupon (
    OrderID         INT           NOT NULL,
    CouponID        INT           NOT NULL,
    DiscountApplied DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, CouponID),               -- composite PK
    FOREIGN KEY (OrderID)  REFERENCES Orders(OrderID),
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
);

-- Audit log for deleted customers
CREATE TABLE CustomerDeletionLog (
    LogID       INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID  INT          NOT NULL,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    DeletedAt   DATETIME     DEFAULT CURRENT_TIMESTAMP
);
-- Audit log for deleted customers
CREATE TABLE CustomerDeletionLog (
    LogID       INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID  INT          NOT NULL,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    DeletedAt   DATETIME     DEFAULT CURRENT_TIMESTAMP
);