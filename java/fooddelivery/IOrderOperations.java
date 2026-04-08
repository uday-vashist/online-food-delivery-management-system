package fooddelivery;

import java.util.List;

// Interface: defines contract that any DAO class must fulfill
public interface IOrderOperations {
    void         placeOrder(int customerID, int restaurantID, int addressID, double deliveryCharge);
    void         viewOrdersByCustomer(int customerID);
    void         updateOrderStatus(int orderID, String newStatus);
    List<String> getTopRestaurants();
}