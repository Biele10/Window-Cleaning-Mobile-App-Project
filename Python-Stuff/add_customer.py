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

@app.route('/add_customer', methods=['POST'])
def add_customer():         # function that stores customer data in database

    data = request.get_json()       # pulls data from user input in json form
    
    name = data.get('Name')
    address = data.get('Address')
    regularity = data.get('Regularity')
    email = data.get('Email')
    phone = data.get('Phone')
    add_info = data.get('AddInfo')

    values = (name, address, regularity, email, phone, add_info)        # creates tuple which can be passed into SQL statement

    if ValidationCheck(values):         # if true is returned, sql can proceed

        customer_sql_statement = "INSERT INTO Customers (Name, Address, Regularity, Email, Phone, Additional_Information) VALUES (%s, %s, %s, %s, %s, %s)"      

        # prevents SQL as %s tells the database (MYSQL) that the data being passed through is ONLY data, therefore cannot be used in order to access/alter the database - prevents SQL injection

        cursor.execute(customer_sql_statement, values)       # adds values to database

        database_connect.commit()   # commits the change to the database

    else:

        return jsonify({"message": "Fields can only be a maximum of 255 characters."}), 401



@app.route('/get_customers', methods=['GET'])
def get_customers(data):
    return "nice"


def ValidationCheck(details) -> bool:    # returns true or false depending on if name is fine

    for info in details:
        if len(info) > 255:         # values cannot exceed length of 255 characters
            return False
    return True

@app.route('/sign_up', methods=['POST'])

def sign_up(username : str, password : str):
    return None




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)