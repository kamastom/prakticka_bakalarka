#!/usr/bin/python3
import os
import pyotp
import time 
#secret = 'DXVWMC4R4WWHXOLXH344SF2LWRRQVNC5'
secret = 'BASE32SECRET3232'
totp = pyotp.HOTP(secret)
name = "shewi"

#os.system('"echo" '+ slovo +' "again"')

#os.system("qrencode -m 2 -t utf8 <<< \"otpauth://totp/moja%20App:login%40google.com?secret="+ secret +"&issuer=moje%20App\"")

#os.system('qrencode -m 2 -t utf8 <<< otpauth://hotp/'+ name +'?secret='+ secret +'&counter=100')
os.system('qrencode  -t utf8 <<< otpauth://hotp/shewi?secret=BASE32SECRET3232&')
time.sleep(1)
print(totp.at(0))
print(totp.at(99))
print(totp.at(100))


