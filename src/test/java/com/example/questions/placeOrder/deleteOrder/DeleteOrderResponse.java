package com.example.questions.placeOrder.deleteOrder;

import com.example.models.order.ResponseOrder;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class DeleteOrderResponse implements Question<ResponseOrder> {
    @Override
    public ResponseOrder answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ResponseOrder.class);
    }
}
