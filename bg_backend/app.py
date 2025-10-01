from flask import Flask, request, send_file
import requests
from io import BytesIO

app = Flask(__name__)

HF_TOKEN = os.getenv("HF_TOKEN")  # replace with your Hugging Face token
HF_MODEL = "briaai/RMBG-1.4"
HF_URL = f"https://api-inference.huggingface.co/models/{HF_MODEL}"

@app.route("/remove-bg", methods=["POST"])
def remove_bg():
    if 'file' not in request.files:
        return "No file uploaded", 400

    file = request.files['file']
    headers = {"Authorization": f"Bearer {HF_TOKEN}"}

    resp = requests.post(HF_URL, headers=headers, data=file.read())
    if resp.status_code != 200:
        return f"Hugging Face error: {resp.status_code}", 500

    return send_file(BytesIO(resp.content), mimetype="image/png")
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
