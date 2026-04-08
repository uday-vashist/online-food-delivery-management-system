package fooddelivery;

// Thrown when payment processing fails
public class PaymentException extends AppException {

    private final String transactionID;

    public PaymentException(String message, String transactionID) {
        super(message, 2001);
        this.transactionID = transactionID;
    }

    public String getTransactionID() { return transactionID; }

    @Override
    public String getErrorCodeLabel() {
        return "PAYMENT_ERROR";
    }
}