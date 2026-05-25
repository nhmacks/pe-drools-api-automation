package com.example.questions.auth;

import com.example.models.error.Error;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class LoginErrorResponse implements Question<Error> {
    @Override
    public Error answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(Error.class);
    }
}
