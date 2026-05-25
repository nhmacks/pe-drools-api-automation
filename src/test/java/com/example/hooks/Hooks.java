package com.example.hooks;

import net.serenitybdd.screenplay.actors.OnStage;
import net.serenitybdd.screenplay.actors.OnlineCast;
import io.cucumber.java.Before;

public class Hooks {
    @Before
    public void setTheStage() {
        OnStage.setTheStage(new OnlineCast());
    }
}

