package com.example.models.encounters.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EncounterResponse {

    @JsonProperty("encounter_id")
    private String encounterId;

    @JsonProperty("documentos_necesarios")
    private List<Object> documentosNecesarios;

    @JsonProperty("documentos_reemplazables")
    private List<Object> documentosReemplazables;

    private List<ServiceResponse> services;

    public EncounterResponse() {
    }

    public String getEncounterId() {
        return encounterId;
    }

    public void setEncounterId(String encounterId) {
        this.encounterId = encounterId;
    }

    public List<Object> getDocumentosNecesarios() {
        return documentosNecesarios;
    }

    public void setDocumentosNecesarios(List<Object> documentosNecesarios) {
        this.documentosNecesarios = documentosNecesarios;
    }

    public List<Object> getDocumentosReemplazables() {
        return documentosReemplazables;
    }

    public void setDocumentosReemplazables(List<Object> documentosReemplazables) {
        this.documentosReemplazables = documentosReemplazables;
    }

    public List<ServiceResponse> getServices() {
        return services;
    }

    public void setServices(List<ServiceResponse> services) {
        this.services = services;
    }
}
