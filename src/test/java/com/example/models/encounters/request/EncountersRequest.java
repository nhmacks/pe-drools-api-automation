package com.example.models.encounters.request;

import java.util.List;

/**
 * Root request object containing a list of encounters.
 */
public class EncountersRequest {

    private List<Encounter> encounters;

    public EncountersRequest() {
    }

    public EncountersRequest(List<Encounter> encounters) {
        this.encounters = encounters;
    }

    public List<Encounter> getEncounters() {
        return encounters;
    }

    public void setEncounters(List<Encounter> encounters) {
        this.encounters = encounters;
    }

    @Override
    public String toString() {
        return "EncountersRequest{" +
                "encounters=" + encounters +
                '}';
    }
}
