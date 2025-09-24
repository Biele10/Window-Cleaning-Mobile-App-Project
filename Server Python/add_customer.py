from flask import Flask, request, jsonify
from pathlib import Path
from dotenv import load_dotenv
import os
import mysql.connector   # imports mysql library in order to connect to database
                # with its functions


env_path = Path("variables.env")
load_dotenv(dotenv_path=env_path)       # loads in private variables

database_connect = mysql.connector.connect(         # establishes connection to database
    host=os.getenv("database_host"),
    user=os.getenv("database_user"),
    password=os.getenv("database_password"),     # information to specify database to add to
    database=os.getenv("database")      # host, username, password and database name
)

cursor = database_connect.cursor()   # allows for Python code to execute SQL statements

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


