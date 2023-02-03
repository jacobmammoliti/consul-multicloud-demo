from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route('/healthz', methods=['GET'])
def health_check():
    return "All good.", 200

@app.route('/api/v1/numbers', methods=['GET'])
def display_number_data():
    r = requests.get("http://numbersapi.com/random/math")
    return jsonify({"data": r.text})

@app.route('/api/v1/cats', methods=['GET'])
def display_cat_data():
    r = requests.get("https://catfact.ninja/fact", verify=False)
    return jsonify({"data": r.json()['fact']})

if __name__ == '__main__':
    app.run(debug=True, port=3000)