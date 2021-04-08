#!/usr/bin/python3
from MySQLdb import cursors
from flask import Flask, render_template, request, session, url_for , flash , send_from_directory , send_file 
from flask_mysqldb import MySQL
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from Crypto.Cipher import AES
from simplecrypt import encrypt, decrypt
from cryptography.fernet import Fernet
import hashlib
import unidecode
import os
import os.path
import subprocess
import shlex
from werkzeug.utils import secure_filename
from werkzeug.utils import redirect
from threading import Thread
import time 
from datetime import timedelta
import pyotp

# Application config
app = Flask(__name__)   # Flask instance
app.secret_key = b'_5#loL"Fas4z\n\x92]/' # use new key 
app.config['MYSQL_USER'] = 'root'  #username for the database
app.config['MYSQL_PASSWORD'] = 'mojaWIFI4' #password for the database
app.config['MYSQL_DB'] = 'mydb' #name of your db
app.config['MYSQL_HOST'] = 'localhost' 
app.config['UPLOAD_FOLDER'] = 'files'  #destination for uploaded files
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=60) #auto logout 
ALLOWED_EXTENSIONS = {'txt','png','jpg','jpeg'} #replace with your own extensions


mysql = MySQL(app)  # MySQL instance

# Initialize database cursor
with app.app_context():
    conn = mysql.connect
    cursor = conn.cursor(cursors.DictCursor)    # cursor that returns values as dict
    limiter = Limiter( app,key_func=get_remote_address, default_limits=["3/second"]  )

@app.route('/')

def index():

    if session:

        # Get all courses
        cursor.execute("SELECT * FROM pacient")
                 
        pacient = cursor.fetchall()

        return render_template('index.html', pacient=pacient)
    else:
       return redirect(url_for('login'))

    
@app.route('/login', methods=['GET', 'POST'])
#@limiter.limit("3/second")
def login():
    """ Handle logging in """
    if request.method == 'POST':

        # Get login and password from form
        r_login = request.form['login']
        r_password = request.form['password']
        r_token = request.form['token']

        # Check for empty strings
        if not r_login or not r_password or not r_token:
           
            return render_template('login.html', invalid=True)

        # Fetch entry from database
        cursor.execute("SELECT  * FROM user WHERE username = %s;",(r_login,))
        user = cursor.fetchone()

        # If user is not in the database
        if not user:
            return render_template('login.html', invalid=True)

        # Check password hash
        match = check_hash(r_password, user['password'])
        hotp = check_token(r_token, user['HOTP'], user['counter'])
        if match is True and hotp != 0:
            # Start new session
            session.clear()
            session['user_id'] = user['username']
            cursor.execute("UPDATE user SET counter= %s WHERE username= %s;", (str(hotp),r_login))
            conn.commit()
            #session.permanent = True
            return redirect(url_for('index'))           
        else:
            return render_template('login.html', invalid=True)

    return render_template('login.html')


@app.route('/logout')
def logout():
    """ Clear session """
    session.clear()
    return redirect(url_for('login'))


@app.route('/diagnozy/<ID>')
def diagnoza_table(ID):
    if session:
        cursor.execute("SELECT * FROM diagnoza_table WHERE pacient_ID = \'" + ID + "\' ")
        diagnoza_table = cursor.fetchall()
        cursor.execute("SELECT * FROM pacient WHERE ID = \'" + ID + "\' ")
        pacient = cursor.fetchone()
    
        return render_template('diagnozy.html', diagnoza_table = diagnoza_table , pacient=pacient)
    else:
         return redirect(url_for('login'))


@app.route('/diagnosticke_vysetrenia/<ID>')
def diagnosticke_vysetrenia(ID):
    
    if session:
         cursor.execute("SELECT * FROM Diagnosticke_vysetrenie WHERE diagnoza_table_ID = \'" + ID + "\' " )
         vysetrenie = cursor.fetchall()
         cursor.execute("SELECT * FROM pacient WHERE ID =(select diagnoza_table_pacient_ID from Diagnosticke_vysetrenie where diagnoza_table_ID = \'" + ID + "\' LIMIT 1)")
         pacient = cursor.fetchone()
         cursor.execute("SELECT * FROM diagnoza_table where ID =  \'" + ID + "\'  ")
         dia = cursor.fetchone()
         return render_template('diagnosticke_vysetrenie.html', vysetrenie = vysetrenie , pacient = pacient , dia = dia )
    else:
         return redirect(url_for('login'))


@app.route('/ukoly/<ID>')
def ukoly(ID):
    if session:
        cursor.execute("SELECT * FROM ukol WHERE Diagnosticke_vysetrenie_ID = \'" + ID + "\'")
        ukoly = cursor.fetchall()
        cursor.execute("SELECT * FROM pacient WHERE ID =(select Diagnosticke_vysetrenie_diagnoza_table_pacient_ID from ukol where Diagnosticke_vysetrenie_ID = \'" + ID + "\' LIMIT 1)")
        pacient = cursor.fetchone()
        cursor.execute("SELECT * FROM Diagnosticke_vysetrenie WHERE ID = \'" + ID + "\' ")
        dia_vysetrenie = cursor.fetchone()
        return render_template('ukoly.html' , ukoly = ukoly , pacient = pacient , dia_vysetrenie = dia_vysetrenie)
    else :
         return redirect(url_for('login'))


@app.route('/upload/<ID>', methods = ['GET', 'POST'])
def nahravanie(ID):
    if session: 
        if request.method == 'POST':
            if 'file' not in request.files:
                flash('No file part')
                return redirect(request.url)
            file = request.files['file']
            if file.filename == '':
                flash('No selected file')
                return redirect(request.url)
            if file and allowed_file(file.filename):
                name = secure_filename(file.filename)
                filename = ID + "_" + str(name)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'],filename))
                key = b'yOHPDHMuGmoX2yqPWIXQ8exHObui08CbM1R1AskJt1A='
                fernet = Fernet(key)

                with open(os.path.join(app.config['UPLOAD_FOLDER'],filename),'rb') as file:
                    mojfile = file.read()
                enfile = fernet.encrypt(mojfile)
                
                with open(os.path.join(app.config['UPLOAD_FOLDER'],filename),'wb') as encrypted_file:
                    encrypted_file.write(enfile)

                file_length = os.stat(os.path.join(app.config['UPLOAD_FOLDER'],filename)).st_size
                cursor.execute("SELECT CAST( Diagnosticke_vysetrenie_ID AS CHAR (15)) from ukol WHERE ID=\'" + ID + "\' ")
                ukol = cursor.fetchone()
                cursor.execute("UPDATE ukol SET subor_grafickeho_tabletu=\'" + str(name) + "\' , datum_zmeny=curdate() ,"
                        " velkost_suboru=\'" + str((file_length/1048576))  + "\'   WHERE ID=\'" + ID + "\' ")
                conn.commit()
                return redirect('/ukoly/' + ukol['CAST( Diagnosticke_vysetrenie_ID AS CHAR (15))'] + '')


        else:
            cursor.execute("SELECT subor_grafickeho_tabletu FROM ukol WHERE ID=\'" + ID + "\'")
            name = cursor.fetchone()
            subor = ID + "_" +str(name['subor_grafickeho_tabletu'])
             
            if os.path.isfile(os.path.join(app.config['UPLOAD_FOLDER'],str(subor))):
                key = b'yOHPDHMuGmoX2yqPWIXQ8exHObui08CbM1R1AskJt1A='
                fernet = Fernet(key)
                with open(os.path.join(app.config['UPLOAD_FOLDER'],subor),'rb') as enc_file:
                    enfile = enc_file.read()

                mojfile = fernet.decrypt(enfile)

                with open(os.path.join(app.config['UPLOAD_FOLDER'],subor), 'wb') as dec_file:
                    dec_file.write(mojfile)

                result = send_file(os.path.join(app.config['UPLOAD_FOLDER'],subor),as_attachment=True)
               
                #with open(os.path.join(app.config['UPLOAD_FOLDER'],subor), 'wb') as dec_file:
                #    dec_file.write(enfile)
                def vymaz():
                    time.sleep(1)
                    with open(os.path.join(app.config['UPLOAD_FOLDER'],subor), 'wb') as dec_file:
                        dec_file.write(enfile)
                    
                vymaz_thread = Thread(target=vymaz)
                vymaz_thread.start()

                #result = send_from_directory(app.config['UPLOAD_FOLDER'],str(subor),as_attachment=True)
                return result
                #return send_from_directory(app.config['UPLOAD_FOLDER'],str(subor),as_attachment=True)
            else: 
                return render_template('upload.html')
    else:
       return redirect(url_for('login'))
        

@app.after_request
def add_security_headers(resp):
    resp.headers['Content-Security-Policy']='default-src \'self\''
    return resp

#@app.before_request
#def before_request():
#        if request.url.startswith('http://'):
#            url = request.url.replace('http://', 'https://', 1)
#            code = 301
#            return redirect(url, code=code)


def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def check_hash(plain, hashed):
    
    encoded = hashlib.sha512(plain.encode()).hexdigest().lower()
    return encoded == hashed.lower()


def check_token(token, secret , counter):
    hotp = pyotp.HOTP(secret)

    for i in range(1, 10): 
        if hotp.verify(token , (counter + i)):
            return counter + i 
    return 0
    


if __name__ == '__main__':
   # app.run(ssl_context=('cert.pem','key.pem'),host='0.0.0.0', port=9090 )
   app.run(host='0.0.0.0')
   
   
