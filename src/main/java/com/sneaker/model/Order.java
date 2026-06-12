package com.sneaker.model;

import java.sql.Timestamp;

public class Order {

    private int id;
    private int userId;
    private int sneakerId;
    private int quantity;
    private double total;
    private String status;
    private Timestamp orderDate;

    // Extra fields joined from related tables (not stored in orders table)
    private String username;
    private String sneakerBrand;
    private String sneakerModel;

    public Order() {}

    public Order(int id, int userId, int sneakerId, int quantity,
                 double total, String status, Timestamp orderDate) {
        this.id         = id;
        this.userId     = userId;
        this.sneakerId  = sneakerId;
        this.quantity   = quantity;
        this.total      = total;
        this.status     = status;
        this.orderDate  = orderDate;
    }

    public int getId()                       { return id; }
    public void setId(int id)                { this.id = id; }

    public int getUserId()                   { return userId; }
    public void setUserId(int userId)        { this.userId = userId; }

    public int getSneakerId()                { return sneakerId; }
    public void setSneakerId(int sneakerId)  { this.sneakerId = sneakerId; }

    public int getQuantity()                 { return quantity; }
    public void setQuantity(int quantity)    { this.quantity = quantity; }

    public double getTotal()                 { return total; }
    public void setTotal(double total)       { this.total = total; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public Timestamp getOrderDate()                  { return orderDate; }
    public void setOrderDate(Timestamp orderDate)    { this.orderDate = orderDate; }

    public String getUsername()                      { return username; }
    public void setUsername(String username)         { this.username = username; }

    public String getSneakerBrand()                  { return sneakerBrand; }
    public void setSneakerBrand(String sneakerBrand) { this.sneakerBrand = sneakerBrand; }

    public String getSneakerModel()                  { return sneakerModel; }
    public void setSneakerModel(String sneakerModel) { this.sneakerModel = sneakerModel; }
}
