package com.example.questions.encounters;

import com.example.models.encounters.response.EncountersResponse;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class EncountersFullResponse implements Question<EncountersResponse> {

    @Override
    public EncountersResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(EncountersResponse.class);
    }

    public static EncountersFullResponse received() {
        return new EncountersFullResponse();
    }
}
