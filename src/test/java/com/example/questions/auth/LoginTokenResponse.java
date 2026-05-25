package com.example.questions.auth;

import com.example.models.auth.login.response.LoginResponse;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

public class LoginTokenResponse implements Question<LoginResponse> {
    @Override
    public LoginResponse answeredBy(Actor actor) {
        return SerenityRest.lastResponse().body().as(LoginResponse.class);
    }
}
