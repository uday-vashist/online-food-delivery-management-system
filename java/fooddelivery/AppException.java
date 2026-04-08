package fooddelivery;

// Abstract checked exception — base for all app-level exceptions
public abstract class AppException extends Exception {

    private final int errorCode;

    public AppException(String message, int errorCode) {
        super(message); // message accessible via getMessage() anywhere up the chain
        this.errorCode = errorCode;
    }

    // Every subclass must define its own error code label
    public abstract String getErrorCodeLabel();

    public int getErrorCode() { return errorCode; }

    // Prints full exception info — useful during demo
    public void printDetails() {
        System.out.println("[" + getErrorCodeLabel() + " - " + errorCode + "] " + getMessage());
        printStackTrace(); // shows full call stack
    }
}