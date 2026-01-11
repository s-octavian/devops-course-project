from flask import Flask, jsonify, request
import os
import time

app = Flask(__name__)

# Get service ID from environment variable, default to 'Unknown'
SERVICE_ID = os.environ.get('SERVICE_ID', 'Unknown')
APP_PORT = int(os.environ.get('FLASK_RUN_PORT', 5000)) # Default port

@app.route('/api/status', methods=['GET'])
def status():
    # Simulate some work
    time.sleep(0.1)
    return jsonify({
        "status": "up",
        "message": f"Hello from Backend API {SERVICE_ID}!",
        "served_by_port": APP_PORT,
        "timestamp": time.time()
    })

@app.route('/api/data', methods=['GET'])
def get_data():
    data = request.args.get('item', 'default-item')
    return jsonify({
        "service": f"Backend {SERVICE_ID}",
        "item_requested": data,
        "details": f"This is some data for '{data}' served by Backend {SERVICE_ID}.",
        "timestamp": time.time()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=APP_PORT)
