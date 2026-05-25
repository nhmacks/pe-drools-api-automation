package com.example.tasks;

import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.rest.interactions.Delete;

public class DeleteOrder implements Task {

    private final String id;

    public DeleteOrder(String id) {
        this.id = id;
    }

    public static DeleteOrder withIdAndAccept(String id) {
        return new DeleteOrder(id);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
            Delete.from("/store/order/{id}")
                .with(request -> request.header("Accept", "application/json").pathParam("id", id))
        );
    }
}

