package fooddelivery;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        OrderDAO dao     = new OrderDAO();
        Scanner  scanner = new Scanner(System.in);
        int      choice  = -1;

        System.out.println("=== Online Food Delivery Management System ===");

        while (choice != 0) {
            System.out.println("\n1. View All Customers");
            System.out.println("2. View Orders by Customer");
            System.out.println("3. Place New Order");
            System.out.println("4. Update Order Status");
            System.out.println("5. Assign Delivery Partner");
            System.out.println("6. Top 5 Restaurants by Revenue");
            System.out.println("0. Exit");
            System.out.print("Enter choice: ");

            choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    dao.viewAllCustomers();
                    break;

                case 2:
                    System.out.print("Enter Customer ID: ");
                    int cid = scanner.nextInt();
                    dao.viewOrdersByCustomer(cid);
                    break;

                case 3:
                    System.out.print("Customer ID: ");    int custID  = scanner.nextInt();
                    System.out.print("Restaurant ID: ");  int restID  = scanner.nextInt();
                    System.out.print("Address ID: ");     int addrID  = scanner.nextInt();
                    System.out.print("Delivery Charge: ");double charge = scanner.nextDouble();
                    dao.placeOrder(custID, restID, addrID, charge);
                    break;

                case 4:
                    System.out.print("Order ID: ");      int oid    = scanner.nextInt();
                    System.out.print("New Status (Confirmed/Preparing/OutForDelivery/Delivered/Cancelled): ");
                    String status = scanner.next();
                    dao.updateOrderStatus(oid, status);
                    break;

                case 5:
                    System.out.print("Order ID to assign partner: ");
                    int assignID = scanner.nextInt();
                    dao.assignDeliveryPartner(assignID);
                    break;

                case 6:
                    dao.getTopRestaurants();
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