package com.example.models.order.post.request;

public class Order {
    private String id;
    private String petId;
    private String quantity;
    private String shipDate;
    private String status;
    private boolean complete;

    public Order() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPetId() { return petId; }
    public void setPetId(String petId) { this.petId = petId; }

    public String getQuantity() { return quantity; }
    public void setQuantity(String quantity) { this.quantity = quantity; }

    public String getShipDate() { return shipDate; }
    public void setShipDate(String shipDate) { this.shipDate = shipDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isComplete() { return complete; }
    public void setComplete(boolean complete) { this.complete = complete; }
}

