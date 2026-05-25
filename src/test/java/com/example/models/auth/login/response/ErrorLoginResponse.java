package com.example.models.auth.login.response;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ErrorLoginResponse {
    @JsonProperty("error")
    private String error;

    @JsonProperty("message")
    private String message;

    @JsonProperty("status")
    private Integer status;

    @JsonProperty("timestamp")
    private Long timestamp;

    public ErrorLoginResponse() {
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }
}
