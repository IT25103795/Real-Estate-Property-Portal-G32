package com.realestate.portal.model;

public class Property {
    private String id;
    private String title;
    private double price;
    private String location;
    private String type;
    private String status;
    private String sellerName;

    public Property(String id, String title, double price, String location, String type, String status, String sellerName) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.location = location;
        this.type = type;
        this.status = status;
        this.sellerName = sellerName;
    }

    // Getters so your index.jsp can read these values
    public String getId() { return id; }
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public String getLocation() { return location; }
    public String getType() { return type; }
    public String getStatus() { return status; }
    public String getSellerName() { return sellerName; }
}