package com.example.questions.auth;

import com.example.models.auth.register.response.RegisterUserResponse;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract successful registration response.
 */
public class RegistrationResponse implements Question<RegisterUserResponse> {
    @Override
    public RegisterUserResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(RegisterUserResponse.class);
    }

    @Override
    public String getSubject() {
        return "User registration response";
    }
}
