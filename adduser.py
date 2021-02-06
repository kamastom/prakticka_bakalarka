
import hashlib
import sys
import mysql.connector



jmeno = sys.argv[1]
prijmeni = sys.argv[2]
plain = sys.argv[3]
encoded = hashlib.md5(plain.encode()).hexdigest().lower()


mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="mojaWIFI4",
        database="mydb"
)



cursor = mydb.cursor()



i = -1
x = -1
username=""
y = 0
cislo = 0

iterator = 0
jetam = 1
while jetam: 
    username=""
      
    if iterator >= 3: 
        i = 0
        x = 0   
        y = 1
    else:        
        i = i + 1
        x = x + 1
        y = y + 1

    for x in range (y):
        username = username + jmeno[x]


    for i in range(5):
        username = username + prijmeni[i]

    if iterator >= 3:
        cislo = cislo + 1        
        username = username + str(cislo)

    iterator = iterator + 1 
    #print (username)
    cursor.execute("SELECT username FROM user WHERE username ='" + username + "'")
    jetam = cursor.fetchone()



sql = "INSERT INTO user (username, password, jmeno, prijmeni) VALUES (%s, %s, %s, %s)"
val = (username,encoded,jmeno,prijmeni)
cursor.execute(sql, val)
mydb.commit()

                
print ("hash = " , encoded )


