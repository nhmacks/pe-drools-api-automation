package com.example.questions.placeOrder.getorder;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.Actor;

public class GetResponseField {

    public static Question<Object> value(String jsonPath) {
        return new Question<Object>() {
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
}
