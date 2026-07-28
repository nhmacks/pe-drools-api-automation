package com.example.hooks;

import com.example.steps.EncountersStepDef;
import com.example.utils.HtmlReportGenerator;
import net.serenitybdd.screenplay.actors.OnStage;
import net.serenitybdd.screenplay.actors.OnlineCast;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import java.util.List;
import java.util.Map;

public class Hooks {

    @Before
    public void setTheStage() {
        OnStage.setTheStage(new OnlineCast());
    }

    @After(value = "@consulta-encuentro", order = 0)
    public void generateIndexAfterEachEncounter() {
        List<Map<String, String>> reports = EncountersStepDef.getEncounteredReports();

        if (!reports.isEmpty()) {
            HtmlReportGenerator.generateIndexReport(reports);
            HtmlReportGenerator.regenerateReportsWithNavigation(reports);
            System.out.println("📋 Índice y navegación actualizados con " + reports.size() + " encuentro(s)");
        }
    }
}

