package com.example.questions.encounters;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

import java.util.Map;

public class EncounterDebugDetailResponse implements Question<Map<String, Object>> {

    public static EncounterDebugDetailResponse received() {
        return new EncounterDebugDetailResponse();
    }

    @Override
    public Map<String, Object> answeredBy(Actor actor) {
        return SerenityRest.lastResponse().as(Map.class);
    }
}