package com.example.models.auth.register.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Error response model for registration failures.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class RegisterErrorResponse {

    @JsonProperty("error")
    private String error;

    @JsonProperty("message")
    private String message;

    @JsonProperty("statusCode")
    private Integer statusCode;

    @JsonProperty("timestamp")
    private String timestamp;

    public RegisterErrorResponse() {}

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Integer getStatusCode() { return statusCode; }
    public void setStatusCode(Integer statusCode) { this.statusCode = statusCode; }

    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }

    @Override
    public String toString() {
        return "RegisterErrorResponse{" +
                "error='" + error + '\'' +
                ", message='" + message + '\'' +
                ", statusCode=" + statusCode +
                ", timestamp='" + timestamp + '\'' +
                '}';
    }
}
