package fooddelivery;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

// implements IOrderOperations — satisfies interface contract
public class OrderDAO implements IOrderOperations {

    private Connection conn;

    public OrderDAO() {
        try {
            this.conn = DBConnection.getConnection();
        } catch (SQLException e) {
            System.out.println("Connection error: " + e.getMessage());
        }
    }

    // --- PLACE ORDER via stored procedure (CallableStatement) ---
    @Override
    public void placeOrder(int customerID, int restaurantID, int addressID, double deliveryCharge) {
        String sql = "{CALL PlaceOrder(?, ?, ?, ?, ?)}";
        try (CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, customerID);
            cs.setInt(2, restaurantID);
            cs.setInt(3, addressID);
            cs.setDouble(4, deliveryCharge);
            cs.registerOutParameter(5, Types.INTEGER); // OUT param: new OrderID
            cs.execute();
            int newOrderID = cs.getInt(5);
            System.out.println("Order placed successfully! Order ID: " + newOrderID);
        } catch (SQLException e) {
            try { throw new OrderException("Failed to place order: " + e.getMessage()); }
            catch (OrderException oe) { oe.printDetails(); }
        }
    }
    // --- PROCESS PAYMENT via stored procedure ---
public void processPayment(int orderID, String method, String transactionID) {
    String sql = "{CALL ProcessPayment(?, ?, ?)}";
    try (CallableStatement cs = conn.prepareCall(sql)) {
        cs.setInt(1, orderID);
        cs.setString(2, method);
        cs.setString(3, transactionID);
        cs.execute();
        System.out.println("Payment processed for Order ID: " + orderID);
    } catch (SQLException e) {
        try { throw new PaymentException("Payment failed: " + e.getMessage(), transactionID); }
        catch (PaymentException pe) { pe.printDetails(); }
    }
}
    // --- VIEW ORDERS BY CUSTOMER (PreparedStatement) ---
    @Override
    public void viewOrdersByCustomer(int customerID) {
       String sql = "SELECT O.OrderID, R.Name AS Restaurant, O.Status, O.FinalAmount, " +
                     "O.OrderDate, O.OrderTime " +
                    "FROM Orders O JOIN Restaurant R ON O.RestaurantID = R.RestaurantID " +
                    "WHERE O.CustomerID = ? ORDER BY O.OrderDate DESC, O.OrderTime DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            System.out.println("\n--- Orders for Customer ID: " + customerID + " ---");
            while (rs.next()) {
                RestaurantOrder order = new RestaurantOrder(
                    rs.getInt("OrderID"),
                    customerID,
                    0, // restaurantID not needed for display
                    rs.getDouble("FinalAmount"),
                    rs.getString("Status")
                );
                System.out.println("OrderID: " + order.getId() +
                                  " | Restaurant: " + rs.getString("Restaurant") +
                                  " | Status: " + order.getStatus() +
                                  " | Amount: ₹" + order.getFinalAmount() +
                                  " | Date: " + rs.getDate("OrderDate") +
                                  " | Time: " + rs.getTime("OrderTime"));
            }
        } catch (SQLException e) {
            System.out.println("ViewOrders error: " + e.getMessage());
        }
    }

    // --- UPDATE ORDER STATUS via stored procedure ---
    @Override
    public void updateOrderStatus(int orderID, String newStatus) {
        String sql = "{CALL UpdateOrderStatus(?, ?)}";
        try (CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, orderID);
            cs.setString(2, newStatus);
            cs.execute();
            System.out.println("Order " + orderID + " updated to: " + newStatus);
        } catch (SQLException e) {
            System.out.println("UpdateStatus error: " + e.getMessage());
        }
    }

    // --- LOYALTY DISCOUNT ---
// If customer has spent > 1500 at a specific restaurant, apply 10% off on given order
public void applyLoyaltyDiscount(int customerID, int restaurantID, int orderID) {
    String checkSql = "SELECT SUM(O.FinalAmount) AS TotalSpent " +
                      "FROM Orders O " +
                      "WHERE O.CustomerID = ? AND O.RestaurantID = ? AND O.Status = 'Delivered'";

    String applySQL = "UPDATE Orders " +
                      "SET Discount = ROUND(FinalAmount * 0.10, 2), " +
                      "FinalAmount = ROUND(FinalAmount * 0.90, 2) " +
                      "WHERE OrderID = ?";

    try {
        // STEP 1: Check eligibility
        PreparedStatement checkPs = conn.prepareStatement(checkSql);
        checkPs.setInt(1, customerID);
        checkPs.setInt(2, restaurantID);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            double totalSpent = rs.getDouble("TotalSpent");
            System.out.println("Total spent by Customer " + customerID +
                               " at Restaurant " + restaurantID +
                               ": ₹" + totalSpent);

            if (totalSpent >= 1500) {
                // STEP 2: Eligible — apply 10% discount
                PreparedStatement applyPs = conn.prepareStatement(applySQL);
                applyPs.setInt(1, orderID);
                int rows = applyPs.executeUpdate();

                if (rows > 0) {
                    // STEP 3: Fetch and show updated order
                    String fetchSql = "SELECT FinalAmount, Discount FROM Orders WHERE OrderID = ?";
                    PreparedStatement fetchPs = conn.prepareStatement(fetchSql);
                    fetchPs.setInt(1, orderID);
                    ResultSet fetchRs = fetchPs.executeQuery();

                    if (fetchRs.next()) {
                         double discount   = fetchRs.getDouble("Discount");
                         double newAmount  = fetchRs.getDouble("FinalAmount");
                         double oldAmount  = Math.round((newAmount + discount) * 100.0) / 100.0;
                         System.out.println("----------------------------------------");
                         System.out.println("** Loyalty Discount Applied! **");
                         System.out.println("   Original Amount  : Rs." + oldAmount);
                         System.out.println("   Discount (10%)   : Rs." + discount);
                         System.out.println("   You Pay          : Rs." + newAmount);
                         System.out.println("----------------------------------------");
                    }
                }
            } else {
                // Not eligible
                double remaining = 1500 - totalSpent;
                System.out.println(">> Not eligible yet for loyalty discount.");
                System.out.println("   Spend ₹" + remaining + " more at this restaurant to unlock 10% off!");
            }
        }
    } catch (SQLException e) {
        System.out.println("Loyalty discount error: " + e.getMessage());
    }
}

    // --- TOP RESTAURANTS by revenue (regular Statement) ---
    @Override
    public List<String> getTopRestaurants() {
        List<String> results = new ArrayList<>();
        String sql = "SELECT R.Name, COUNT(O.OrderID) AS Orders, SUM(O.FinalAmount) AS Revenue " +
                     "FROM Restaurant R JOIN Orders O ON R.RestaurantID = O.RestaurantID " +
                     "WHERE O.Status = 'Delivered' GROUP BY R.RestaurantID ORDER BY Revenue DESC LIMIT 5";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            System.out.println("\n--- Top 5 Restaurants by Revenue ---");
            while (rs.next()) {
                String row = rs.getString("Name") +
                             " | Orders: " + rs.getInt("Orders") +
                             " | Revenue: ₹" + rs.getDouble("Revenue");
                System.out.println(row);
                results.add(row);
            }
        } catch (SQLException e) {
            System.out.println("TopRestaurants error: " + e.getMessage());
        }
        return results;
    }

    // --- VIEW ALL CUSTOMERS (PreparedStatement, no param) ---
    public void viewAllCustomers() {
        String sql = "SELECT CustomerID, Name, Email, Phone FROM Customer LIMIT 100";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            System.out.println("\n--- Customer List ---");
            while (rs.next()) {
                Customer c = new Customer(
                    rs.getInt("CustomerID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("Phone")
                );
                c.displayInfo(); // polymorphism — abstract method called on subclass
            }
        } catch (SQLException e) {
            System.out.println("ViewCustomers error: " + e.getMessage());
        }
    }

    // --- ADD NEW CUSTOMER (PreparedStatement INSERT) ---
    public void addCustomer(String name, String email, String phone, String password) {
    String sql = "INSERT INTO Customer (Name, Email, Phone, Password) VALUES (?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, password);
        int rows = ps.executeUpdate();
        if (rows > 0) {
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                System.out.println("Customer added successfully! Customer ID: " + keys.getInt(1));
            }
        }
    } catch (SQLException e) {
        System.out.println("Add customer failed: " + e.getMessage());
    }
}

// --- ADD NEW RESTAURANT (PreparedStatement INSERT) ---
public void addRestaurant(int ownerID, String name, String address, String phone,
                          String email, String cuisineType, String operatingHours) {
    String sql = "INSERT INTO Restaurant (OwnerID, Name, Address, Phone, Email, CuisineType, OperatingHours) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setInt(1, ownerID);
        ps.setString(2, name);
        ps.setString(3, address);
        ps.setString(4, phone);
        ps.setString(5, email);
        ps.setString(6, cuisineType);
        ps.setString(7, operatingHours);
        int rows = ps.executeUpdate();
        if (rows > 0) {
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                System.out.println("Restaurant added successfully! Restaurant ID: " + keys.getInt(1));
            }
        }
    } catch (SQLException e) {
        System.out.println("Add restaurant failed: " + e.getMessage());
    }
}

// --- VIEW ALL RESTAURANTS ---
public void viewAllRestaurants() {
    String sql = "SELECT RestaurantID, Name, CuisineType, Address, OperatingHours, Rating " +
                 "FROM Restaurant WHERE IsActive = TRUE ORDER BY RestaurantID LIMIT 100";
    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        System.out.println("\n--- Restaurant List ---");
        while (rs.next()) {
            System.out.println("ID: "       + rs.getInt("RestaurantID") +
                               " | Name: "  + rs.getString("Name") +
                               " | Cuisine: "+ rs.getString("CuisineType") +
                               " | Address: "+ rs.getString("Address") +
                               " | Hours: " + rs.getString("OperatingHours") +
                               " | Rating: "+ rs.getDouble("Rating"));
        }
    } catch (SQLException e) {
        System.out.println("ViewRestaurants error: " + e.getMessage());
    }
}

// --- DEACTIVATE RESTAURANT (soft delete via IsActive flag) ---
public void deactivateRestaurant(int restaurantID) {
    String sql = "UPDATE Restaurant SET IsActive = FALSE WHERE RestaurantID = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, restaurantID);
        int rows = ps.executeUpdate();
        if (rows > 0) {
            System.out.println("Restaurant ID " + restaurantID + " deactivated successfully.");
        } else {
            System.out.println("Restaurant not found.");
        }
    } catch (SQLException e) {
        System.out.println("Deactivate restaurant failed: " + e.getMessage());
    }
}
  // --- DELETE CUSTOMER with audit log verification ---
// Trigger 7 blocks if active orders exist
// Trigger 6 logs deleted customer data into CustomerDeletionLog
public void deleteCustomer(int customerID) {
    String deleteSql = "DELETE FROM Customer WHERE CustomerID = ?";
    String logSql    = "SELECT * FROM CustomerDeletionLog WHERE CustomerID = ? ORDER BY DeletedAt DESC LIMIT 1";

    try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
        ps.setInt(1, customerID);
        int rows = ps.executeUpdate();
        if (rows > 0) {
            System.out.println("Customer " + customerID + " deleted successfully.");
            // Show audit log entry created by trigger
            try (PreparedStatement logPs = conn.prepareStatement(logSql)) {
                logPs.setInt(1, customerID);
                ResultSet rs = logPs.executeQuery();
                if (rs.next()) {
                    System.out.println("Audit Log Entry Created:");
                    System.out.println("  CustomerID : " + rs.getInt("CustomerID"));
                    System.out.println("  Name       : " + rs.getString("Name"));
                    System.out.println("  Email      : " + rs.getString("Email"));
                    System.out.println("  DeletedAt  : " + rs.getTimestamp("DeletedAt"));
                }
            }
        } else {
            System.out.println("Customer not found.");
        }
    } catch (SQLException e) {
        System.out.println("Delete failed: " + e.getMessage());
    }
}

    // --- ASSIGN DELIVERY PARTNER via stored procedure ---
    public void assignDeliveryPartner(int orderID) {
        String sql = "{CALL AssignDeliveryPartner(?)}";
        try (CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, orderID);
            cs.execute();
            System.out.println("Delivery partner assigned to Order ID: " + orderID);
        } catch (SQLException e) {
            try { throw new DeliveryException("Failed to assign partner: " + e.getMessage()); }
            catch (DeliveryException de) { de.printDetails(); }
        }
    }
}