package com.example.questions.placeOrder.getorder;

import com.example.models.order.get.response.ErrorResponseOrder;
import com.example.models.order.get.response.ResponseOrder;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class GetErrorResponse implements Question<ErrorResponseOrder> {
    @Override
    public ErrorResponseOrder answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ErrorResponseOrder.class);
    }
}
