package com.example.models.encounters.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EncountersResponse {

    private List<EncounterResponse> encounters;

    public EncountersResponse() {
    }

    public List<EncounterResponse> getEncounters() {
        return encounters;
    }

    public void setEncounters(List<EncounterResponse> encounters) {
        this.encounters = encounters;
    }
}
