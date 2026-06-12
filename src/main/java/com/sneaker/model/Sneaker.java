package com.sneaker.model;

public class Sneaker {

    private int id;
    private String brand;
    private String model;
    private double size;
    private String color;
    private double price;
    private int stock;
    private String imageUrl;
    private String category; // men | women | kids | unisex

    public Sneaker() {}

    public Sneaker(int id, String brand, String model,
                   double size, String color, double price,
                   int stock, String imageUrl, String category) {
        this.id       = id;
        this.brand    = brand;
        this.model    = model;
        this.size     = size;
        this.color    = color;
        this.price    = price;
        this.stock    = stock;
        this.imageUrl = imageUrl;
        this.category = category;
    }

    public int getId()                       { return id; }
    public void setId(int id)                { this.id = id; }

    public String getBrand()                 { return brand; }
    public void setBrand(String brand)       { this.brand = brand; }

    public String getModel()                 { return model; }
    public void setModel(String model)       { this.model = model; }

    public double getSize()                  { return size; }
    public void setSize(double size)         { this.size = size; }

    public String getColor()                 { return color; }
    public void setColor(String color)       { this.color = color; }

    public double getPrice()                 { return price; }
    public void setPrice(double price)       { this.price = price; }

    public int getStock()                    { return stock; }
    public void setStock(int stock)          { this.stock = stock; }

    public String getImageUrl()              { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategory()              { return category; }
    public void setCategory(String category) { this.category = category; }
}
