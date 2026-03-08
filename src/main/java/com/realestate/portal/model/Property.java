package com.realestate.portal.model;

public class Property {
    private String id;
    private String title;
    private double price;
    private String location;
    private String type;
    private String status;
    private String sellerName;
    private String imageUrl; // <-- THE 8TH ITEM!

    // Upgraded Constructor to accept all 8 pieces of data
    public Property(String id, String title, double price, String location, String type, String status, String sellerName, String imageUrl) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.location = location;
        this.type = type;
        this.status = status;
        this.sellerName = sellerName;
        this.imageUrl = imageUrl;
    }

    // Getters for the JSP to read the data
    public String getImageUrl() { return imageUrl; }
    public String getId() { return id; }
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public String getLocation() { return location; }
    public String getType() { return type; }
    public String getStatus() { return status; }
    public String getSellerName() { return sellerName; }
}