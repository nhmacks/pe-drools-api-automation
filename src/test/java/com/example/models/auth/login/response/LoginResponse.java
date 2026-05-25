package com.example.models.auth.login.response;

import com.fasterxml.jackson.annotation.JsonProperty;

public class LoginResponse {
    @JsonProperty("accessToken")
    private String accessToken;

    @JsonProperty("refreshToken")
    private String refreshToken;

    @JsonProperty("tokenType")
    private String tokenType;

    @JsonProperty("expiresIn")
    private Integer expiresIn;

    public LoginResponse() {
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public Integer getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(Integer expiresIn) {
        this.expiresIn = expiresIn;
    }
}
