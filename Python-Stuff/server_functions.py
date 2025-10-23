from flask import Flask, request, jsonify
from pathlib import Path
from dotenv import load_dotenv
import os
import bcrypt
import time
import hashlib
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

def hash_token(token):

    return hashlib.sha256((token + PEPPER).encode()).hexdigest()       # encodes the token with SHA256 so hashed, but can be checked quickly

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

def verify_refresh_token(user_id, old_token):

    hashed_token = hash_token(old_token)        # returns the hash of the token

    GET_EXPIRY_STATEMENT = "SELECT Expiry FROM RefreshToken WHERE UserID = %s and Token = %s"

    cursor.execute(GET_EXPIRY_STATEMENT, (user_id, hashed_token))       # fetches current refresh token and expiry for specific device

    values = cursor.fetchone()

    if values:

        expiration_date = values     # assigns result to expiration date

        current_utc_time = datetime.now(timezone.utc)   # gets current time

        if expiration_date < current_utc_time:          # expiration date has been passed

            return False
        
        else:       # in order to keep rotating, when an action is carried out, the refresh token is automatically updated

            update_refresh_token(user_id, old_token)        # refresh token is updated to current time so user doesn't have to enter log in credentials for another 30 days

            return True         # refresh token was found and is still valid

    else:

        return False        # refresh token or user id did not match / didn't exist

def add_refresh_token(email):       # inserts new refresh token into database

    user_id = get_user_id(email)

    new_refresh_token = generate_refresh_token()    # generates new refresh token, plain one is sent back to user

    hashed_new_refresh_token = hash_token(new_refresh_token)       # hashes refresh token for database

    new_expiry_date = datetime.now(timezone.utc) + timedelta(days=30)   # sets new expiry time

    new_created_at = datetime.now(timezone.utc)     # gets new current time

    ADD_REFRESH_TOKEN_STATEMENT = "INSERT INTO Refresh_Tokens (UserID, Token, Expiry, Created_At) VALUES (%s, %s, %s, %s)"

    values = (user_id, hashed_new_refresh_token, new_expiry_date, new_created_at)

    cursor.execute(ADD_REFRESH_TOKEN_STATEMENT, values)

    database_connect.commit()

    return new_refresh_token        # returns the unhashed refresh token

def update_refresh_token(email, old_token):     # updates outdated refresh token in database

    user_id = get_user_id(email)

    hashed_old_token = hash_token(old_token)    # gets hash of the old plain text token

    new_refresh_token = generate_refresh_token()    # generates new refresh token, plain one is sent back to user

    hashed_new_refresh_token = hash_token(new_refresh_token)       # hashes refresh token for database

    new_expiry_date = datetime.now(timezone.utc) + timedelta(days=30)   # sets new expiry time

    new_created_at = datetime.now(timezone.utc)     # gets new current time

    UPDATE_REFRESH_TOKEN_STATEMENT = "UPDATE Refresh_Tokens SET Token = %s, Expiry = %s, Created_At = %s WHERE UserID = %s and Token = %s"  
                                                    
                                                    # sql statement that updates the refresh token, expiration date and created_at

    values = (hashed_new_refresh_token, new_expiry_date, new_created_at, user_id, hashed_old_token)

    cursor.execute(UPDATE_REFRESH_TOKEN_STATEMENT, values)

    database_connect.commit()

    return new_refresh_token        # returns plain refresh token


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

    result_user_id = cursor.fetchone()      # stores returned UserID

    return result_user_id[0]        # returns the string value of the user id

def verify_email(email):        # verifies whether the email is in the database or not

    CHECK_FOR_EMAIL_STATEMENT = "SELECT Email FROM Users WHERE Email = %s"      # SQL statement that looks for a particular email in the database

    cursor.execute(CHECK_FOR_EMAIL_STATEMENT, (email,))     # executes the email search statement

    result = cursor.fetchone()     # stores response from database
    
    return bool(result)     # if exists, true returned, if doesnt exist false is returned



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

        if email_check is False:     # if the email is not already in use (false was returned), the user can sign up successfully

            values = (email, hashed_password, forename, surname)       # remakes values tuple so all data can be inputted together

            SIGN_UP_SQL_STATEMENT = "INSERT INTO Users (Email, Password, Forename, Surname) VALUES (%s, %s, %s, %s)"      

            # prevents SQL injection as %s tells the database (MYSQL) that the data being passed through is ONLY data, therefore cannot be used in order to access/alter the database - prevents SQL injection

            cursor.execute(SIGN_UP_SQL_STATEMENT, values)       # adds values, refresh token and expiration date of refresh token to database

            database_connect.commit()   # commits the change to the database

            time.sleep(0.25)

            plain_refresh_token = add_refresh_token(email)      # adds new refresh token into database and returns plain text refresh token to send to user

            return jsonify({"message": "You have signed up successfully.", "refresh_token": plain_refresh_token}), 200     # python sends back json which gives message to display, and whether operation worked or not
        
        else:       # email was already found in database

            return jsonify({"message": "This email is already in use, please use a different email."}), 400       # user unable to sign up and told to enter a different email

    else:

        return jsonify({"message": "Fields can only be a maximum of 255 characters."}), 400  # values failed the validation check meaning
    
@app.route('/log_in', methods=['POST'])
def log_in():
    data = request.get_json()
    email = data.get('Email')
    password = data.get('Password')
    current_refresh_token = data.get('RefreshToken')

    if ValidationCheck((email, password)):      # less than 255 chars

        email_check = verify_email(email)

        if not email_check:

            return jsonify({"message":"Account with this email does not exist."}), 400     # returns a json with an error status code (400)
                                                                                                                        # email not in database so user might want to sign up instead

        CHECK_STORED_PASSWORD = "SELECT Password FROM Users WHERE Email = %s"

        cursor.execute(CHECK_STORED_PASSWORD, (email,))

        stored_password = cursor.fetchone()[0]

        if not stored_password:

            return jsonify({"message":"Error, email with password not found."}), 400

        check_password = verify_password(password, stored_password)        # function compares both passwords, if both are the same true is returned, else false

        if check_password:      # passwords match, correct user has been found

            user_id = get_user_id(email)

            if current_refresh_token is None:       # user is logging in from different device, so new refresh token needs to be issued

                plain_refresh_token = add_refresh_token(email)

            else:       # user has logged in before on device, just needs to update refresh token

                plain_refresh_token = update_refresh_token(email, current_refresh_token)


            access_token = generate_access_token(user_id)      # func returns a jwt access token

            return jsonify({"access_token": access_token, "refresh_token": plain_refresh_token}), 200         # returns the access token, refresh token as well as a status code
        
        return jsonify({"message": "Password was incorrect, please try again."}), 400       # passwords did not match, user not logged in



            

            









if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)