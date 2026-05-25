package com.example.questions.placeOrder.postOrder;

import com.example.models.error.ErrorResponse;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class PostErrorResponse implements Question<ErrorResponse> {
    @Override
    public ErrorResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ErrorResponse.class);
    }
}

