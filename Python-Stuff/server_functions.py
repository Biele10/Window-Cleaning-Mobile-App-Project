from flask import Flask, request, jsonify
from pathlib import Path
from dotenv import load_dotenv
import os
import bcrypt
import jwt
import secrets
from datetime import datetime, timedelta, timezone
import mysql.connector   # imports mysql library in order to connect to database
                # with its functions


"""

FOR REFERENCE, STATUS CODE MEANINGS:

200 - SUCCESS
400 - ERROR, ERROR MESSAGE IS ATTACHED

"""



env_path = Path("variables.env")
load_dotenv(dotenv_path=env_path)       # loads in private variables

database_connect = mysql.connector.connect(         # establishes connection to database
    host=os.getenv("database_host"),
    user=os.getenv("database_user"),
    password=os.getenv("database_password"),     # information to specify database to add to
    database=os.getenv("database")      # host, username, password and database name
)

SECRET_KEY = os.getenv("signature")       # gets the signature for tokens
PEPPER = os.getenv('pepper')    # gets the pepper for hashing purposes

cursor = database_connect.cursor()   # allows for Python code to execute SQL statements

app = Flask(__name__)

""" the following 2 functions are fantastic because they dont require extra database storage and rather
a token is created by the server when the user sends a log in request, the access token will last 30 minutes
and after that the session will expire and the user will have to reload the app. """

def generate_access_token(user_id):     # function to generate an access token
    payload = {                         # creates payload with the UserID and how long the token lasts for
        "user_id": user_id,
        "exp": datetime.now(timezone.utc) + timedelta(minutes=30)  # lasts 30 mins, measures time in UTC so that local time doesn't mess up processing
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")     # adds payload and secret signature as well as algorithm to hash the file
                                                                   # when it arrives, this will check that the original reuest sent is the same as the one recieved     
    return token        # returns the access token for the user to use for their session

def verify_access_token(token):     # function to verify an access token
    try:        # try and except statements are used because jwt returns particular errors rather than just a true or false
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return True, payload["user_id"]
    except jwt.ExpiredSignatureError:       # token expired, most common error
        return False, "Token expired"           
    except jwt.InvalidTokenError:       # token was invalid
        return False, "Invalid token"           # the bool statements will be used by whatever the original function was
                                                # to determine whether the access token was correct or not

def generate_refresh_token():

    return secrets.token_urlsafe(32)        # returns a random string that equates to a url safe token that is 43 characters in length

def hash_password(password):

    return bcrypt.hashpw((password + PEPPER).encode(), bcrypt.gensalt())        # hashes the password with the pepper and a randomly generated salt

def verify_password(password, stored_hash) -> bool:     # returns True if the password matches the one in the database, false if it doesn't

    return bcrypt.checkpw((password + PEPPER).encode(), stored_hash.encode())       # .encode() converts the string into bytes which is what the hash works with

def get_user_id(email):     # retrieves the userid of a user based off of their email

    email_check = verify_email(email)   # func to verify email exists

    if not email_check: # if false, False is returned

        return False

    GET_USER_ID_STATEMENT = "SELECT UserID FROM Users WHERE Email = %s"

    cursor.execute(GET_USER_ID_STATEMENT, (email,))

    result_user_id = cursor.fetchall()      # stores returned UserID

    return result_user_id

def verify_email(email):        # verifies whether the email is in the database or not

    CHECK_FOR_EMAIL_STATEMENT = "SELECT Email FROM Users WHERE Email = %s"      # SQL statement that looks for a particular email in the database

    cursor.execute(CHECK_FOR_EMAIL_STATEMENT, (email,))     # executes the email search statement

    result = cursor.fetchall()     # stores response from database
    
    if not result:  # no email was found

        return False
    
    else:       # email was found

        return True



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
def sign_up():
    data = request.get_json()  # extracts information from sign up request
    forename = data.get('Forename')
    surname = data.get('Surname')
    email = data.get('Email')
    password = data.get('Password')

    values = (email, password, forename, surname)        # creates tuple which can be passed into SQL statement

    if ValidationCheck(values):         # if true is returned, sql can proceed

        hashed_password = hash_password(password)       # hashes the password entered by the user and stores in hashed password

        email_check = verify_email(email)       # calls a function that verifies whether the email is in the database or not, true if it is, false if it isn't

        if not email_check:     # if the email is not already in use (false was returned), the user can sign up successfully

            refresh_token = generate_refresh_token()    # generates a refresh token for sign up

            expiry_date = datetime.now(timezone.utc) + timedelta(days=30)       # creates expiration date for 30 days, then new refresh token will need to be retrieved

            values = (email, hashed_password, forename, surname, refresh_token, expiry_date)       # remakes values tuple so all data can be inputted together

            SIGN_UP_SQL_STATEMENT = "INSERT INTO Users (Email, Password, Forename, Surname, RefreshToken, Expiry) VALUES (%s, %s, %s, %s, %s, %s)"      

            # prevents SQL injection as %s tells the database (MYSQL) that the data being passed through is ONLY data, therefore cannot be used in order to access/alter the database - prevents SQL injection

            cursor.execute(SIGN_UP_SQL_STATEMENT, values)       # adds values, refresh token and expiration date of refresh token to database

            database_connect.commit()   # commits the change to the database

            return jsonify({"message": "You have signed up successfully."}), 200     # python sends back json which gives message to display, and whether operation worked or not
        
        else:       # email was already found in database

            return jsonify({"message": "This email is already in use, please use a different email."}), 400       # user unable to sign up and told to enter a different email

    else:

        return jsonify({"message": "Fields can only be a maximum of 255 characters."}), 400  # values failed the validation check meaning

def log_in():
    data = request.get_json()
    email = data.get('Email')
    password = data.get('Password')

    if ValidationCheck((email, password)):      # less than 255 chars

        email_check = verify_email(email)

        if not email_check:

            return jsonify({"message":"This email isn't associated with an account. Please sign up instead."}), 400     # returns a json with an error status code (400)
                                                                                                                        # email not in database so user might want to sign up instead

        CHECK_STORED_PASSWORD = "SELECT Password FROM Users WHERE Email = %s"

        cursor.execute(CHECK_STORED_PASSWORD, (email,))

        stored_password = cursor.fetchall()

        if not stored_password:

            return jsonify({"message":"Error, email with password not found."}), 400

        check_password = verify_password(password, stored_password)        # function compares both passwords, if both are the same true is returned, else false

        if check_password:      # passwords match, correct user has been found

            user_id = get_user_id(email)        # fetches the UserID

            access_token = generate_access_token(user_id)      # func returns a jwt access token

            return jsonify({"access_token": access_token}), 200         # returns the access token as well as a status code
        
        return jsonify({"message": "Password was incorrect, please try again."}), 400       # passwords did not match, user not logged in



            

            









if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)