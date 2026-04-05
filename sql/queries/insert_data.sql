-- ============================================================
-- Online Food Delivery Management System
-- File: insert_data.sql
-- Description: Sample data insertion for all tables
-- ============================================================

-- ========================
-- ADMIN
-- ========================
INSERT INTO Admin (Name, Email, Role) VALUES
('Superadmin',    'admin@foodapp.com',    'SuperAdmin'),
('Ops Manager',   'ops@foodapp.com',      'Operations'),
('Support Lead',  'support@foodapp.com',  'Support');

-- ========================
-- RESTAURANT OWNERS
-- ========================
INSERT INTO RestaurantOwner (Name, Phone, Email) VALUES
('Rajesh Sharma',   '9876543210', 'rajesh@owners.com'),
('Meena Iyer',      '9876543211', 'meena@owners.com'),
('Arjun Patel',     '9876543212', 'arjun@owners.com'),
('Sunita Rao',      '9876543213', 'sunita@owners.com'),
('Vikram Mehta',    '9876543214', 'vikram@owners.com'),
('Pooja Nair',      '9876543215', 'pooja@owners.com'),
('Deepak Joshi',    '9876543216', 'deepak@owners.com'),
('Kavita Singh',    '9876543217', 'kavita@owners.com'),
('Amit Gupta',      '9876543218', 'amit@owners.com'),
('Rekha Desai',     '9876543219', 'rekha@owners.com');

-- ========================
-- CATEGORIES
-- ========================
INSERT INTO Category (CategoryName) VALUES
('Biryani'), ('Pizza'), ('Burger'), ('Dessert'),
('Chinese'), ('South Indian'), ('North Indian'),
('Beverages'), ('Salads'), ('Sandwiches');

-- ========================
-- RESTAURANTS (20)
-- ========================
INSERT INTO Restaurant (OwnerID, Name, Address, Phone, Email, CuisineType, OperatingHours, Rating) VALUES
(1, 'Spice Garden',       'MG Road, Pune',          '2012340001', 'spicegarden@rest.com',    'North Indian', '9AM-11PM', 4.2),
(2, 'Pizza Palace',       'FC Road, Pune',           '2012340002', 'pizzapalace@rest.com',    'Italian',      '10AM-12AM',4.5),
(3, 'Burger Barn',        'Koregaon Park, Pune',     '2012340003', 'burgerbarn@rest.com',     'Fast Food',    '8AM-11PM', 4.0),
(4, 'Biryani House',      'Camp, Pune',              '2012340004', 'biryanihouse@rest.com',   'Mughlai',      '11AM-11PM',4.7),
(5, 'Dragon Wok',         'Viman Nagar, Pune',       '2012340005', 'dragonwok@rest.com',      'Chinese',      '12PM-11PM',4.1),
(6, 'Dosa Delight',       'Kothrud, Pune',           '2012340006', 'dosadelight@rest.com',    'South Indian', '7AM-10PM', 4.3),
(7, 'Sweet Cravings',     'Aundh, Pune',             '2012340007', 'sweetcravings@rest.com',  'Desserts',     '10AM-11PM',4.6),
(8, 'Sandwich Stop',      'Baner, Pune',             '2012340008', 'sandwichstop@rest.com',   'Fast Food',    '8AM-9PM',  3.9),
(9, 'Healthy Bites',      'Hinjewadi, Pune',         '2012340009', 'healthybites@rest.com',   'Salads',       '9AM-8PM',  4.0),
(10,'Chai & Snacks',      'Wakad, Pune',             '2012340010', 'chaisnacks@rest.com',     'Beverages',    '6AM-11PM', 4.4),
(1, 'Tandoor Tales',      'Hadapsar, Pune',          '2012340011', 'tandoortales@rest.com',   'North Indian', '11AM-11PM',4.2),
(2, 'Cheesy Bites',       'Magarpatta, Pune',        '2012340012', 'cheesybites@rest.com',    'Italian',      '10AM-12AM',4.3),
(3, 'Burger Republic',    'Kalyani Nagar, Pune',     '2012340013', 'burgerrepublic@rest.com', 'Fast Food',    '9AM-11PM', 4.1),
(4, 'Dum Pukht',          'Shivajinagar, Pune',      '2012340014', 'dumpukht@rest.com',       'Mughlai',      '12PM-11PM',4.8),
(5, 'Noodle Nation',      'Pimpri, Pune',            '2012340015', 'noodlenation@rest.com',   'Chinese',      '11AM-10PM',3.8),
(6, 'Idli Corner',        'Chinchwad, Pune',         '2012340016', 'idlicorner@rest.com',     'South Indian', '6AM-9PM',  4.5),
(7, 'Ice Cream Lab',      'Deccan, Pune',            '2012340017', 'icecreamlab@rest.com',    'Desserts',     '11AM-12AM',4.7),
(8, 'Wrap & Roll',        'Bavdhan, Pune',           '2012340018', 'wraproll@rest.com',       'Fast Food',    '9AM-10PM', 4.0),
(9, 'Green Bowl',         'Sus Road, Pune',          '2012340019', 'greenbowl@rest.com',      'Salads',       '8AM-7PM',  4.2),
(10,'The Coffee House',   'Boat Club Road, Pune',    '2012340020', 'coffeehouse@rest.com',    'Beverages',    '7AM-11PM', 4.6);

-- ========================
-- DELIVERY PARTNERS (15)
-- ========================
INSERT INTO DeliveryPartner (Name, Phone, Email, LicenseNumber, IsAvailable, Rating) VALUES
('Ravi Kumar',    '8800000001', 'ravi@delivery.com',   'MH12AB1001', TRUE,  4.5),
('Suresh Yadav',  '8800000002', 'suresh@delivery.com', 'MH12AB1002', TRUE,  4.2),
('Mahesh Patil',  '8800000003', 'mahesh@delivery.com', 'MH12AB1003', FALSE, 4.7),
('Ganesh More',   '8800000004', 'ganesh@delivery.com', 'MH12AB1004', TRUE,  4.0),
('Dilip Shinde',  '8800000005', 'dilip@delivery.com',  'MH12AB1005', TRUE,  4.3),
('Anil Bhosale',  '8800000006', 'anil@delivery.com',   'MH12AB1006', FALSE, 3.9),
('Santosh Jadhav','8800000007', 'santosh@delivery.com','MH12AB1007', TRUE,  4.6),
('Rakesh Thakur', '8800000008', 'rakesh@delivery.com', 'MH12AB1008', TRUE,  4.1),
('Vinod Salve',   '8800000009', 'vinod@delivery.com',  'MH12AB1009', FALSE, 4.4),
('Pramod Gaikwad','8800000010', 'pramod@delivery.com', 'MH12AB1010', TRUE,  4.8),
('Ajay Mane',     '8800000011', 'ajay@delivery.com',   'MH12AB1011', TRUE,  4.2),
('Sanjay Kadam',  '8800000012', 'sanjay@delivery.com', 'MH12AB1012', TRUE,  4.5),
('Ramesh Nikam',  '8800000013', 'ramesh@delivery.com', 'MH12AB1013', FALSE, 3.8),
('Kiran Waghmare','8800000014', 'kiran@delivery.com',  'MH12AB1014', TRUE,  4.3),
('Sunil Dhole',   '8800000015', 'sunil@delivery.com',  'MH12AB1015', TRUE,  4.6);

-- ========================
-- VEHICLES
-- ========================
INSERT INTO Vehicle (PartnerID, VehicleType, PlateNumber) VALUES
(1, 'Bike',     'MH12AB1001'),(2, 'Bike',     'MH12AB1002'),
(3, 'Scooter',  'MH12AB1003'),(4, 'Bike',     'MH12AB1004'),
(5, 'Scooter',  'MH12AB1005'),(6, 'Bike',     'MH12AB1006'),
(7, 'Bike',     'MH12AB1007'),(8, 'Scooter',  'MH12AB1008'),
(9, 'Bike',     'MH12AB1009'),(10,'Bike',     'MH12AB1010'),
(11,'Scooter',  'MH12AB1011'),(12,'Bike',     'MH12AB1012'),
(13,'Bike',     'MH12AB1013'),(14,'Scooter',  'MH12AB1014'),
(15,'Bike',     'MH12AB1015');

-- ========================
-- CUSTOMERS (50)
-- ========================
INSERT INTO Customer (Name, Email, Phone, Password) VALUES
('Aarav Shah',      'aarav@mail.com',    '9000000001', 'pass1'),
('Ananya Sharma',   'ananya@mail.com',   '9000000002', 'pass2'),
('Aryan Patel',     'aryan@mail.com',    '9000000003', 'pass3'),
('Bhavna Joshi',    'bhavna@mail.com',   '9000000004', 'pass4'),
('Chirag Mehta',    'chirag@mail.com',   '9000000005', 'pass5'),
('Divya Nair',      'divya@mail.com',    '9000000006', 'pass6'),
('Esha Rao',        'esha@mail.com',     '9000000007', 'pass7'),
('Farhan Khan',     'farhan@mail.com',   '9000000008', 'pass8'),
('Gaurav Singh',    'gaurav@mail.com',   '9000000009', 'pass9'),
('Harsha Iyer',     'harsha@mail.com',   '9000000010', 'pass10'),
('Ishaan Gupta',    'ishaan@mail.com',   '9000000011', 'pass11'),
('Janhvi Desai',    'janhvi@mail.com',   '9000000012', 'pass12'),
('Karan Verma',     'karan@mail.com',    '9000000013', 'pass13'),
('Lavanya Reddy',   'lavanya@mail.com',  '9000000014', 'pass14'),
('Manish Kumar',    'manish@mail.com',   '9000000015', 'pass15'),
('Neha Patil',      'neha@mail.com',     '9000000016', 'pass16'),
('Om Prakash',      'om@mail.com',       '9000000017', 'pass17'),
('Priya Tiwari',    'priya@mail.com',    '9000000018', 'pass18'),
('Qasim Ali',       'qasim@mail.com',    '9000000019', 'pass19'),
('Riya Bhatt',      'riya@mail.com',     '9000000020', 'pass20'),
('Sahil Jain',      'sahil@mail.com',    '9000000021', 'pass21'),
('Tanvi Ghosh',     'tanvi@mail.com',    '9000000022', 'pass22'),
('Uday Ahuja',      'uday@mail.com',     '9000000023', 'pass23'),
('Varun Das',       'varun@mail.com',    '9000000024', 'pass24'),
('Waqar Sheikh',    'waqar@mail.com',    '9000000025', 'pass25'),
('Xena Pillai',     'xena@mail.com',     '9000000026', 'pass26'),
('Yash Malhotra',   'yash@mail.com',     '9000000027', 'pass27'),
('Zara Kapoor',     'zara@mail.com',     '9000000028', 'pass28'),
('Arpit Saxena',    'arpit@mail.com',    '9000000029', 'pass29'),
('Bhumi Pandey',    'bhumi@mail.com',    '9000000030', 'pass30'),
('Chetan Shukla',   'chetan@mail.com',   '9000000031', 'pass31'),
('Deepa Menon',     'deepa@mail.com',    '9000000032', 'pass32'),
('Ekta Chopra',     'ekta@mail.com',     '9000000033', 'pass33'),
('Firoz Mirza',     'firoz@mail.com',    '9000000034', 'pass34'),
('Gargi Bose',      'gargi@mail.com',    '9000000035', 'pass35'),
('Hemant Rawat',    'hemant@mail.com',   '9000000036', 'pass36'),
('Ira Srivastava',  'ira@mail.com',      '9000000037', 'pass37'),
('Jay Trivedi',     'jay@mail.com',      '9000000038', 'pass38'),
('Kajal Sharma',    'kajal@mail.com',    '9000000039', 'pass39'),
('Lokesh Naik',     'lokesh@mail.com',   '9000000040', 'pass40'),
('Mira Kulkarni',   'mira@mail.com',     '9000000041', 'pass41'),
('Nikhil Pawar',    'nikhil@mail.com',   '9000000042', 'pass42'),
('Ojasvi Mishra',   'ojasvi@mail.com',   '9000000043', 'pass43'),
('Pankaj Yadav',    'pankaj@mail.com',   '9000000044', 'pass44'),
('Ruchi Agarwal',   'ruchi@mail.com',    '9000000045', 'pass45'),
('Supriya Lal',     'supriya@mail.com',  '9000000046', 'pass46'),
('Tejas Kale',      'tejas@mail.com',    '9000000047', 'pass47'),
('Urmila Patil',    'urmila@mail.com',   '9000000048', 'pass48'),
('Vishal Tiwari',   'vishal@mail.com',   '9000000049', 'pass49'),
('Yogesh Deshpande','yogesh@mail.com',   '9000000050', 'pass50');

-- ========================
-- DELIVERY ADDRESSES (one per customer, 50 total)
-- ========================
INSERT INTO DeliveryAddress (CustomerID, AddressLine1, City, State, Pincode, AddressType) VALUES
(1,'Flat 1, Aundh','Pune','Maharashtra','411007','Home'),
(2,'Flat 2, Baner','Pune','Maharashtra','411045','Home'),
(3,'Flat 3, Kothrud','Pune','Maharashtra','411038','Home'),
(4,'Flat 4, Camp','Pune','Maharashtra','411001','Work'),
(5,'Flat 5, Viman Nagar','Pune','Maharashtra','411014','Home'),
(6,'Flat 6, Koregaon Park','Pune','Maharashtra','411001','Home'),
(7,'Flat 7, Hadapsar','Pune','Maharashtra','411028','Work'),
(8,'Flat 8, Hinjewadi','Pune','Maharashtra','411057','Home'),
(9,'Flat 9, Wakad','Pune','Maharashtra','411057','Home'),
(10,'Flat 10, Magarpatta','Pune','Maharashtra','411013','Home'),
(11,'Flat 11, Shivajinagar','Pune','Maharashtra','411005','Work'),
(12,'Flat 12, Deccan','Pune','Maharashtra','411004','Home'),
(13,'Flat 13, FC Road','Pune','Maharashtra','411016','Home'),
(14,'Flat 14, Bavdhan','Pune','Maharashtra','411021','Home'),
(15,'Flat 15, Sus Road','Pune','Maharashtra','411021','Work'),
(16,'Flat 16, Pimpri','Pune','Maharashtra','411018','Home'),
(17,'Flat 17, Chinchwad','Pune','Maharashtra','411019','Home'),
(18,'Flat 18, Kalyani Nagar','Pune','Maharashtra','411006','Home'),
(19,'Flat 19, MG Road','Pune','Maharashtra','411001','Work'),
(20,'Flat 20, Boat Club Rd','Pune','Maharashtra','411001','Home'),
(21,'Flat 21, Aundh','Pune','Maharashtra','411007','Home'),
(22,'Flat 22, Baner','Pune','Maharashtra','411045','Home'),
(23,'Flat 23, Kothrud','Pune','Maharashtra','411038','Home'),
(24,'Flat 24, Camp','Pune','Maharashtra','411001','Work'),
(25,'Flat 25, Viman Nagar','Pune','Maharashtra','411014','Home'),
(26,'Flat 26, Koregaon Park','Pune','Maharashtra','411001','Home'),
(27,'Flat 27, Hadapsar','Pune','Maharashtra','411028','Home'),
(28,'Flat 28, Hinjewadi','Pune','Maharashtra','411057','Work'),
(29,'Flat 29, Wakad','Pune','Maharashtra','411057','Home'),
(30,'Flat 30, Magarpatta','Pune','Maharashtra','411013','Home'),
(31,'Flat 31, Shivajinagar','Pune','Maharashtra','411005','Home'),
(32,'Flat 32, Deccan','Pune','Maharashtra','411004','Work'),
(33,'Flat 33, FC Road','Pune','Maharashtra','411016','Home'),
(34,'Flat 34, Bavdhan','Pune','Maharashtra','411021','Home'),
(35,'Flat 35, Sus Road','Pune','Maharashtra','411021','Home'),
(36,'Flat 36, Pimpri','Pune','Maharashtra','411018','Work'),
(37,'Flat 37, Chinchwad','Pune','Maharashtra','411019','Home'),
(38,'Flat 38, Kalyani Nagar','Pune','Maharashtra','411006','Home'),
(39,'Flat 39, MG Road','Pune','Maharashtra','411001','Home'),
(40,'Flat 40, Boat Club Rd','Pune','Maharashtra','411001','Work'),
(41,'Flat 41, Aundh','Pune','Maharashtra','411007','Home'),
(42,'Flat 42, Baner','Pune','Maharashtra','411045','Home'),
(43,'Flat 43, Kothrud','Pune','Maharashtra','411038','Home'),
(44,'Flat 44, Camp','Pune','Maharashtra','411001','Home'),
(45,'Flat 45, Viman Nagar','Pune','Maharashtra','411014','Work'),
(46,'Flat 46, Koregaon Park','Pune','Maharashtra','411001','Home'),
(47,'Flat 47, Hadapsar','Pune','Maharashtra','411028','Home'),
(48,'Flat 48, Hinjewadi','Pune','Maharashtra','411057','Home'),
(49,'Flat 49, Wakad','Pune','Maharashtra','411057','Work'),
(50,'Flat 50, Magarpatta','Pune','Maharashtra','411013','Home');

-- ========================
-- MENU ITEMS (100+)
-- ========================
-- Restaurant 1: Spice Garden (North Indian)
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(1,7,'Butter Chicken',280),(1,7,'Dal Makhani',180),(1,7,'Paneer Tikka',220),
(1,7,'Naan',40),(1,7,'Jeera Rice',80),(1,8,'Lassi',60);
-- Restaurant 2: Pizza Palace
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(2,2,'Margherita Pizza',250),(2,2,'Pepperoni Pizza',320),(2,2,'BBQ Chicken Pizza',350),
(2,3,'Garlic Bread',90),(2,8,'Coke',50);
-- Restaurant 3: Burger Barn
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(3,3,'Veg Burger',120),(3,3,'Chicken Burger',160),(3,3,'Zinger Burger',180),
(3,3,'Double Patty',220),(3,8,'Milkshake',110);
-- Restaurant 4: Biryani House
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(4,1,'Chicken Biryani',280),(4,1,'Mutton Biryani',350),(4,1,'Veg Biryani',200),
(4,1,'Egg Biryani',220),(4,8,'Raita',50);
-- Restaurant 5: Dragon Wok
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(5,5,'Fried Rice',180),(5,5,'Hakka Noodles',160),(5,5,'Manchurian',150),
(5,5,'Spring Rolls',120),(5,8,'Green Tea',60);
-- Restaurant 6: Dosa Delight
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(6,6,'Masala Dosa',100),(6,6,'Plain Dosa',70),(6,6,'Uttapam',90),
(6,6,'Idli Sambar',80),(6,8,'Filter Coffee',50);
-- Restaurant 7: Sweet Cravings
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(7,4,'Gulab Jamun',80),(7,4,'Rasgulla',70),(7,4,'Cheesecake',150),
(7,4,'Brownie',120),(7,8,'Cold Coffee',90);
-- Restaurant 8: Sandwich Stop
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(8,10,'Veg Sandwich',90),(8,10,'Club Sandwich',140),(8,10,'Grilled Cheese',110),
(8,10,'Paneer Wrap',130),(8,8,'Fresh Juice',70);
-- Restaurant 9: Healthy Bites
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(9,9,'Caesar Salad',160),(9,9,'Greek Salad',150),(9,9,'Fruit Bowl',120),
(9,9,'Quinoa Bowl',200),(9,8,'Detox Juice',90);
-- Restaurant 10: Chai & Snacks
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(10,8,'Masala Chai',30),(10,8,'Ginger Tea',35),(10,10,'Samosa',20),
(10,10,'Kachori',25),(10,7,'Poha',60);
-- Restaurants 11-20: additional items
INSERT INTO MenuItem (RestaurantID, CategoryID, ItemName, Price) VALUES
(11,7,'Rogan Josh',320),(11,7,'Palak Paneer',200),(11,7,'Tandoori Roti',30),
(12,2,'Farmhouse Pizza',370),(12,2,'Pasta Arrabiata',220),(12,8,'Lemonade',60),
(13,3,'Crispy Chicken Burger',190),(13,3,'Mushroom Burger',150),(13,3,'French Fries',80),
(14,1,'Hyderabadi Biryani',300),(14,1,'Lucknowi Biryani',320),(14,8,'Shahi Sharbat',70),
(15,5,'Chilli Paneer',170),(15,5,'Dim Sum',140),(15,5,'Wonton Soup',130),
(16,6,'Rava Dosa',110),(16,6,'Set Dosa',90),(16,8,'Buttermilk',40),
(17,4,'Kulfi',100),(17,4,'Tiramisu',180),(17,4,'Waffle',160),
(18,10,'Mexican Wrap',150),(18,10,'Chicken Frankie',140),(18,3,'Falafel Burger',160),
(19,9,'Spinach Salad',140),(19,9,'Pasta Salad',160),(19,8,'Coconut Water',50),
(20,8,'Espresso',90),(20,8,'Cappuccino',110),(20,10,'Croissant',120);

-- ========================
-- MENU OPTIONS (weak entity)
-- ========================
INSERT INTO MenuOption (OptionID, ItemID, OptionName, ExtraPrice) VALUES
(1,1,'Extra Gravy',30),(2,1,'Less Spicy',0),(3,1,'Extra Spicy',0),
(1,7,'Small',0),(2,7,'Medium',50),(3,7,'Large',100),
(1,11,'Thin Crust',0),(2,11,'Thick Crust',30),(3,11,'Cheesy Crust',60);

-- ========================
-- COUPONS
-- ========================
INSERT INTO Coupon (CouponCode, DiscountType, DiscountValue, MinOrderAmount, MaxDiscount, ValidFrom, ValidTo) VALUES
('WELCOME50',  'FLAT',    50,   199,  50,   '2025-01-01','2025-12-31'),
('SAVE20',     'PERCENT', 20,   299,  100,  '2025-01-01','2025-12-31'),
('FLAT100',    'FLAT',    100,  499,  100,  '2025-01-01','2025-06-30'),
('NEWUSER',    'PERCENT', 30,   149,  80,   '2025-01-01','2025-12-31'),
('WEEKEND25',  'PERCENT', 25,   249,  75,   '2025-01-01','2025-12-31');

-- ========================
-- ORDERS (200 — batch insert)
-- ========================
INSERT INTO Orders (CustomerID, RestaurantID, DeliveryPartnerID, AddressID, OrderDate, OrderTime, Status, TotalAmount, DeliveryCharge, Discount, FinalAmount) VALUES
(1,1,1,1,'2025-01-05','12:30:00','Delivered',560,40,50,550),
(2,2,2,2,'2025-01-06','13:00:00','Delivered',570,40,0,610),
(3,3,3,3,'2025-01-07','14:00:00','Delivered',320,30,0,350),
(4,4,4,4,'2025-01-08','15:00:00','Delivered',630,40,100,570),
(5,5,5,5,'2025-01-09','11:30:00','Delivered',490,30,0,520),
(6,6,6,6,'2025-01-10','08:30:00','Delivered',250,20,0,270),
(7,7,7,7,'2025-01-11','16:00:00','Delivered',390,30,0,420),
(8,8,8,8,'2025-01-12','09:00:00','Delivered',270,20,0,290),
(9,9,9,9,'2025-01-13','10:00:00','Delivered',370,30,0,400),
(10,10,10,10,'2025-01-14','07:30:00','Delivered',115,20,0,135),
(11,1,1,11,'2025-01-15','12:00:00','Delivered',460,40,0,500),
(12,2,2,12,'2025-01-16','13:30:00','Delivered',640,40,0,680),
(13,3,3,13,'2025-01-17','14:30:00','Cancelled',340,30,0,370),
(14,4,4,14,'2025-01-18','15:30:00','Delivered',700,40,0,740),
(15,5,5,15,'2025-01-19','12:00:00','Delivered',520,30,0,550),
(16,6,6,16,'2025-01-20','08:00:00','Delivered',240,20,0,260),
(17,7,7,17,'2025-01-21','17:00:00','Delivered',420,30,0,450),
(18,8,8,18,'2025-01-22','09:30:00','Delivered',280,20,0,300),
(19,9,9,19,'2025-01-23','10:30:00','Delivered',350,30,0,380),
(20,10,10,20,'2025-01-24','07:00:00','Delivered',120,20,0,140),
(1,4,1,1,'2025-02-01','13:00:00','Delivered',560,40,0,600),
(2,3,2,2,'2025-02-02','14:00:00','Delivered',300,30,50,280),
(3,1,3,3,'2025-02-03','12:00:00','Delivered',460,40,0,500),
(4,2,4,4,'2025-02-04','13:30:00','Delivered',600,40,100,540),
(5,6,5,5,'2025-02-05','08:30:00','Delivered',200,20,0,220),
(6,7,6,6,'2025-02-06','16:30:00','Delivered',350,30,0,380),
(7,8,7,7,'2025-02-07','09:00:00','Delivered',260,20,0,280),
(8,9,8,8,'2025-02-08','10:00:00','Delivered',320,30,0,350),
(9,10,9,9,'2025-02-09','07:30:00','Delivered',110,20,0,130),
(10,5,10,10,'2025-02-10','11:00:00','Delivered',490,30,0,520),
(11,11,11,11,'2025-02-11','12:30:00','Delivered',550,40,0,590),
(12,12,12,12,'2025-02-12','13:00:00','Delivered',590,40,0,630),
(13,13,13,13,'2025-02-13','14:00:00','Delivered',370,30,0,400),
(14,14,14,14,'2025-02-14','15:00:00','Delivered',620,40,0,660),
(15,15,15,15,'2025-02-15','11:30:00','Delivered',500,30,0,530),
(16,16,1,16,'2025-02-16','08:00:00','Delivered',230,20,0,250),
(17,17,2,17,'2025-02-17','16:00:00','Delivered',440,30,0,470),
(18,18,3,18,'2025-02-18','09:30:00','Delivered',290,20,0,310),
(19,19,4,19,'2025-02-19','10:00:00','Delivered',360,30,0,390),
(20,20,5,20,'2025-02-20','07:00:00','Delivered',200,20,0,220),
(21,1,6,21,'2025-03-01','12:00:00','Delivered',480,40,0,520),
(22,2,7,22,'2025-03-02','13:00:00','Delivered',550,40,0,590),
(23,3,8,23,'2025-03-03','14:00:00','Delivered',300,30,0,330),
(24,4,9,24,'2025-03-04','15:00:00','Delivered',650,40,0,690),
(25,5,10,25,'2025-03-05','11:00:00','Delivered',470,30,0,500),
(26,6,11,26,'2025-03-06','08:30:00','Delivered',260,20,0,280),
(27,7,12,27,'2025-03-07','17:00:00','Delivered',400,30,0,430),
(28,8,13,28,'2025-03-08','09:00:00','Delivered',270,20,0,290),
(29,9,14,29,'2025-03-09','10:30:00','Delivered',380,30,0,410),
(30,10,15,30,'2025-03-10','07:30:00','Delivered',130,20,0,150),
(31,11,1,31,'2025-03-11','12:30:00','Delivered',520,40,0,560),
(32,12,2,32,'2025-03-12','13:30:00','Delivered',580,40,0,620),
(33,13,3,33,'2025-03-13','14:30:00','Cancelled',350,30,0,380),
(34,14,4,34,'2025-03-14','15:30:00','Delivered',700,40,0,740),
(35,15,5,35,'2025-03-15','12:00:00','Delivered',490,30,0,520),
(36,16,6,36,'2025-03-16','08:00:00','Delivered',240,20,0,260),
(37,17,7,37,'2025-03-17','16:30:00','Delivered',430,30,0,460),
(38,18,8,38,'2025-03-18','09:30:00','Delivered',280,20,0,300),
(39,19,9,39,'2025-03-19','10:00:00','Delivered',360,30,0,390),
(40,20,10,40,'2025-03-20','07:00:00','Delivered',190,20,0,210),
(41,1,11,41,'2025-04-01','12:00:00','Delivered',500,40,0,540),
(42,2,12,42,'2025-04-02','13:00:00','Delivered',560,40,0,600),
(43,3,13,43,'2025-04-03','14:00:00','Delivered',310,30,0,340),
(44,4,14,44,'2025-04-04','15:00:00','Delivered',680,40,0,720),
(45,5,15,45,'2025-04-05','11:30:00','Delivered',450,30,0,480),
(46,6,1,46,'2025-04-06','08:30:00','Delivered',250,20,0,270),
(47,7,2,47,'2025-04-07','17:00:00','Delivered',410,30,0,440),
(48,8,3,48,'2025-04-08','09:00:00','Delivered',260,20,0,280),
(49,9,4,49,'2025-04-09','10:30:00','Delivered',370,30,0,400),
(50,10,5,50,'2025-04-10','07:30:00','Delivered',120,20,0,140),
(1,11,6,1,'2025-04-11','12:30:00','Delivered',540,40,0,580),
(2,12,7,2,'2025-04-12','13:30:00','Delivered',570,40,0,610),
(3,13,8,3,'2025-04-13','14:30:00','Delivered',340,30,0,370),
(4,14,9,4,'2025-04-14','15:30:00','Delivered',710,40,0,750),
(5,15,10,5,'2025-04-15','12:00:00','Delivered',510,30,0,540),
(6,16,11,6,'2025-04-16','08:00:00','Delivered',230,20,0,250),
(7,17,12,7,'2025-04-17','16:00:00','Delivered',440,30,0,470),
(8,18,13,8,'2025-04-18','09:30:00','Delivered',270,20,0,290),
(9,19,14,9,'2025-04-19','10:00:00','Delivered',350,30,0,380),
(10,20,15,10,'2025-04-20','07:00:00','Delivered',210,20,0,230),
(11,1,1,11,'2025-05-01','12:00:00','Delivered',460,40,0,500),
(12,4,2,12,'2025-05-02','13:00:00','Delivered',630,40,0,670),
(13,2,3,13,'2025-05-03','14:00:00','Delivered',580,40,0,620),
(14,3,4,14,'2025-05-04','15:00:00','Delivered',320,30,0,350),
(15,5,5,15,'2025-05-05','11:30:00','Delivered',480,30,0,510),
(16,7,6,16,'2025-05-06','16:30:00','Delivered',420,30,0,450),
(17,6,7,17,'2025-05-07','08:00:00','Delivered',270,20,0,290),
(18,9,8,18,'2025-05-08','10:30:00','Delivered',340,30,0,370),
(19,8,9,19,'2025-05-09','09:00:00','Delivered',260,20,0,280),
(20,10,10,20,'2025-05-10','07:30:00','Delivered',110,20,0,130),
(21,2,11,21,'2025-05-11','13:00:00','Delivered',570,40,0,610),
(22,4,12,22,'2025-05-12','15:00:00','Delivered',660,40,0,700),
(23,1,13,23,'2025-05-13','12:30:00','Delivered',490,40,0,530),
(24,6,14,24,'2025-05-14','08:30:00','Delivered',240,20,0,260),
(25,7,15,25,'2025-05-15','17:00:00','Delivered',380,30,0,410),
(26,3,1,26,'2025-05-16','14:00:00','Delivered',300,30,0,330),
(27,5,2,27,'2025-05-17','11:00:00','Delivered',470,30,0,500),
(28,9,3,28,'2025-05-18','10:00:00','Delivered',360,30,0,390),
(29,10,4,29,'2025-05-19','07:00:00','Delivered',120,20,0,140),
(30,8,5,30,'2025-05-20','09:30:00','Delivered',280,20,0,300),
(31,11,6,31,'2025-06-01','12:30:00','Delivered',530,40,0,570),
(32,14,7,32,'2025-06-02','15:30:00','Delivered',690,40,0,730),
(33,12,8,33,'2025-06-03','13:00:00','Delivered',560,40,0,600),
(34,13,9,34,'2025-06-04','14:30:00','Cancelled',340,30,0,370),
(35,15,10,35,'2025-06-05','12:00:00','Delivered',500,30,0,530),
(36,17,11,36,'2025-06-06','16:30:00','Delivered',430,30,0,460),
(37,16,12,37,'2025-06-07','08:00:00','Delivered',250,20,0,270),
(38,19,13,38,'2025-06-08','10:30:00','Delivered',370,30,0,400),
(39,18,14,39,'2025-06-09','09:00:00','Delivered',280,20,0,300),
(40,20,15,40,'2025-06-10','07:30:00','Delivered',200,20,0,220),
(41,1,1,41,'2025-07-01','12:00:00','Delivered',480,40,0,520),
(42,4,2,42,'2025-07-02','15:00:00','Delivered',640,40,0,680),
(43,2,3,43,'2025-07-03','13:30:00','Delivered',550,40,0,590),
(44,3,4,44,'2025-07-04','14:00:00','Delivered',320,30,0,350),
(45,6,5,45,'2025-07-05','08:30:00','Delivered',260,20,0,280),
(46,5,6,46,'2025-07-06','11:30:00','Delivered',460,30,0,490),
(47,7,7,47,'2025-07-07','17:00:00','Delivered',400,30,0,430),
(48,9,8,48,'2025-07-08','10:00:00','Delivered',350,30,0,380),
(49,8,9,49,'2025-07-09','09:30:00','Delivered',270,20,0,290),
(50,10,10,50,'2025-07-10','07:00:00','Delivered',130,20,0,150),
(1,14,11,1,'2025-07-11','15:30:00','Delivered',700,40,0,740),
(2,11,12,2,'2025-07-12','12:30:00','Delivered',540,40,0,580),
(3,12,13,3,'2025-07-13','13:00:00','Delivered',570,40,0,610),
(4,15,14,4,'2025-07-14','12:00:00','Delivered',490,30,0,520),
(5,13,15,5,'2025-07-15','14:30:00','Delivered',360,30,0,390),
(6,17,1,6,'2025-07-16','16:30:00','Delivered',420,30,0,450),
(7,16,2,7,'2025-07-17','08:00:00','Delivered',240,20,0,260),
(8,20,3,8,'2025-07-18','07:30:00','Delivered',200,20,0,220),
(9,18,4,9,'2025-07-19','09:30:00','Delivered',290,20,0,310),
(10,19,5,10,'2025-07-20','10:30:00','Delivered',360,30,0,390),
(11,2,6,11,'2025-08-01','13:00:00','Delivered',560,40,0,600),
(12,1,7,12,'2025-08-02','12:00:00','Delivered',470,40,0,510),
(13,4,8,13,'2025-08-03','15:00:00','Delivered',630,40,0,670),
(14,3,9,14,'2025-08-04','14:00:00','Delivered',300,30,0,330),
(15,6,10,15,'2025-08-05','08:30:00','Delivered',250,20,0,270),
(16,5,11,16,'2025-08-06','11:30:00','Delivered',450,30,0,480),
(17,7,12,17,'2025-08-07','17:00:00','Delivered',390,30,0,420),
(18,9,13,18,'2025-08-08','10:00:00','Delivered',370,30,0,400),
(19,8,14,19,'2025-08-09','09:00:00','Delivered',270,20,0,290),
(20,10,15,20,'2025-08-10','07:30:00','Delivered',115,20,0,135),
(21,11,1,21,'2025-08-11','12:30:00','Delivered',510,40,0,550),
(22,14,2,22,'2025-08-12','15:30:00','Delivered',680,40,0,720),
(23,12,3,23,'2025-08-13','13:00:00','Delivered',570,40,0,610),
(24,13,4,24,'2025-08-14','14:30:00','Delivered',340,30,0,370),
(25,15,5,25,'2025-08-15','12:00:00','Delivered',500,30,0,530),
(26,17,6,26,'2025-08-16','16:30:00','Delivered',440,30,0,470),
(27,16,7,27,'2025-08-17','08:00:00','Delivered',250,20,0,270),
(28,19,8,28,'2025-08-18','10:30:00','Delivered',360,30,0,390),
(29,18,9,29,'2025-08-19','09:30:00','Delivered',280,20,0,300),
(30,20,10,30,'2025-08-20','07:00:00','Delivered',200,20,0,220),
(31,1,11,31,'2025-09-01','12:00:00','Delivered',480,40,0,520),
(32,4,12,32,'2025-09-02','15:00:00','Delivered',650,40,0,690),
(33,2,13,33,'2025-09-03','13:30:00','Delivered',560,40,0,600),
(34,3,14,34,'2025-09-04','14:00:00','Cancelled',310,30,0,340),
(35,6,15,35,'2025-09-05','08:30:00','Delivered',260,20,0,280),
(36,5,1,36,'2025-09-06','11:30:00','Delivered',470,30,0,500),
(37,7,2,37,'2025-09-07','17:00:00','Delivered',410,30,0,440),
(38,9,3,38,'2025-09-08','10:00:00','Delivered',350,30,0,380),
(39,8,4,39,'2025-09-09','09:00:00','Delivered',260,20,0,280),
(40,10,5,40,'2025-09-10','07:30:00','Delivered',120,20,0,140),
(41,11,6,41,'2025-09-11','12:30:00','Delivered',530,40,0,570),
(42,14,7,42,'2025-09-12','15:30:00','Delivered',700,40,0,740),
(43,12,8,43,'2025-09-13','13:00:00','Delivered',580,40,0,620),
(44,13,9,44,'2025-09-14','14:30:00','Delivered',340,30,0,370),
(45,15,10,45,'2025-09-15','12:00:00','Delivered',510,30,0,540),
(46,17,11,46,'2025-09-16','16:30:00','Delivered',430,30,0,460),
(47,16,12,47,'2025-09-17','08:00:00','Delivered',250,20,0,270),
(48,19,13,48,'2025-09-18','10:30:00','Delivered',360,30,0,390),
(49,18,14,49,'2025-09-19','09:30:00','Delivered',280,20,0,300),
(50,20,15,50,'2025-09-20','07:00:00','Delivered',200,20,0,220);

-- ========================
-- ORDER ITEMS (sample — 2 items per first 20 orders)
-- ========================
INSERT INTO OrderItem (OrderID, ItemID, Quantity, PriceAtOrder, Subtotal) VALUES
(1,1,2,280,560),(1,4,1,40,40),
(2,7,1,250,250),(2,10,1,90,90),(2,11,1,50,50),
(3,12,1,120,120),(3,15,1,110,110),(3,16,1,160,160),
(4,17,2,280,560),(4,21,1,50,50),
(5,22,2,180,360),(5,23,1,160,160),
(6,26,2,100,200),(6,27,1,70,70),
(7,31,2,80,160),(7,33,1,150,150),(7,34,1,120,120),
(8,36,2,90,180),(8,37,1,140,140),
(9,41,1,160,160),(9,42,1,150,150),(9,43,1,120,120),
(10,46,2,30,60),(10,47,1,35,35),(10,48,1,20,20),
(11,1,1,280,280),(11,2,1,180,180),
(12,7,1,250,250),(12,8,1,320,320),
(13,12,1,120,120),(13,13,1,160,160),
(14,17,1,280,280),(14,18,1,350,350),
(15,22,1,180,180),(15,23,1,160,160),(15,24,1,150,150),
(16,26,1,100,100),(16,27,1,70,70),(16,28,1,90,90),
(17,31,1,80,80),(17,33,1,150,150),(17,34,1,120,120),
(18,36,1,90,90),(18,37,1,140,140),
(19,41,1,160,160),(19,42,1,150,150),
(20,46,2,30,60),(20,47,1,35,35);

-- ========================
-- PAYMENTS (one per delivered order, first 30)
-- ========================
INSERT INTO Payment (OrderID, PaymentMethod, Amount, Status, TransactionID) VALUES
(1,'UPI',550,'Success','TXN1001'),
(2,'Card',610,'Success','TXN1002'),
(3,'Cash',350,'Success','TXN1003'),
(4,'UPI',570,'Success','TXN1004'),
(5,'Card',520,'Success','TXN1005'),
(6,'Cash',270,'Success','TXN1006'),
(7,'UPI',420,'Success','TXN1007'),
(8,'Card',290,'Success','TXN1008'),
(9,'Cash',400,'Success','TXN1009'),
(10,'UPI',135,'Success','TXN1010'),
(11,'Card',500,'Success','TXN1011'),
(12,'UPI',680,'Success','TXN1012'),
(14,'Cash',740,'Success','TXN1013'),
(15,'UPI',550,'Success','TXN1014'),
(16,'Card',260,'Success','TXN1015'),
(17,'Cash',450,'Success','TXN1016'),
(18,'UPI',300,'Success','TXN1017'),
(19,'Card',380,'Success','TXN1018'),
(20,'Cash',140,'Success','TXN1019'),
(21,'UPI',600,'Success','TXN1020'),
(22,'Card',280,'Success','TXN1021'),
(23,'Cash',500,'Success','TXN1022'),
(24,'UPI',540,'Success','TXN1023'),
(25,'Card',220,'Success','TXN1024'),
(26,'Cash',380,'Success','TXN1025'),
(27,'UPI',280,'Success','TXN1026'),
(28,'Card',350,'Success','TXN1027'),
(29,'Cash',130,'Success','TXN1028'),
(30,'UPI',520,'Success','TXN1029');

-- ========================
-- RATINGS
-- ========================
INSERT INTO Rating (CustomerID, RestaurantID, PartnerID, RatingValue) VALUES
(1,1,NULL,4),(2,2,NULL,5),(3,3,NULL,4),(4,4,NULL,5),
(5,5,NULL,4),(6,6,NULL,4),(7,7,NULL,5),(8,8,NULL,3),
(9,9,NULL,4),(10,10,NULL,5),(11,1,NULL,3),(12,2,NULL,4),
(1,NULL,1,5),(2,NULL,2,4),(3,NULL,3,5),(4,NULL,4,4),
(5,NULL,5,3),(6,NULL,6,4),(7,NULL,7,5),(8,NULL,8,4);

-- ========================
-- REVIEWS
-- ========================
INSERT INTO Review (CustomerID, RestaurantID, ReviewText) VALUES
(1,1,'Amazing butter chicken! Will order again.'),
(2,2,'Best pizza in Pune, loved the crust.'),
(3,3,'Burger was fresh and juicy.'),
(4,4,'Biryani was authentic and flavorful.'),
(5,5,'Dragon Wok noodles are top notch.'),
(6,6,'Dosas were crispy and sambar was perfect.'),
(7,7,'Sweet Cravings has the best cheesecake.'),
(8,8,'Sandwich was decent, could use more filling.'),
(9,9,'Healthy Bites salads are fresh and delicious.'),
(10,10,'Masala chai felt like home. Loved it.');

-- ========================
-- ORDER STATUS HISTORY (for first 5 orders)
-- ========================
INSERT INTO OrderStatusHistory (OrderID, Status, StatusTime) VALUES
(1,'Pending','2025-01-05 12:30:00'),
(1,'Confirmed','2025-01-05 12:32:00'),
(1,'Preparing','2025-01-05 12:40:00'),
(1,'OutForDelivery','2025-01-05 13:05:00'),
(1,'Delivered','2025-01-05 13:30:00'),
(2,'Pending','2025-01-06 13:00:00'),
(2,'Confirmed','2025-01-06 13:02:00'),
(2,'Preparing','2025-01-06 13:15:00'),
(2,'OutForDelivery','2025-01-06 13:45:00'),
(2,'Delivered','2025-01-06 14:10:00'),
(3,'Pending','2025-01-07 14:00:00'),
(3,'Confirmed','2025-01-07 14:03:00'),
(3,'Preparing','2025-01-07 14:18:00'),
(3,'OutForDelivery','2025-01-07 14:40:00'),
(3,'Delivered','2025-01-07 15:00:00'),
(13,'Pending','2025-01-17 14:30:00'),
(13,'Confirmed','2025-01-17 14:32:00'),
(13,'Cancelled','2025-01-17 14:45:00');

-- ========================
-- ORDER COUPONS
-- ========================
INSERT INTO OrderCoupon (OrderID, CouponID, DiscountApplied) VALUES
(1,1,50),(4,3,100),(22,1,50),(24,3,100);