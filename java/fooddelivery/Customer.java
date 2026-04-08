package fooddelivery;

public class Customer extends Entity {

    private String email;
    private String phone;

    // Constructor calls parent constructor via super
    public Customer(int id, String name, String email, String phone) {
        super(id, name); // calls Entity(int, String)
        this.email = email;
        this.phone = phone;
    }

    // Overloaded constructor — only name and email
    public Customer(String name, String email) {
        super(0, name);
        this.email = email;
        this.phone = "N/A";
    }

    public String getEmail() { return email; }
    public String getPhone() { return phone; }

    @Override
    public void displayInfo() {
        System.out.println("Customer [ID: " + getId() + 
                           ", Name: " + getName() + 
                           ", Email: " + email + 
                           ", Phone: " + phone + "]");
    }
}