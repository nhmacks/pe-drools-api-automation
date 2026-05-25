package com.example.tasks;

import com.example.models.auth.login.request.LoginRequest;

import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Post;

public class Login implements Task {

    private final LoginRequest loginRequest;

    public Login(LoginRequest loginRequest) {
        this.loginRequest = loginRequest;
    }

    public static Login withCredentials(String email, String password) {
        return new Login(new LoginRequest(email, password));
    }

    public static Login withRequest(LoginRequest loginRequest) {
        return new Login(loginRequest);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
                Post.to("/api/auth/login")
                        .with(request -> request
                                .header("Content-Type", "application/json")
                                .body(loginRequest)));
    }
}
