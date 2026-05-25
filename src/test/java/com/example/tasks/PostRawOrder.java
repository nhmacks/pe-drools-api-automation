package com.example.tasks;

import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.rest.interactions.Post;

public class PostRawOrder implements Task {

    private final String body;

    public PostRawOrder(String body) {
        this.body = body;
    }

    public static PostRawOrder withBody(String body) {
        return new PostRawOrder(body);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
            Post.to("/store/order").with(request ->
                request.header("Content-Type", "application/json").body(this.body)
            )
        );
    }
}
