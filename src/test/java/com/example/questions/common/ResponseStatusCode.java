package com.example.questions.common;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract HTTP status code from the last response.
 */
public class ResponseStatusCode {

    public static Question<Integer> status() {
        return new Question<>() {
            @Override
            public Integer answeredBy(Actor actor) {
                return SerenityRest.lastResponse().statusCode();
            }

            @Override
            public String getSubject() {
                return "HTTP status code from last response";
            }
        };
    }
}
