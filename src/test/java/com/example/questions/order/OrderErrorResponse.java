package com.example.questions.order;

import com.example.models.error.ErrorResponse;
import com.example.models.order.get.response.ErrorResponseOrder;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract error response from order endpoint.
 */
public class OrderErrorResponse implements Question<ErrorResponse> {
    @Override
    public ErrorResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(ErrorResponse.class);
    }

    /**
     * Helper method to extract error response as ErrorResponseOrder (for backward compatibility).
     */
    public Question<ErrorResponseOrder> asErrorResponseOrder() {
        return new Question<ErrorResponseOrder>() {
            @Override
            public ErrorResponseOrder answeredBy(Actor actor) {
                return SerenityRest.lastResponse().body().as(ErrorResponseOrder.class);
            }

            @Override
            public String getSubject() {
                return "Error response order from last response";
            }
        };
    }
}
