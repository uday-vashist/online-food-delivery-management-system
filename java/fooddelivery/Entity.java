package fooddelivery;

// abstract: cannot be instantiated directly, must be subclassed
public abstract class Entity {

    private int id;
    private String name;

    // Constructor using 'this' to distinguish parameter from field
    public Entity(int id, String name) {
        this.id   = id;
        this.name = name;
    }

    // Default constructor — constructor overloading
    public Entity() {
        this(0, "Unknown"); // constructor chaining with 'this'
    }

    public int    getId()   { return id;   }
    public String getName() { return name; }

    public void setId(int id)       { this.id   = id;   }
    public void setName(String name){ this.name  = name; }

    // abstract method — every subclass MUST implement this
    public abstract void displayInfo();
}