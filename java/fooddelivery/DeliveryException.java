package fooddelivery;

// Thrown when delivery partner assignment or delivery fails
public class DeliveryException extends AppException {

    public DeliveryException(String message) {
        super(message, 3001);
    }

    @Override
    public String getErrorCodeLabel() {
        return "DELIVERY_ERROR";
    }
}