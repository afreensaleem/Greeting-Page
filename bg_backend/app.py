from flask import Flask, request, send_file
from flask_cors import CORS
import requests
from io import BytesIO
import os  

app = Flask(__name__)
CORS(app)

HF_TOKEN = os.getenv("HF_TOKEN")  # replace with your Hugging Face token
HF_MODEL = "briaai/RMBG-1.4"
HF_URL = f"https://api-inference.huggingface.co/models/{HF_MODEL}"

@app.route("/")
def home():
    return "Background remover API is running"

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


@app.route("/remove-bg", methods=["POST"])
def remove_bg():
    if 'file' not in request.files:
        return "No file uploaded", 400

    file = request.files['file']
    headers = {"Authorization": f"Bearer {HF_TOKEN}"}

    resp = requests.post(HF_URL, headers=headers, data=file.read())
    print("Status code:", resp.status_code)
    print("Response content (first 500 chars):", resp.text[:500])

    if resp.status_code != 200:
        return f"Hugging Face error: {resp.status_code} - {resp.text[:500]}", 500

    return send_file(BytesIO(resp.content), mimetype="image/png")

    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
