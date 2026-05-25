package com.example.questions.placeOrder.getorder;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class GetResponseContentType {
    public static Question<String> value() {
        return new Question<String>() {
            @Override
            public String answeredBy(Actor actor) {
                return SerenityRest.lastResponse().getHeader("Content-Type");
            }

            @Override
            public String getSubject() {
                return "Content-Type header from last response";
            }
        };
    }
}

