from MySQLdb import cursors
from flask import Flask, render_template, request, session, url_for
from flask_mysqldb import MySQL
import hashlib
import unidecode

from werkzeug.utils import redirect

# Application config
app = Flask(__name__)   # Flask instance
app.secret_key = b'_5#loL"Fas4z\n\x92]/'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mojaWIFI4*'
app.config['MYSQL_DB'] = 'mydb'
app.config['MYSQL_HOST'] = 'localhost'


mysql = MySQL(app)  # MySQL instance

# Initialize database cursor
with app.app_context():
    conn = mysql.connect
    cursor = conn.cursor(cursors.DictCursor)    # cursor that returns values as dict


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
def login():
    """ Handle logging in """
    if request.method == 'POST':

        # Get login and password from form
        r_login = request.form['login']
        r_password = request.form['password']

        # Check for empty strings
        if not r_login or not r_password:
            return render_template('login.html', invalid=True)

        # Fetch entry from database
        cursor.execute("SELECT username, password FROM user WHERE username ='" + r_login + "'")
        user = cursor.fetchone()

        # If user is not in the database
        if not user:
            return render_template('login.html', invalid=True)

        # Check password hash
        match = check_hash(r_password, user['password'])

        if match is True:
            # Start new session
            session.clear()
            session['user_id'] = user['username']
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
    else:
         return redirect(url_for('login'))



def check_hash(plain, hashed):
    """ Check MD5 hashes """
    encoded = hashlib.sha512(plain.encode()).hexdigest().lower()
  #  encodedd = hashlib.md5(hashed.encode()).hexdigest().lower()

    return encoded == hashed.lower()



if __name__ == '__main__':
   app.run(ssl_context=('cert.pem','key.pem'),host='0.0.0.0')
   ##app.run()
