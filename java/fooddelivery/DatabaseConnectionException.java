package fooddelivery;

// Unchecked exception (extends RuntimeException) — no try-catch forced on caller
public class DatabaseConnectionException extends RuntimeException {

    private final int errorCode;

    public DatabaseConnectionException(String message, int errorCode) {
        super(message); // passes message up to RuntimeException → Exception → Throwable
        this.errorCode = errorCode;
    }

    // Overloaded — wraps another exception (chained exceptions)
    public DatabaseConnectionException(String message, int errorCode, Throwable cause) {
        super(message, cause); // cause = original exception, accessible via getCause()
        this.errorCode = errorCode;
    }

    public int getErrorCode() { return errorCode; }
}