package fooddelivery;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        OrderDAO dao     = new OrderDAO();
        Scanner  scanner = new Scanner(System.in);
        int      choice  = -1;

        System.out.println("=== Online Food Delivery Management System ===");

        while (choice != 0) {
            System.out.println("1. View All Customers");
            System.out.println("2. Add New Customer");
            System.out.println("3. View Orders by Customer");
            System.out.println("4. Place New Order");
            System.out.println("5. Update Order Status");
            System.out.println("6. Add New Restaurant");
            System.out.println("7. View All Restaurants");     // NEW
            System.out.println("8. Assign Delivery Partner");
            System.out.println("9. Top 5 Restaurants by Revenue");
            System.out.println("10. Process Payment");
            System.out.println("11. Delete Customer");
            System.out.println("12. Deactivate Restaurant");
            System.out.println("13. Check for Discounts");
            System.out.println("0. Exit");
            try {
                 choice = Integer.parseInt(scanner.nextLine().trim());
                } catch (NumberFormatException e) {
                        choice = -1; // triggers default: Invalid choice
             }

            switch (choice) {
    case 1:
        dao.viewAllCustomers();
        break;

    case 2:
        System.out.print("Name: ");      String newName  = scanner.nextLine().trim();
        System.out.print("Email: ");     String newEmail = scanner.nextLine().trim();
        System.out.print("Phone: ");     String newPhone = scanner.nextLine().trim();
        System.out.print("Password: ");  String newPass  = scanner.nextLine().trim();
        dao.addCustomer(newName, newEmail, newPhone, newPass);
        break;

    case 3:
        System.out.print("Enter Customer ID: ");
        int cid = Integer.parseInt(scanner.nextLine().trim());
        dao.viewOrdersByCustomer(cid);
        break;

    case 4:
        System.out.print("Customer ID: ");     int custID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Restaurant ID: ");   int restID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Address ID: ");      int addrID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Delivery Charge: "); double charge = Double.parseDouble(scanner.nextLine().trim());
        dao.placeOrder(custID, restID, addrID, charge);
        break;

    case 5:
        System.out.print("Order ID: ");
        int oid = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("New Status (Confirmed/Preparing/OutForDelivery/Delivered/Cancelled): ");
        String status = scanner.nextLine().trim();
        dao.updateOrderStatus(oid, status);
        break;

    case 6:
        System.out.print("Owner ID: ");        int ownerID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Name: ");            String rName    = scanner.nextLine().trim();
        System.out.print("Address: ");         String rAddress = scanner.nextLine().trim();
        System.out.print("Phone: ");           String rPhone   = scanner.nextLine().trim();
        System.out.print("Email: ");           String rEmail   = scanner.nextLine().trim();
        System.out.print("Cuisine Type: ");    String cuisine  = scanner.nextLine().trim();
        System.out.print("Operating Hours: "); String hours    = scanner.nextLine().trim();
        dao.addRestaurant(ownerID, rName, rAddress, rPhone, rEmail, cuisine, hours);
        break;

    case 7:
        dao.viewAllRestaurants();
        break;

    case 8:
        System.out.print("Order ID to assign partner: ");
        int assignID = Integer.parseInt(scanner.nextLine().trim());
        dao.assignDeliveryPartner(assignID);
        break;

    case 9:
        dao.getTopRestaurants();
        break;

    case 10:
        System.out.print("Order ID: ");
        int payOrderID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Payment Method (Cash/Card/UPI/Wallet): ");
        String method = scanner.nextLine().trim();
        System.out.print("Transaction ID: ");
        String txnID = scanner.nextLine().trim();
        dao.processPayment(payOrderID, method, txnID);
        break;

    case 11:
        System.out.print("Customer ID to delete: ");
        int delID = Integer.parseInt(scanner.nextLine().trim());
        dao.deleteCustomer(delID);
        break;

    case 12:
        System.out.print("Restaurant ID to deactivate: ");
        int restDelID = Integer.parseInt(scanner.nextLine().trim());
        dao.deactivateRestaurant(restDelID);
        break;

    case 13:
        System.out.print("Customer ID: ");
        int loyalCustID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Restaurant ID: ");
        int loyalRestID = Integer.parseInt(scanner.nextLine().trim());
        System.out.print("Order ID to apply discount on: ");
        int loyalOrderID = Integer.parseInt(scanner.nextLine().trim());
        dao.applyLoyaltyDiscount(loyalCustID, loyalRestID, loyalOrderID);
        break;

    case 0:
        System.out.println("Exiting. Goodbye!");
        DBConnection.closeConnection();
        break;

    default:
        System.out.println("Invalid choice.");
}
        }
        scanner.close();
    }
}