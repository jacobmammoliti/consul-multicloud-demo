import os
import requests
from flask import Flask, render_template

#ENV VARS
CLOUD = os.getenv("CLOUD", "AZURE").lower()
API_ENDPOINT = os.getenv("API_ENDPOINT", "127.0.0.1")
API_PORT = os.getenv("API_PORT", "3000")
API_SERVICE = os.getenv("API_SERVICE", "NUMBERS").lower()

app = Flask(__name__)

@app.route('/healthz', methods=['GET'])
def health_check():
    return "All good.", 200

@app.route('/', methods=['GET'])
def main():
    request = requests.get(f'http://{API_ENDPOINT}:{API_PORT}/api/v1/{API_SERVICE}')

    if request.status_code != 200:
        backend = False
        data = None
    else:
        backend = True
        data = request.json()
    
    return render_template( 
        'index.html',
        cloud = CLOUD,
        backend = backend,
        data = data['data'],
    )

if __name__ == '__main__':
    app.run(debug=True, port=8000)