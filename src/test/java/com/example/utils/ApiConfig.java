// java
package com.example.utils;


import net.serenitybdd.model.environment.EnvironmentSpecificConfiguration;
import net.thucydides.model.environment.SystemEnvironmentVariables;
import net.thucydides.model.util.EnvironmentVariables;

public final class ApiConfig {

    private static final EnvironmentVariables ENV = SystemEnvironmentVariables.createEnvironmentVariables();

    private ApiConfig() { }

    public static String baseUrl() {
        String fromSystemProperty = System.getProperty("base.url");
        if (fromSystemProperty != null && !fromSystemProperty.isBlank()) {
            return fromSystemProperty;
        }

        String fromEnv = System.getenv("BASE_URL");
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv;
        }

        String fromSerenity = EnvironmentSpecificConfiguration.from(ENV).getProperty("base.url");
        if (fromSerenity != null && !fromSerenity.isBlank()) {
            return fromSerenity;
        }

        return "http://localhost:8101";
    }

    public static String encountersBaseUrl() {
        String fromSystemProperty = System.getProperty("encounters.base.url");
        if (fromSystemProperty != null && !fromSystemProperty.isBlank()) {
            return fromSystemProperty;
        }

        String fromEnv = System.getenv("ENCOUNTERS_BASE_URL");
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv;
        }

        try {
            String fromSerenity = EnvironmentSpecificConfiguration.from(ENV).getProperty("encounters.base.url");
            if (fromSerenity != null && !fromSerenity.isBlank()) {
                return fromSerenity;
            }
        } catch (Exception ignored) {
        }

        return "https://4edbbovqhg.execute-api.us-east-1.amazonaws.com";
    }

    public static String encountersAuthToken() {
        String fromSystemProperty = System.getProperty("encounters.auth.token");
        if (fromSystemProperty != null && !fromSystemProperty.isBlank()) {
            return fromSystemProperty;
        }

        String fromEnv = System.getenv("ENCOUNTERS_AUTH_TOKEN");
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv;
        }

        try {
            String fromSerenity = EnvironmentSpecificConfiguration.from(ENV).getProperty("encounters.auth.token");
            if (fromSerenity != null && !fromSerenity.isBlank()) {
                return fromSerenity;
            }
        } catch (Exception ignored) {
        }

        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZF9jbGllbnRlIjoiOWFmZWU3NjAtZDM0Ny00ZTJlLTlhM2ItMDg1MjM4NGIxOTM1IiwicGF0aCI6Ii9xYXMvYXBpL2VuY291bnRlcnMvc2VydmljZXMvZG9jdW1lbnRzIiwiZmVjaGFfZ3JhYmFkbyI6IjIwMjYtMDQtMDIgMDc6MDQ6NDMifQ.4hAVB190GWEwRcqyecHgLPcGgPmkH94i4al2HZgYYj4";
    }
}
