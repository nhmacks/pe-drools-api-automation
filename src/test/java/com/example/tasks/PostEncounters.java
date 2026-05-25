package com.example.tasks;

import com.example.models.encounters.request.EncountersRequest;
import com.example.utils.ApiConfig;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Post;

public class PostEncounters implements Task {

    private final EncountersRequest encountersRequest;
    private String authToken;

    public PostEncounters(EncountersRequest encountersRequest) {
        this.encountersRequest = encountersRequest;
    }

    public static PostEncounters withDetails(EncountersRequest encountersRequest) {
        return new PostEncounters(encountersRequest);
    }

    public PostEncounters withAuthToken(String token) {
        this.authToken = token;
        return this;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        String token = authToken != null ? authToken : ApiConfig.encountersAuthToken();

        actor.attemptsTo(
                Post.to("/qas/api/encounters/services/documents")
                        .with(request -> request
                                .header("Content-Type", "application/json")
                                .header("Authorization", "Bearer " + token)
                                .body(encountersRequest))
        );
    }
}
