package com.example.tasks;

import io.restassured.http.ContentType;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Post;

import static net.serenitybdd.screenplay.Tasks.instrumented;

public class GetEncounterDebugDetail implements Task {

    private final String visitOccurrenceId;
    private final String authToken;
    private final String awsXAuthToken;
    private final String awsXSource;
    private final String key;

    public GetEncounterDebugDetail(String visitOccurrenceId, String authToken, String awsXAuthToken, String awsXSource, String key) {
        this.visitOccurrenceId = visitOccurrenceId;
        this.authToken = authToken;
        this.awsXAuthToken = awsXAuthToken;
        this.awsXSource = awsXSource;
        this.key = key;
    }

    public static GetEncounterDebugDetail withId(String visitOccurrenceId, String authToken, String awsXAuthToken, String awsXSource, String key) {
        return instrumented(GetEncounterDebugDetail.class, visitOccurrenceId, authToken, awsXAuthToken, awsXSource, key);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        String requestBody = "{\"key\":\"" + key + "\"}";

        actor.attemptsTo(
            Post.to("/api/v3/debug/detail/" + visitOccurrenceId)
                .with(request -> request
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + authToken)
                    .header("aws-x-authorization", awsXAuthToken)
                    .header("aws-x-source", awsXSource)
                    .body(requestBody)
                    .contentType(ContentType.JSON))
        );
    }
}