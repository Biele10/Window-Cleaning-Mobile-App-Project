from flask import Flask, request, jsonify

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


