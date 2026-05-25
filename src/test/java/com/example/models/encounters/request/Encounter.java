package com.example.models.encounters.request;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * Represents an encounter with its associated services.
 * Fields use String types where applicable to enable negative testing with invalid data types.
 */
public class Encounter {

    @JsonProperty("encounter_id")
    private String encounterId;

    private String financiador;

    @JsonProperty("importe_total")
    private Double importeTotal;

    @JsonProperty("tipo_encounter")
    private String tipoEncounter;

    private String empresa;
    private String sede;
    private List<Service> services;

    public Encounter() {
    }

    public Encounter(String encounterId, String financiador, Double importeTotal,
                     String tipoEncounter, String empresa, String sede, List<Service> services) {
        this.encounterId = encounterId;
        this.financiador = financiador;
        this.importeTotal = importeTotal;
        this.tipoEncounter = tipoEncounter;
        this.empresa = empresa;
        this.sede = sede;
        this.services = services;
    }

    public String getEncounterId() {
        return encounterId;
    }

    public void setEncounterId(String encounterId) {
        this.encounterId = encounterId;
    }

    public String getFinanciador() {
        return financiador;
    }

    public void setFinanciador(String financiador) {
        this.financiador = financiador;
    }

    public Double getImporteTotal() {
        return importeTotal;
    }

    public void setImporteTotal(Double importeTotal) {
        this.importeTotal = importeTotal;
    }

    public String getTipoEncounter() {
        return tipoEncounter;
    }

    public void setTipoEncounter(String tipoEncounter) {
        this.tipoEncounter = tipoEncounter;
    }

    public String getEmpresa() {
        return empresa;
    }

    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }

    public String getSede() {
        return sede;
    }

    public void setSede(String sede) {
        this.sede = sede;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    @Override
    public String toString() {
        return "Encounter{" +
                "encounterId='" + encounterId + '\'' +
                ", financiador='" + financiador + '\'' +
                ", importeTotal=" + importeTotal +
                ", tipoEncounter='" + tipoEncounter + '\'' +
                ", empresa='" + empresa + '\'' +
                ", sede='" + sede + '\'' +
                ", services=" + services +
                '}';
    }
}
