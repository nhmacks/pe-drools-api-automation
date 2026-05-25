package com.example.models.auth.register.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Response model for user registration success.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class RegisterUserResponse {

    @JsonProperty("id")
    private String id;

    @JsonProperty("email")
    private String email;

    @JsonProperty("firstName")
    private String firstName;

    @JsonProperty("lastName")
    private String lastName;

    @JsonProperty("phone")
    private String phone;

    @JsonProperty("emailVerified")
    private Boolean emailVerified;

    @JsonProperty("isActive")
    private Boolean isActive;

    @JsonProperty("roles")
    private List<String> roles;

    @JsonProperty("createdAt")
    private String createdAt;

    public RegisterUserResponse() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Boolean getEmailVerified() { return emailVerified; }
    public void setEmailVerified(Boolean emailVerified) { this.emailVerified = emailVerified; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public List<String> getRoles() { return roles; }
    public void setRoles(List<String> roles) { this.roles = roles; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "RegisterUserResponse{" +
                "id='" + id + '\'' +
                ", email='" + email + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", phone='" + phone + '\'' +
                ", emailVerified=" + emailVerified +
                ", isActive=" + isActive +
                ", roles=" + roles +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}
