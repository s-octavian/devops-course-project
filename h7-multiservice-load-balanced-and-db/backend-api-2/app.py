from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

SERVICE_ID = os.environ.get("SERVICE_ID", "Unknown")
APP_PORT = int(os.environ.get("FLASK_RUN_PORT", 5000))
DATABASE_URL = os.environ.get("DATABASE_URL")
if not DATABASE_URL:
    raise Exception("DATABASE_URL environment variable is required!")

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URL
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

class Item(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

with app.app_context():
    db.create_all()

@app.route("/api/status", methods=["GET"])
def status():
    return jsonify({"status": "ok", "service": SERVICE_ID}), 200

@app.route("/api/items", methods=["POST"])
def create_item():
    data = request.get_json()
    if not data or "name" not in data:
        return jsonify({"error": "Missing 'name'"}), 400
    item = Item(name=data["name"])
    db.session.add(item)
    db.session.commit()
    return jsonify({
        "message": f"Created item successfully on {SERVICE_ID}",
        "item": {"id": item.id, "name": item.name}
    }), 201

@app.route("/api/items", methods=["GET"])
def get_items():
    items = Item.query.all()
    return jsonify({
        "message": f"Fetched items successfully from {SERVICE_ID}",
        "items": [{"id": i.id, "name": i.name} for i in items]
    })

@app.route("/api/items/<int:item_id>", methods=["DELETE"])
def delete_item(item_id):
    item = Item.query.get(item_id)
    if not item:
        return jsonify({"error": f"Item {item_id} not found"}), 404
    db.session.delete(item)
    db.session.commit()
    return jsonify({"message": f"Deleted item {item_id} successfully on {SERVICE_ID}"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=APP_PORT)

