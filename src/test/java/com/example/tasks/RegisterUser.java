package com.example.tasks;

import com.example.models.auth.register.request.RegisterUserRequest;

import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Delete;
import net.serenitybdd.screenplay.rest.interactions.Get;
import net.serenitybdd.screenplay.rest.interactions.Patch;
import net.serenitybdd.screenplay.rest.interactions.Post;
import net.serenitybdd.screenplay.rest.interactions.Put;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Screenplay Task to register a new user via POST /api/auth/register endpoint.
 */
public class RegisterUser implements Task {

    private final RegisterUserRequest userRequest;
    private final String customContentType;
    private final boolean removeContentType;
    private final String malformedJson;
    private final String httpMethod;

    private RegisterUser(RegisterUserRequest userRequest, String customContentType, boolean removeContentType, String malformedJson, String httpMethod) {
        this.userRequest = userRequest;
        this.customContentType = customContentType;
        this.removeContentType = removeContentType;
        this.malformedJson = malformedJson;
        this.httpMethod = httpMethod;
    }

    public static RegisterUser withDetails(RegisterUserRequest userRequest) {
        return new RegisterUser(userRequest, null, false, null, null);
    }

    // Si contentType es null => queremos remover el header Content-Type
    // Si contentType no es null => lo tratamos como contentType personalizado
    public static RegisterUser withDetailsAndCustomHeaders(RegisterUserRequest userRequest, String contentType) {
        if (contentType == null) {
            return new RegisterUser(userRequest, null, true, null, null);
        } else {
            return new RegisterUser(userRequest, contentType, false, null, null);
        }
    }

    public static RegisterUser withDetailsAndContentType(RegisterUserRequest userRequest, String contentType) {
        return new RegisterUser(userRequest, contentType, false, null, null);
    }

    public static RegisterUser withMalformedJson() {
        return new RegisterUser(null, null, false, "{invalid json: missing bracket", null);
    }

    public static RegisterUser withHttpMethod(String method) {
        return new RegisterUser(null, null, false, null, method);
    }

    private String toJson(Object obj) {
        if (obj == null) return "{}";
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize request to JSON", e);
        }
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        String endpoint = "/api/auth/register";

        // Caso: Malformed JSON
        if (malformedJson != null) {
            actor.attemptsTo(
                    Post.to(endpoint)
                            .with(request -> request
                                    .header("Content-Type", "application/json")
                                    .body(malformedJson)));
            return;
        }

        // Caso: HTTP method diferente a POST
        if (httpMethod != null) {
            switch (httpMethod.toUpperCase()) {
                case "GET":
                    actor.attemptsTo(Get.resource(endpoint));
                    break;
                case "PUT":
                    actor.attemptsTo(
                            Put.to(endpoint)
                                    .with(request -> request
                                            .header("Content-Type", "application/json")
                                            .body(userRequest != null ? toJson(userRequest) : "{}")));
                    break;
                case "DELETE":
                    actor.attemptsTo(Delete.from(endpoint));
                    break;
                case "PATCH":
                    actor.attemptsTo(
                            Patch.to(endpoint)
                                    .with(request -> request
                                            .header("Content-Type", "application/json")
                                            .body(userRequest != null ? toJson(userRequest) : "{}")));
                    break;
                default:
                    throw new IllegalArgumentException("Unsupported HTTP method: " + httpMethod);
            }
            return;
        }

        // Caso: Sin Content-Type header
        if (removeContentType) {
            actor.attemptsTo(
                    Post.to(endpoint)
                            .with(request -> request.body(toJson(userRequest))));
            return;
        }

        // Caso: Content-Type personalizado
        if (customContentType != null) {
            actor.attemptsTo(
                    Post.to(endpoint)
                            .with(request -> request
                                    .header("Content-Type", customContentType)
                                    .body(toJson(userRequest))));
            return;
        }

        // Caso estándar: POST con application/json
        actor.attemptsTo(
                Post.to(endpoint)
                        .with(request -> request
                                .header("Content-Type", "application/json")
                                .body(toJson(userRequest))));
    }
}
