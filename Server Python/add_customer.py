from flask import Flask, request, jsonify
from pathlib import Path
from dotenv import load_dotenv
import os

env_path = Path("variables.env")
load_dotenv(dotenv_path=env_path)       # loads in private variables

db_user = os.getenv("database_user")
print(db_user)


app = Flask(__name__)

@app.route('/receive', methods=['POST'])
def receive():
    data = request.get_json()  # this parses the JSON body
    name = data.get('Name')
    address = data.get('Address')
    regularity = data.get('Regularity')
    email = data.get('Email')
    phone = data.get('Phone')
    add_info = data.get('AddInfo')

    print(name, address, regularity, email, phone, add_info)

    # respond back to Flutter
    return jsonify({"status": "ok", "message": f"Hello {name}!"})


