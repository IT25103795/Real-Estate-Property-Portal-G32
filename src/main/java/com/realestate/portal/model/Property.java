package com.realestate.portal.model;

public class Property {
    private String id;
    private String title;
    private double price;
    private String type;
    private String location;

    public Property(String id, String title, double price, String type, String location) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.type = type;
        this.location = location;
    }

    // Getters for the UI to access the data
    public String getId() { return id; }
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public String getType() { return type; }
    public String getLocation() { return location; }
}