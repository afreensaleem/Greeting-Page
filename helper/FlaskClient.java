package helper;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

public class FlaskClient {

    // Replace this with your actual Hugging Face Space API URL
    private static final String SPACE_URL = "https://hf.space/embed/AfreenSaleem/background-remover/api/predict/";

    public static String sendImageToFlask(InputStream imageInputStream) throws IOException {
        // Read image bytes
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int n;
        while ((n = imageInputStream.read(buffer)) != -1) {
            baos.write(buffer, 0, n);
        }
        byte[] imageBytes = baos.toByteArray();
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);

        // Prepare JSON payload
        String jsonPayload = "{ \"data\": [\"data:image/png;base64," + base64Image + "\"] }";

        URL url = new URL(SPACE_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonPayload.getBytes());
            os.flush();
        }

        int status = conn.getResponseCode();
        if (status != 200) {
            throw new IOException("Failed : HTTP error code : " + status);
        }

        BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        conn.disconnect();

        // The HF Space returns JSON: {"data":["<base64_image>"]}
        String resultJson = sb.toString();
        int start = resultJson.indexOf("[\"") + 2;
        int end = resultJson.indexOf("\"]");
        String resultBase64 = resultJson.substring(start, end);

        return resultBase64;
    }
}
