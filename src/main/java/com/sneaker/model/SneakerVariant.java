package com.sneaker.model;

public class SneakerVariant {
    private int    id;
    private int    sneakerId;
    private String color;
    private String imageUrl;

    public SneakerVariant() {}

    public SneakerVariant(int sneakerId, String color, String imageUrl) {
        this.sneakerId = sneakerId;
        this.color     = color;
        this.imageUrl  = imageUrl;
    }

    public int    getId()        { return id; }
    public void   setId(int id)  { this.id = id; }

    public int    getSneakerId()              { return sneakerId; }
    public void   setSneakerId(int sneakerId) { this.sneakerId = sneakerId; }

    public String getColor()             { return color; }
    public void   setColor(String color) { this.color = color; }

    public String getImageUrl()                { return imageUrl; }
    public void   setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
