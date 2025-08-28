import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.json.JSONArray;
import org.json.JSONObject;

public class FlaskClient {
    public static String sendImageToFlask(InputStream imageInputStream) throws IOException {
        String hfUrl = "https://afreensaleem-background-remover.hf.space/api/predict";
        String accessToken = System.getenv("HF_TOKEN"); // Optional: read token from env variable

        // Read image bytes and encode to base64 with MIME prefix
        byte[] bytes = imageInputStream.readAllBytes();
        String base64Image = Base64.getEncoder().encodeToString(bytes);
        String fullBase64 = "data:image/png;base64," + base64Image;

        // Create JSON payload
        JSONObject payload = new JSONObject();
        JSONArray dataArray = new JSONArray();
        dataArray.put(fullBase64);
        payload.put("data", dataArray);

        URL url = new URL(hfUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        if (accessToken != null && !accessToken.isEmpty()) {
            conn.setRequestProperty("Authorization", "Bearer " + accessToken); // Add token if present
        }
        conn.setConnectTimeout(15000); // Increased timeout for HF
        conn.setReadTimeout(45000);

        // Write JSON payload
        try (OutputStream output = conn.getOutputStream()) {
            output.write(payload.toString().getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        System.out.println("HF response code: " + status);

        if (status == HttpURLConnection.HTTP_OK) {
            // Read response as string
            StringBuilder responseBuilder = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseBuilder.append(responseLine.trim());
                }
            }
            conn.disconnect();

            // Parse JSON and extract base64 (strip MIME prefix)
            JSONObject responseJson = new JSONObject(responseBuilder.toString());
            String outputFullBase64 = responseJson.getJSONArray("data").getString(0);
            String outputBase64 = outputFullBase64.split(",")[1]; // After 'base64,'

            return outputBase64;
        } else {
            // Read error stream
            StringBuilder errorBuilder = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                String errorLine;
                while ((errorLine = br.readLine()) != null) {
                    errorBuilder.append(errorLine.trim());
                }
            }
            System.err.println("Error from HF: " + errorBuilder.toString());
            throw new IOException("HF API error: " + errorBuilder.toString());
        }
    }
}
