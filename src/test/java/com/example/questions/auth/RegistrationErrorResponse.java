package com.example.questions.auth;

import com.example.models.auth.register.response.RegisterErrorResponse;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question to extract error response from registration endpoint.
 */
public class RegistrationErrorResponse implements Question<RegisterErrorResponse> {
    @Override
    public RegisterErrorResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(RegisterErrorResponse.class);
    }

    @Override
    public String getSubject() {
        return "User registration error response";
    }
}
