package com.example.questions.encounters;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract specific fields from the encounters response using JSON Path.
 */
public class EncountersResponseField {

    public static Question<Object> value(String jsonPath) {
        return new Question<>() {
            @Override
            public Object answeredBy(Actor actor) {
                return SerenityRest.lastResponse().jsonPath().get(jsonPath);
            }

            @Override
            public String getSubject() {
                return "value of json path: " + jsonPath;
            }
        };
    }

    public static Question<String> asString(String jsonPath) {
        return new Question<>() {
            @Override
            public String answeredBy(Actor actor) {
                return SerenityRest.lastResponse().jsonPath().getString(jsonPath);
            }

            @Override
            public String getSubject() {
                return "string value of json path: " + jsonPath;
            }
        };
    }

    public static Question<Integer> asInt(String jsonPath) {
        return new Question<>() {
            @Override
            public Integer answeredBy(Actor actor) {
                return SerenityRest.lastResponse().jsonPath().getInt(jsonPath);
            }

            @Override
            public String getSubject() {
                return "integer value of json path: " + jsonPath;
            }
        };
    }

    public static Question<Double> asDouble(String jsonPath) {
        return new Question<>() {
            @Override
            public Double answeredBy(Actor actor) {
                return SerenityRest.lastResponse().jsonPath().getDouble(jsonPath);
            }

            @Override
            public String getSubject() {
                return "double value of json path: " + jsonPath;
            }
        };
    }
}
