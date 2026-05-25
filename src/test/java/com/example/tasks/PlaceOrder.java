package com.example.tasks;

import com.example.models.order.post.request.Order;

// Implementación de Task para PlaceOrder usando Screenplay REST.
// Depende de serenity-screenplay-rest (SerenityRest, Post) y serenity-screenplay.

import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Post;

public class PlaceOrder implements Task {

    private final Order order;

    public PlaceOrder(Order order) {
        this.order = order;
    }

    public static PlaceOrder withDetails(Order order) {
        return new PlaceOrder(order);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        // Se asume que serenity.properties contiene base.url
        actor.attemptsTo(
            Post.to("/store/order")
                    .with(
                            request -> request
                                    .header("Content-Type", "application/json")
                                    .body(order))
        );
    }
}
