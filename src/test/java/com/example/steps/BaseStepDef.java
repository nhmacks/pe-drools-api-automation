package com.example.steps;

import com.example.utils.ApiConfig;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.rest.abilities.CallAnApi;

import static net.serenitybdd.screenplay.actors.OnStage.theActorCalled;
import static net.serenitybdd.screenplay.actors.OnStage.theActorInTheSpotlight;

/**
 * Base class for all Cucumber step definitions.
 * Provides common methods for actor initialization and response extraction.
 */
public abstract class BaseStepDef {

    /**
     * Initialize actor with a name and REST ability.
     * @param actorName the name of the actor to initialize
     */
    protected void initializeActor(String actorName) {
        theActorCalled(actorName);
        theActorInTheSpotlight().whoCan(CallAnApi.at(ApiConfig.baseUrl()));
    }

    /**
     * Extract response data using a Question.
     * @param question the Question to answer
     * @param <T> the type of data to extract
     * @return the extracted data
     */
    protected <T> T extractResponse(Question<T> question) {
        return question.answeredBy(theActorInTheSpotlight());
    }

    /**
     * Get the actor in the spotlight (shorthand).
     */
    protected static net.serenitybdd.screenplay.Actor getActor() {
        return theActorInTheSpotlight();
    }
    /**
     * Initialize actor with base URL for auth service (different from default).
     * Auth service uses: https://auth.meitech.online
     */
    void initializeActorForAuthService(String actorName) {
        theActorCalled(actorName);
        theActorInTheSpotlight().whoCan(CallAnApi.at(ApiConfig.baseUrl()));
    }
}
