

    package helper;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class HuggingFaceClient {

    private static final String API_URL = "https://api-inference.huggingface.co/models/AfreenSaleem/background-remover";
    private static final String TOKEN = "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";  // Replace with your HF token

    public static String sendImageToHF(InputStream imageInputStream) throws IOException {

        String boundary = Long.toHexString(System.currentTimeMillis());
        String LINE_FEED = "\r\n";

        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + TOKEN);
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        try (OutputStream output = conn.getOutputStream();
             PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, StandardCharsets.UTF_8), true)) {

            // Write the file under "file" key as expected by HF API
            writer.append("--").append(boundary).append(LINE_FEED);
            writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"upload.png\"").append(LINE_FEED);
            writer.append("Content-Type: image/png").append(LINE_FEED);
            writer.append(LINE_FEED).flush();

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = imageInputStream.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
            output.flush();
            writer.append(LINE_FEED).flush();
            writer.append("--").append(boundary).append("--").append(LINE_FEED).flush();
        }

        int status = conn.getResponseCode();
        if (status == HttpURLConnection.HTTP_OK) {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try (InputStream is = conn.getInputStream()) {
                byte[] buf = new byte[4096];
                int len;
                while ((len = is.read(buf)) != -1) {
                    baos.write(buf, 0, len);
                }
            }
            conn.disconnect();
            return Base64.getEncoder().encodeToString(baos.toByteArray());
        } else {
            try (InputStream es = conn.getErrorStream()) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(es));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                throw new IOException("HF API error: " + response.toString());
            }
        }
    }
}
