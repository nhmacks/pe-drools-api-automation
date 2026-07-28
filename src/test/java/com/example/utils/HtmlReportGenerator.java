package com.example.utils;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class HtmlReportGenerator {

    private static final String REPORTS_DIR = "target/encounter-reports/";

    public static void generateHtmlReport(Map<String, Object> responseData, String fileName) {
        generateHtmlReport(responseData, fileName, null, null, 0, 0);
    }

    public static void generateHtmlReport(Map<String, Object> responseData, String fileName,
                                         String previousFileName, String nextFileName,
                                         int currentIndex, int totalReports) {
        try {
            Files.createDirectories(Paths.get(REPORTS_DIR));

            String htmlContent = buildHtmlContent(responseData, previousFileName, nextFileName, currentIndex, totalReports);
            String filePath = REPORTS_DIR + fileName;

            try (FileWriter writer = new FileWriter(filePath)) {
                writer.write(htmlContent);
            }

            System.out.println("Reporte HTML generado exitosamente en: " + filePath);

        } catch (IOException e) {
            throw new RuntimeException("Error al generar el reporte HTML: " + e.getMessage(), e);
        }
    }

    private static String buildHtmlContent(Map<String, Object> responseData,
                                           String previousFileName, String nextFileName,
                                           int currentIndex, int totalReports) {
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>\n");
        html.append("<html lang='es'>\n");
        html.append("<head>\n");
        html.append("    <meta charset='UTF-8'>\n");
        html.append("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n");
        html.append("    <title>Detalle de Encuentro - ").append(responseData.get("visitOccurrenceId")).append("</title>\n");
        html.append("    <style>\n");
        html.append(getStyles());
        html.append("    </style>\n");
        html.append("</head>\n");
        html.append("<body>\n");

        String currentDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));

        html.append("    <div class='header'>\n");
        html.append("        <h1>Detalle de Encuentro</h1>\n");
        html.append("        <div class='info-box'>\n");
        html.append("            <p><strong>Visit Occurrence ID:</strong> ").append(responseData.get("visitOccurrenceId")).append("</p>\n");
        html.append("            <p><strong>Consultado en:</strong> ").append(responseData.get("queriedAt")).append("</p>\n");
        html.append("            <p><strong>Reporte generado:</strong> ").append(currentDateTime).append("</p>\n");
        if (totalReports > 0) {
            html.append("            <p><strong>Encuentro:</strong> ").append(currentIndex).append(" de ").append(totalReports).append("</p>\n");
        }
        html.append("        </div>\n");
        html.append("    </div>\n");

        // Navigation bar
        html.append("    <div class='navigation-bar'>\n");
        html.append("        <div class='nav-left'>\n");
        html.append("            <a href='index.html' class='btn-nav btn-back'>⬅ Volver al Índice</a>\n");
        html.append("        </div>\n");
        html.append("        <div class='nav-right'>\n");
        if (previousFileName != null && !previousFileName.isEmpty()) {
            html.append("            <a href='").append(previousFileName).append("' class='btn-nav btn-prev'>⬅ Anterior</a>\n");
        } else {
            html.append("            <button class='btn-nav btn-disabled' disabled>⬅ Anterior</button>\n");
        }
        if (nextFileName != null && !nextFileName.isEmpty()) {
            html.append("            <a href='").append(nextFileName).append("' class='btn-nav btn-next'>Siguiente ➡</a>\n");
        } else {
            html.append("            <button class='btn-nav btn-disabled' disabled>Siguiente ➡</button>\n");
        }
        html.append("        </div>\n");
        html.append("    </div>\n");

        html.append("    <div class='container'>\n");

        Map<String, Object> tables = (Map<String, Object>) responseData.get("tables");
        if (tables != null) {
            for (Map.Entry<String, Object> entry : tables.entrySet()) {
                String tableName = entry.getKey();
                Object tableData = entry.getValue();

                if (tableData instanceof List) {
                    List<Map<String, Object>> rows = (List<Map<String, Object>>) tableData;
                    html.append(buildTableHtml(tableName, rows));
                }
            }
        }

        Map<String, Object> resolved = (Map<String, Object>) responseData.get("resolved");
        if (resolved != null) {
            html.append("        <h2 class='section-title'>Datos Resueltos</h2>\n");
            for (Map.Entry<String, Object> entry : resolved.entrySet()) {
                String tableName = entry.getKey();
                Object tableData = entry.getValue();

                if (tableData instanceof List) {
                    List<Map<String, Object>> rows = (List<Map<String, Object>>) tableData;
                    html.append(buildTableHtml(tableName, rows));
                }
            }
        }

        html.append("    </div>\n");
        html.append("</body>\n");
        html.append("</html>");

        return html.toString();
    }

    private static String buildTableHtml(String tableName, List<Map<String, Object>> rows) {
        if (rows == null || rows.isEmpty()) {
            return "        <div class='table-section'>\n" +
                   "            <h3 class='table-title'>" + formatTableName(tableName) + "</h3>\n" +
                   "            <p class='empty-table'>No hay datos disponibles</p>\n" +
                   "        </div>\n";
        }

        StringBuilder html = new StringBuilder();
        html.append("        <div class='table-section'>\n");
        html.append("            <h3 class='table-title'>").append(formatTableName(tableName)).append("</h3>\n");
        html.append("            <div class='table-wrapper'>\n");
        html.append("                <table>\n");

        Set<String> headers = new LinkedHashSet<>();
        for (Map<String, Object> row : rows) {
            headers.addAll(row.keySet());
        }

        html.append("                    <thead>\n");
        html.append("                        <tr>\n");
        for (String header : headers) {
            html.append("                            <th>").append(formatColumnName(header)).append("</th>\n");
        }
        html.append("                        </tr>\n");
        html.append("                    </thead>\n");

        html.append("                    <tbody>\n");
        for (Map<String, Object> row : rows) {
            html.append("                        <tr>\n");
            for (String header : headers) {
                Object value = row.get(header);
                String cellValue = value != null ? escapeHtml(value.toString()) : "";
                html.append("                            <td>").append(cellValue).append("</td>\n");
            }
            html.append("                        </tr>\n");
        }
        html.append("                    </tbody>\n");

        html.append("                </table>\n");
        html.append("            </div>\n");
        html.append("            <p class='row-count'>Total de registros: ").append(rows.size()).append("</p>\n");
        html.append("        </div>\n");

        return html.toString();
    }

    private static String formatTableName(String tableName) {
        return tableName.replace("_", " ").toUpperCase();
    }

    private static String formatColumnName(String columnName) {
        String[] words = columnName.split("_");
        StringBuilder formatted = new StringBuilder();
        for (String word : words) {
            if (formatted.length() > 0) {
                formatted.append(" ");
            }
            formatted.append(word.substring(0, 1).toUpperCase())
                     .append(word.substring(1).toLowerCase());
        }
        return formatted.toString();
    }

    private static String escapeHtml(String text) {
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }

    private static String getStyles() {
        return """
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 20px;
                    min-height: 100vh;
                }

                .header {
                    background: white;
                    border-radius: 10px;
                    padding: 30px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                h1 {
                    color: #667eea;
                    margin-bottom: 20px;
                    font-size: 2.5em;
                    text-align: center;
                }

                .info-box {
                    background: #f8f9fa;
                    border-left: 4px solid #667eea;
                    padding: 15px;
                    border-radius: 5px;
                }

                .info-box p {
                    margin: 5px 0;
                    color: #333;
                    font-size: 1.1em;
                }

                .container {
                    max-width: 100%;
                }

                .section-title {
                    color: white;
                    background: rgba(255, 255, 255, 0.2);
                    padding: 15px;
                    border-radius: 10px;
                    margin: 20px 0;
                    font-size: 1.8em;
                    text-align: center;
                }

                .table-section {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .table-title {
                    color: #764ba2;
                    margin-bottom: 15px;
                    font-size: 1.5em;
                    border-bottom: 3px solid #667eea;
                    padding-bottom: 10px;
                }

                .table-wrapper {
                    overflow-x: auto;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 10px;
                }

                thead {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                th {
                    padding: 15px;
                    text-align: left;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 0.9em;
                    letter-spacing: 0.5px;
                    white-space: nowrap;
                }

                td {
                    padding: 12px 15px;
                    border-bottom: 1px solid #e0e0e0;
                }

                tbody tr:hover {
                    background-color: #f5f5f5;
                    transition: background-color 0.3s ease;
                }

                tbody tr:nth-child(even) {
                    background-color: #f9f9f9;
                }

                .empty-table {
                    text-align: center;
                    padding: 30px;
                    color: #999;
                    font-style: italic;
                    font-size: 1.1em;
                }

                .row-count {
                    color: #666;
                    font-size: 0.9em;
                    font-weight: 600;
                    margin-top: 10px;
                    text-align: right;
                }

                .navigation-bar {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .nav-left, .nav-right {
                    display: flex;
                    gap: 10px;
                }

                .btn-nav {
                    display: inline-block;
                    padding: 12px 24px;
                    border-radius: 5px;
                    font-weight: 600;
                    text-decoration: none;
                    transition: all 0.3s ease;
                    border: none;
                    cursor: pointer;
                    font-size: 1em;
                }

                .btn-back {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
                }

                .btn-back:hover {
                    opacity: 0.9;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
                    transform: translateY(-2px);
                }

                .btn-prev, .btn-next {
                    background: #f8f9fa;
                    color: #667eea;
                    border: 2px solid #667eea;
                }

                .btn-prev:hover, .btn-next:hover {
                    background: #667eea;
                    color: white;
                    transform: translateY(-2px);
                }

                .btn-disabled {
                    background: #e9ecef;
                    color: #adb5bd;
                    cursor: not-allowed;
                    border: 2px solid #dee2e6;
                }

                @media (max-width: 768px) {
                    body {
                        padding: 10px;
                    }

                    h1 {
                        font-size: 1.8em;
                    }

                    .table-section {
                        padding: 15px;
                    }

                    th, td {
                        padding: 8px;
                        font-size: 0.9em;
                    }

                    .navigation-bar {
                        flex-direction: column;
                        gap: 15px;
                    }

                    .nav-left, .nav-right {
                        width: 100%;
                        justify-content: center;
                    }

                    .btn-nav {
                        width: 100%;
                    }
                }
                """;
    }

    public static void generateIndexReport(List<Map<String, String>> reports) {
        try {
            Files.createDirectories(Paths.get(REPORTS_DIR));

            String htmlContent = buildIndexHtmlContent(reports);
            String filePath = REPORTS_DIR + "index.html";

            try (FileWriter writer = new FileWriter(filePath)) {
                writer.write(htmlContent);
            }

            System.out.println("Reporte índice generado exitosamente en: " + filePath);

        } catch (IOException e) {
            throw new RuntimeException("Error al generar el reporte índice: " + e.getMessage(), e);
        }
    }

    public static void regenerateReportsWithNavigation(List<Map<String, String>> reports) {
        Map<String, Map<String, Object>> responseDataCache =
            com.example.steps.EncountersStepDef.getResponseDataCache();

        for (int i = 0; i < reports.size(); i++) {
            Map<String, String> reportInfo = reports.get(i);
            String fileName = reportInfo.get("fileName");
            Map<String, Object> responseData = responseDataCache.get(fileName);

            if (responseData != null) {
                String previousFileName = (i > 0) ? reports.get(i - 1).get("fileName") : null;
                String nextFileName = (i < reports.size() - 1) ? reports.get(i + 1).get("fileName") : null;
                int currentIndex = i + 1;
                int totalReports = reports.size();

                generateHtmlReport(responseData, fileName, previousFileName, nextFileName, currentIndex, totalReports);
            }
        }
    }

    private static String buildIndexHtmlContent(List<Map<String, String>> reports) {
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>\n");
        html.append("<html lang='es'>\n");
        html.append("<head>\n");
        html.append("    <meta charset='UTF-8'>\n");
        html.append("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n");
        html.append("    <title>Índice de Encuentros Consultados</title>\n");
        html.append("    <style>\n");
        html.append(getIndexStyles());
        html.append("    </style>\n");
        html.append("</head>\n");
        html.append("<body>\n");

        String currentDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));

        html.append("    <div class='header'>\n");
        html.append("        <h1>📋 Índice de Encuentros Consultados</h1>\n");
        html.append("        <div class='info-box'>\n");
        html.append("            <p><strong>Total de encuentros consultados:</strong> ").append(reports.size()).append("</p>\n");
        html.append("            <p><strong>Reporte generado:</strong> ").append(currentDateTime).append("</p>\n");
        html.append("        </div>\n");
        html.append("    </div>\n");

        html.append("    <div class='container'>\n");
        html.append("        <div class='encounters-list'>\n");

        for (int i = 0; i < reports.size(); i++) {
            Map<String, String> report = reports.get(i);
            String visitOccurrenceId = report.get("visitOccurrenceId");
            String fileName = report.get("fileName");
            String queriedAt = report.get("queriedAt");

            html.append("            <div class='encounter-card'>\n");
            html.append("                <div class='encounter-number'>").append(i + 1).append("</div>\n");
            html.append("                <div class='encounter-info'>\n");
            html.append("                    <h3>Visit Occurrence ID: <span class='highlight'>").append(visitOccurrenceId).append("</span></h3>\n");
            html.append("                    <p class='detail'><strong>Consultado en:</strong> ").append(queriedAt != null ? queriedAt : "N/A").append("</p>\n");
            html.append("                    <p class='detail'><strong>Archivo:</strong> ").append(fileName).append("</p>\n");
            html.append("                </div>\n");
            html.append("                <div class='encounter-actions'>\n");
            html.append("                    <a href='").append(fileName).append("' class='btn-view'>Ver Detalle</a>\n");
            html.append("                </div>\n");
            html.append("            </div>\n");
        }

        html.append("        </div>\n");
        html.append("    </div>\n");

        html.append("    <div class='footer'>\n");
        html.append("        <p>Generado automáticamente por el framework de automatización de API</p>\n");
        html.append("    </div>\n");

        html.append("</body>\n");
        html.append("</html>");

        return html.toString();
    }

    private static String getIndexStyles() {
        return """
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 20px;
                    min-height: 100vh;
                }

                .header {
                    background: white;
                    border-radius: 10px;
                    padding: 30px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                h1 {
                    color: #667eea;
                    margin-bottom: 20px;
                    font-size: 2.5em;
                    text-align: center;
                }

                .info-box {
                    background: #f8f9fa;
                    border-left: 4px solid #667eea;
                    padding: 15px;
                    border-radius: 5px;
                }

                .info-box p {
                    margin: 5px 0;
                    color: #333;
                    font-size: 1.1em;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .encounters-list {
                    display: grid;
                    gap: 20px;
                }

                .encounter-card {
                    background: white;
                    border-radius: 10px;
                    padding: 25px;
                    display: flex;
                    align-items: center;
                    gap: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                }

                .encounter-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
                }

                .encounter-number {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    width: 60px;
                    height: 60px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5em;
                    font-weight: bold;
                    flex-shrink: 0;
                }

                .encounter-info {
                    flex: 1;
                }

                .encounter-info h3 {
                    color: #333;
                    margin-bottom: 10px;
                    font-size: 1.3em;
                }

                .highlight {
                    color: #667eea;
                    font-weight: bold;
                }

                .detail {
                    color: #666;
                    margin: 5px 0;
                    font-size: 0.95em;
                }

                .encounter-actions {
                    flex-shrink: 0;
                }

                .btn-view {
                    display: inline-block;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 12px 30px;
                    text-decoration: none;
                    border-radius: 5px;
                    font-weight: 600;
                    transition: opacity 0.3s ease;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
                }

                .btn-view:hover {
                    opacity: 0.9;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
                }

                .footer {
                    text-align: center;
                    color: white;
                    margin-top: 30px;
                    padding: 20px;
                    background: rgba(255, 255, 255, 0.1);
                    border-radius: 10px;
                }

                .footer p {
                    font-size: 0.9em;
                }

                @media (max-width: 768px) {
                    body {
                        padding: 10px;
                    }

                    h1 {
                        font-size: 1.8em;
                    }

                    .encounter-card {
                        flex-direction: column;
                        text-align: center;
                    }

                    .encounter-number {
                        width: 50px;
                        height: 50px;
                        font-size: 1.2em;
                    }

                    .btn-view {
                        width: 100%;
                    }
                }
                """;
    }
}