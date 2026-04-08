package fooddelivery;

// Thrown when order-related operations fail
public class OrderException extends AppException {

    public OrderException(String message) {
        super(message, 1001);
    }

    // Overloaded — with custom error code
    public OrderException(String message, int errorCode) {
        super(message, errorCode);
    }

    @Override
    public String getErrorCodeLabel() {
        return "ORDER_ERROR";
    }
}