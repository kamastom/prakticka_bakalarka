
import hashlib
import sys
import mysql.connector
import os
import pyotp
import time
import getpass

counter = int(0)
secret = pyotp.random_base32()
hotp = pyotp.HOTP(secret)
jmeno = input('zadaj jmeno: ')
prijmeni = input('zadaj prijmeni: ')

ii = 1
while ii == 1:
    p = getpass.getpass(prompt='zadaj nove heslo')
    if len(p) < 6:
        print('heslo je kratke, skus znova')
        continue
    p2 = getpass.getpass(prompt='zopakuj zadane heslo')
    if p == p2 :
        print ('heslo ok')
        ii = 0
    else:
        print ('hesla sa nezhoduju!!, skus znova')
print('heslo prijate')

plain = p
encoded = hashlib.sha512(plain.encode()).hexdigest().lower()

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
    print (username)
    cursor.execute("SELECT username FROM user WHERE username ='" + username + "'")
    jetam = cursor.fetchone()

sql = "INSERT INTO user (username, password, jmeno, prijmeni, counter, HOTP) VALUES (%s, %s, %s, %s, %s, %s)"
val = (username,encoded,jmeno,prijmeni,counter,secret)
cursor.execute(sql, val)
mydb.commit()

print('qr code pre nastavenie FreeOTP')
os.system('qrencode -t utf8 <<< otpauth://hotp/'+ username +'?secret='+ secret)
                
print ("hash = " , encoded )


