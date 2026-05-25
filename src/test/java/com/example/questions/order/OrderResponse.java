package com.example.questions.order;

import com.example.models.order.ResponseOrder;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract OrderResponse from POST /store/order response.
 */
public class OrderResponse implements Question<ResponseOrder> {
    @Override
    public ResponseOrder answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ResponseOrder.class);
    }
}
