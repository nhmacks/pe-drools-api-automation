package com.example.runners;

import org.junit.runner.RunWith;
import net.serenitybdd.cucumber.CucumberWithSerenity;
import io.cucumber.junit.CucumberOptions;

@RunWith(CucumberWithSerenity.class)
@CucumberOptions(
    features = "src/test/resources/features",
    plugin = {"pretty", "json:target/cucumber.json", "junit:target/cucumber.xml"},
    glue = {"com.example.steps", "com.example.hooks"}
)
public class RunCucumberTest {
    // Runner para Cucumber + Serenity. Ejecútalo con `mvn clean verify`.
}
