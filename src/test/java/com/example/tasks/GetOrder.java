package com.example.tasks;

import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.rest.interactions.Get;

public class GetOrder implements Task {

    private final String id;

    public GetOrder(String id) {
        this.id = id;
    }

    public static GetOrder withIdAndAccept(String id) {
        return new GetOrder(id);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
            Get.resource("/store/order/{id}")
                .with(request -> request
                        .header("Accept", "application/json")
                        .pathParam("id", id))
        );
    }
}

