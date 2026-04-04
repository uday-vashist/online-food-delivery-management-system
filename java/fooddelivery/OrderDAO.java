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
            System.out.println("PlaceOrder error: " + e.getMessage());
        }
    }

    // --- VIEW ORDERS BY CUSTOMER (PreparedStatement) ---
    @Override
    public void viewOrdersByCustomer(int customerID) {
        String sql = "SELECT O.OrderID, R.Name AS Restaurant, O.Status, O.FinalAmount " +
                     "FROM Orders O JOIN Restaurant R ON O.RestaurantID = R.RestaurantID " +
                     "WHERE O.CustomerID = ? ORDER BY O.OrderDate DESC";
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
                                   " | Amount: ₹" + order.getFinalAmount());
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
        String sql = "SELECT CustomerID, Name, Email, Phone FROM Customer LIMIT 20";
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

    // --- ASSIGN DELIVERY PARTNER via stored procedure ---
    public void assignDeliveryPartner(int orderID) {
        String sql = "{CALL AssignDeliveryPartner(?)}";
        try (CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, orderID);
            cs.execute();
            System.out.println("Delivery partner assigned to Order ID: " + orderID);
        } catch (SQLException e) {
            System.out.println("AssignPartner error: " + e.getMessage());
        }
    }
}