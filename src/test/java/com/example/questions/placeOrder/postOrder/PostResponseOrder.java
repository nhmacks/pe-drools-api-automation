package com.example.questions.placeOrder.postOrder;

import com.example.models.order.ResponseOrder;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class PostResponseOrder implements Question<ResponseOrder> {
    @Override
    public ResponseOrder answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ResponseOrder.class);
    }
}
