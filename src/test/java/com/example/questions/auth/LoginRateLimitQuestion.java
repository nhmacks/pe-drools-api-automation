package com.example.questions.auth;

import com.example.models.error.Error;
import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Question;

/**
 * Question helpers to inspect login error responses for rate limiting / account lockout.
 */
public class LoginRateLimitQuestion {

    public static Question<Error> asError() {
        return new Question<Error>() {
            @Override
            public Error answeredBy(Actor actor) {
                return SerenityRest.lastResponse().body().as(Error.class);
            }

            @Override
            public String getSubject() {
                return "Login error response as Error";
            }
        };
    }

    public static Question<Boolean> isRateLimitOrAccountLockout() {
        return new Question<Boolean>() {
            @Override
            public Boolean answeredBy(Actor actor) {
                String body = "";
                try {
                    body = SerenityRest.lastResponse().getBody().asString().toLowerCase();
                } catch (Exception e) {
                    // ignore and keep body empty
                }
                int status = SerenityRest.lastResponse().statusCode();

                boolean containsRate = body.contains("rate limit")
                        || body.contains("too many requests")
                        || body.contains("too many request")
                        || body.contains("demasiadas solicitudes")
                        || body.contains("bloque")
                        || body.contains("bloqueado");

                boolean status429 = (status == 429);

                boolean isUnauthorizedWithGeneric = (status == 401)
                        && (body.contains("credencial") || body.contains("unauthorized") || body.contains("invalid") || body.contains("credenciales"));

                return containsRate || status429 || isUnauthorizedWithGeneric;
            }

            @Override
            public String getSubject() {
                return "Is rate limit or account lockout response";
            }
        };
    }
}

