from flask import Flask, request, jsonify
from pathlib import Path
from dotenv import load_dotenv
import os
import bcrypt
import time
import decimal
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
401 - SESSION EXPIRED, NEED TO REFRESH APP

"""



env_path = Path(__file__).parent / "variables.env"  # always relative to this script
load_dotenv(dotenv_path=env_path)       # loads in private variables

database_connect = mysql.connector.connect(         # establishes connection to database
    host="busjnxucxfrgmdm98osn-mysql.services.clever-cloud.com",
    user="uwtqmxvfn5nnuyyz",
    password="00APgARo34fUFrh0Cj1w",     # information to specify database to add to
    database="busjnxucxfrgmdm98osn"     # host, username, password and database name
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
@app.route('/generate_access_token', methods=['POST'])
def generate_access_token(user_id = None):     # function to generate an access token

    cur_user_id = user_id
    
    if cur_user_id is None:

        data = request.get_json()

        user_id = data.get('UserID')

        if user_id is None:
            
            return jsonify({}), 400

    payload = {                         # creates payload with the UserID and how long the token lasts for
        "user_id": user_id,
        "exp": datetime.now(timezone.utc) + timedelta(minutes=30)  # lasts 30 mins, measures time in UTC so that local time doesn't mess up processing
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")     # adds payload and secret signature as well as algorithm to hash the file
                                                                   # when it arrives, this will check that the original reuest sent is the same as the one recieved

    if cur_user_id is None:     # return statement for flutter call for new access token

        return jsonify({"access_token": token}), 200        # returns the access token for the user to use for their session
    
    else:       # return statement for python function

        return token
@app.route('/verify_access_tokens', methods=['POST'])
def verify_access_token(token):     # function to verify an access token
    try:        # try and except statements are used because jwt returns particular errors rather than just a true or false
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return True, payload["user_id"]
    except jwt.ExpiredSignatureError:       # token expired, most common error
        return False, "Token expired"           
    except jwt.InvalidTokenError:       # token was invalid
        return False, "Invalid token"           # the bool statements will be used by whatever the original function was
                                                # to determine whether the access token was correct or not

def generate_user_id():

    unique_id = False   

    while unique_id is False:   # could use while True/False but prefer this more understandable approach

        user_id = secrets.token_urlsafe(32)

        CHECK_USER_ID_STATEMENT = "SELECT 1 FROM Users WHERE UserID = %s"

        cursor.execute(CHECK_USER_ID_STATEMENT, (user_id,))

        result = cursor.fetchone()

        if not result:  # userid doesn't exist, it is unique

            unique_id = True

            return user_id

def generate_customer_id():     # generates a unique customer id

    unique_id = False   

    while unique_id is False:

        cust_id = secrets.token_urlsafe(32)

        CHECK_USER_ID_STATEMENT = "SELECT 1 FROM UserCustomer WHERE CustomerID = %s"

        cursor.execute(CHECK_USER_ID_STATEMENT, (cust_id,))

        result = cursor.fetchone()

        if not result:  # userid doesn't exist, it is unique

            unique_id = True

            return cust_id

@app.route('/verify_refresh_token', methods =['POST'])
def verify_refresh_token():
    
    data = request.get_json()

    user_id = data.get('UserID')
    old_token = data.get('RefreshToken')

    print(user_id)
    print(old_token)

    if old_token is None:

        return jsonify({'message': 'User has not logged in.'}), 400

    hashed_token = hash_token(old_token)        # returns the hash of the token

    GET_EXPIRY_STATEMENT = "SELECT Expiry FROM Refresh_Tokens WHERE UserID = %s and Token = %s"

    cursor.execute(GET_EXPIRY_STATEMENT, (user_id, hashed_token))       # fetches current refresh token and expiry for specific device

    values = cursor.fetchone()

    if values:

        expiration_date = values[0]     # assigns result to expiration date

        current_utc_time = datetime.now(timezone.utc)   # gets current time

        if expiration_date.tzinfo is None:      # tell Python that this datetime variable is UTC
            expiration_date = expiration_date.replace(tzinfo=timezone.utc)

        if expiration_date < current_utc_time:          # expiration date has been passed

            return jsonify({'message': 'Token has expired.'}), 400
        
        else:

            new_refresh_token = update_refresh_token(user_id, old_token)      

            return jsonify({"refresh_token": new_refresh_token}), 200   

    else:

        return jsonify({'message': values}), 400        # refresh token or user id did not match / didn't exist

def add_refresh_token(user_id):       # inserts new refresh token into database

    new_refresh_token = generate_refresh_token()    # generates new refresh token, plain one is sent back to user

    hashed_new_refresh_token = hash_token(new_refresh_token)       # hashes refresh token for database

    new_expiry_date = datetime.now(timezone.utc) + timedelta(days=30)   # sets new expiry time

    new_created_at = datetime.now(timezone.utc)     # gets new current time

    ADD_REFRESH_TOKEN_STATEMENT = "INSERT INTO Refresh_Tokens (UserID, Token, Expiry, Created_At) VALUES (%s, %s, %s, %s)"

    values = (user_id, hashed_new_refresh_token, new_expiry_date, new_created_at)

    cursor.execute(ADD_REFRESH_TOKEN_STATEMENT, values)

    database_connect.commit()

    return new_refresh_token        # returns the unhashed refresh token

def update_refresh_token(user_id, old_token):     # updates outdated refresh token in database

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
    access_token = data.get('AccToken')
    user_id = data.get('UserID')        # this is the foreign key that will link each customer to a particular user

    acc_tok_validitiy = verify_access_token(access_token)

    if not acc_tok_validitiy:

        return jsonify({"message": "Session has expired."}), 401
    
    customer_id = generate_customer_id()

    values = (customer_id, name, address, regularity, email, phone, add_info)        # creates tuple which can be passed into SQL statement

    if ValidationCheck(values):         # if true is returned, sql can proceed

        CUSTOMER_STATEMENT = "INSERT INTO Customers (CustomerID, Name, Address, Regularity, Email, Phone, Additional_Information) VALUES (%s, %s, %s, %s, %s, %s, %s)"      

        # prevents SQL as %s tells the database (MYSQL) that the data being passed through is ONLY data, therefore cannot be used in order to access/alter the database - prevents SQL injection

        cursor.execute(CUSTOMER_STATEMENT, values)       # adds values to database

        database_connect.commit()   # commits the change to the database

    else:

        return jsonify({"message": "Fields can only be a maximum of 255 characters."}), 401

    user_job_values = (str(user_id), str(customer_id))

    if ValidationCheck(user_job_values):

        USER_CUSTOMER_STATEMENT = "INSERT INTO UserCustomer (UserID, CustomerID) VALUES (%s, %s)"

        cursor.execute(USER_CUSTOMER_STATEMENT, user_job_values)

        database_connect.commit()

        return jsonify({'message': 'Customer successfully added.'}), 200

    else:

        return jsonify({"message": "Fields can only be a maximum of 255 characters."}), 401



@app.route('/get_customers', methods=['GET'])
def get_customers():
    data = request.get_json()
    user_id = data.get('UserID')
    access_token = data.get('AccToken')

    acc_tok_validitiy = verify_access_token(access_token)

    if not acc_tok_validitiy:

        return jsonify({"message": "Session has expired."}), 401
        

    GET_CUSTOMERS_STATEMENT = "SELECT c.Name, c.CustomerID FROM UserCustomer uc JOIN Customer c ON uc.CustomerID = c.CustomerID WHERE uc.UserID = %s"       # makes use of the linking table

    cursor.execute(GET_CUSTOMERS_STATEMENT, user_id,)

    database_connect.commit()

    names_and_ids = cursor.fetchall()      # only names are shown, but user will be able to find more information
                                        # on each customer if needed with their customer id.

    if not names_and_ids:

        return jsonify({"message": "You currently have no customers."}), 400

    customer_list = [{"Name": cust[0], "CustID": cust[1]} for cust in names_and_ids]

    return jsonify({"CustomerList": customer_list}), 200

    

    
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

            user_id = generate_user_id()

            values = (user_id, email, hashed_password, forename, surname)       # remakes values tuple so all data can be inputted together

            SIGN_UP_SQL_STATEMENT = "INSERT INTO Users (UserID, Email, Password, Forename, Surname) VALUES (%s, %s, %s, %s, %s)"      

            # prevents SQL injection as %s tells the database (MYSQL) that the data being passed through is ONLY data, therefore cannot be used in order to access/alter the database - prevents SQL injection

            cursor.execute(SIGN_UP_SQL_STATEMENT, values)       # adds values, refresh token and expiration date of refresh token to database

            database_connect.commit()   # commits the change to the database

            plain_refresh_token = add_refresh_token(user_id)      # adds new refresh token into database and returns plain text refresh token to send to user

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

                plain_refresh_token = add_refresh_token(user_id)

            else:       # user has logged in before on device, just needs to update refresh token

                plain_refresh_token = update_refresh_token(user_id, current_refresh_token)

            access_token = generate_access_token(user_id)      # func returns a jwt access token

            user_id = str(user_id)

            return jsonify({"access_token": access_token, "refresh_token": plain_refresh_token, "user_id": user_id}), 200         # returns the access token, refresh token as well as a status code
        
        return jsonify({"message": "Password was incorrect, please try again."}), 400       # passwords did not match, user not logged in


@app.route('/add_job', methods=['POST'])
def add_job():
    data = request.get_json()
    accToken = data.get('access_token')
    customer_id = data.get('CustomerID')
    job_time = data.get('Time')
    job_date = data.get('Date')
    add_info = data.get('AddInfo')
    price = data.get('Price')
    user_time_zone = data.get('Timezone')

    values = (job_time, job_date, add_info, price)

    if not ValidationCheck(values):

        return jsonify({"message": "Each field must contain less than 256 characters."}), 400

    if not verify_access_token(accToken):

        return jsonify({"message": "Session has expired."}), 401

    ADD_JOB_STATEMENT = "INSERT INTO Jobs (CustomerID, Time, Date, AddInfo, Price) VALUES(%s, %s, %s, %s, %s)"

    decimal_price = decimal(price)      # allows for greater numerical accuracy

    # same with job_date, i know i will use datetime but i need to know what flutter will use first

    table_values = (customer_id, job_time, job_date, add_info, decimal_price)

    cursor.execute(ADD_JOB_STATEMENT, table_values)

    database_connect.commit()

    return jsonify({"message": "Job was successfully added."}), 200

def get_jobs():

    data = request.get_json()
    user_id = data.get('UserID')
    accToken = data.get('AccessToken')

    if not verify_access_token(accToken):

        return jsonify({'message': 'Session expired.'}), 400
    
    GET_JOBS_STATEMENT = "SELECT job.JobID, job.CustomerID, job.Time, job.Date, job.AddInfo, job.Price FROM UserJob uj JOIN Jobs job ON uj.JobID = job.JobID WHERE uj.UserID = %s"

    cursor.execute(GET_JOBS_STATEMENT, (user_id,))

    job_desc = cursor.fetchall()

    if not job_desc:

        return jsonify({'message': 'You currently have no jobs.'}), 400

    job_list = [{"JobID": job[0], "CustomerID": job[1], 'Time': job[2], 'Date': job[3], 'AddInfo': job[4], 'Price': job[5]} for job in job_desc]

    return jsonify({'Jobs': job_list}), 200     # returns list of all jobs user currently has













if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)