package helper;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

public class FlaskClient {

    private static final String HF_API_URL = "https://api-inference.huggingface.co/models/AfreenSaleem/background-remover";
    private static final String HF_TOKEN = "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";

    public static String sendImageToFlask(InputStream imageInputStream) throws IOException {
        URL url = new URL(HF_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + HF_TOKEN);
        conn.setRequestProperty("Content-Type", "application/octet-stream");

        // Send image bytes
        try (OutputStream os = conn.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = imageInputStream.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
        }

        int status = conn.getResponseCode();
        InputStream responseStream = (status == 200) ? conn.getInputStream() : conn.getErrorStream();

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buf = new byte[4096];
        int len;
        while ((len = responseStream.read(buf)) != -1) {
            baos.write(buf, 0, len);
        }

        if (status != 200) {
            throw new IOException("HF API error: " + new String(baos.toByteArray()));
        }

        return Base64.getEncoder().encodeToString(baos.toByteArray());
    }
}
