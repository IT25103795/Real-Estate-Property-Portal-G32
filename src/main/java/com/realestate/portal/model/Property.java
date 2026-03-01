package com.realestate.portal.model;

import java.io.Serializable;

public class Property implements Serializable {
    private String id;
    private String title;
    private double price;
    private String type;
    private String location;


    public Property() {
    }


    public Property(String id, String title, double price, String type, String location) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.type = type;
        this.location = location;
    }


    public String getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public double getPrice() {
        return price;
    }

    public String getType() {
        return type;
    }

    public String getLocation() {
        return location;
    }


    public void setId(String id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}