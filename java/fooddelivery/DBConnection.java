package fooddelivery;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// final: cannot be subclassed — connection logic must not be overridden
public final class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/food_delivery";
    private static final String USER     = "root";
    private static final String PASSWORD = "NewPassword123"; // change this

    private static Connection connection = null;

    // private constructor — nobody instantiates this directly
    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Database connected successfully.");
            } catch (ClassNotFoundException e) {
                throw new SQLException("MySQL Driver not found: " + e.getMessage());
            }
        }
        return connection;
    }

    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Connection closed.");
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}