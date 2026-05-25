package com.example.models.encounters.request;

/**
 * Represents the location (ubicacion) within a service.
 * Fields use String types to enable negative testing with invalid data types.
 */
public class Ubicacion {

    private String departamento;
    private String provincia;

    public Ubicacion() {
    }

    public Ubicacion(String departamento, String provincia) {
        this.departamento = departamento;
        this.provincia = provincia;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public String getProvincia() {
        return provincia;
    }

    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }

    @Override
    public String toString() {
        return "Ubicacion{" +
                "departamento='" + departamento + '\'' +
                ", provincia='" + provincia + '\'' +
                '}';
    }
}
