package fooddelivery;

// RestaurantOrder extends Entity — another child of the same abstract parent
// Combined with Customer extending Entity, this shows hierarchical inheritance
public class RestaurantOrder extends Entity {

    private int    customerID;
    private int    restaurantID;
    private double finalAmount;
    private String status;

    public RestaurantOrder(int orderId, int customerID, int restaurantID, double finalAmount, String status) {
        super(orderId, "Order#" + orderId); // super sets id and name in Entity
        this.customerID   = customerID;
        this.restaurantID = restaurantID;
        this.finalAmount  = finalAmount;
        this.status       = status;
    }

    // Overloaded — minimal constructor for new orders
    public RestaurantOrder(int customerID, int restaurantID) {
        super(); // calls Entity default constructor → chains to Entity(0, "Unknown")
        this.customerID   = customerID;
        this.restaurantID = restaurantID;
        this.finalAmount  = 0.0;
        this.status       = "Pending";
    }

    public int    getCustomerID()   { return customerID;   }
    public int    getRestaurantID() { return restaurantID; }
    public double getFinalAmount()  { return finalAmount;  }
    public String getStatus()       { return status;       }

    @Override
    public void displayInfo() {
        System.out.println("Order [ID: " + getId() +
                           ", CustomerID: " + customerID +
                           ", RestaurantID: " + restaurantID +
                           ", Amount: ₹" + finalAmount +
                           ", Status: " + status + "]");
    }
}